//
//  SignUpVC.swift
//  Tile Bazar
//
//  Created by Apple on 8/20/22.
//

import UIKit

class SignUpVC: TBParentVC,UITextViewDelegate{

    @IBOutlet weak var btnBackIcon: UIButton!
    @IBOutlet weak var tfFullname: SkyFloatingLabelTextField!
    @IBOutlet weak var tfPhoneNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var tfCompanyName: SkyFloatingLabelTextField!
    @IBOutlet weak var tfState: SkyFloatingLabelTextField!
    @IBOutlet weak var tfCity: SkyFloatingLabelTextField!
    @IBOutlet weak var tvAddress: UITextView!
    var placeholderLabel : UILabel!
    var selectedStateID = ""
    static var sharedInstance:SignUpVC?
    var arrStates:[GetCommonIdAndNameDataModel] = []
    
    var isFullnameValidated = false
    var isPhoneNumberValidated = false
    var isCompanyNameValidated = false
    var isStateValidated = false
    var isCityValidated = false
    var phone_number = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignUpVC.sharedInstance = self
        tvAddress.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = NSLocalizedString("Address (Optional)", comment: "")
        placeholderLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        placeholderLabel.sizeToFit()
        tvAddress.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (tvAddress.font?.pointSize)! / 2)
        placeholderLabel.textColor = .lightGray
        
        self.tfPhoneNumber.text = self.phone_number
        
        self.wsCallGetRegisterConfiguration()
        // Do any additional setup after loading the view.
    }
    func textViewDidChange(_ textView: UITextView){
        placeholderLabel.isHidden = !tvAddress.text.isEmpty
    }
    @IBAction func toggleButtons(_ sender: UIButton) {
        if sender.tag == 0{
            self.navigationController?.popViewController(animated: true)
        }
        else if sender.tag == 1{
            //sign up
            if checkValidation(){
                wsCallRegister()
            }
        }
        else{
            //login
            let loginVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: LoginVC.self)) as! LoginVC
            loginVC.isComingFromSignUp = true
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }
    func checkValidation()->Bool{
        if tfFullname.text?.isEmptyOrWhitespace() ?? true{
            isFullnameValidated = false
            tfFullname.errorMessage = NSLocalizedString("Enter Full Name", comment: "")
        }
        else{
            isFullnameValidated = true
        }
        if tfPhoneNumber.text?.isEmptyOrWhitespace() ?? true{
            isPhoneNumberValidated = false
            tfPhoneNumber.errorMessage = NSLocalizedString("Enter Phone Number", comment: "")
        }
        else{
            isPhoneNumberValidated = true
        }
        if tfCompanyName.text?.isEmptyOrWhitespace() ?? true{
            isCompanyNameValidated = false
            tfCompanyName.errorMessage = NSLocalizedString("Enter Company Name", comment: "")
        }
        else{
            isCompanyNameValidated = true
        }
        if tfState.text?.isEmptyOrWhitespace() ?? true{
            isStateValidated = false
            tfState.errorMessage = NSLocalizedString("Select State", comment: "")
        }
        else{
            isStateValidated = true
        }
        if tfCity.text?.isEmptyOrWhitespace() ?? true{
            isCityValidated = false
            tfCity.errorMessage = NSLocalizedString("Enter City", comment: "")
        }
        else{
            isCityValidated = true
        }
        if isFullnameValidated && isPhoneNumberValidated && isCompanyNameValidated && isStateValidated && isCityValidated{
            return true
        }
        else{
            return false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
}
extension SignUpVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
            // The error message will only disappear when we reset it to nil or empty string
            floatingLabelTextField.errorMessage = ""
        }
        if textField == tfFullname{
            let regex = try! NSRegularExpression(pattern: "[a-zA-Z\\s]+", options: [])
            let range = regex.rangeOfFirstMatch(in: string, options: [], range: NSRange(location: 0, length: string.count))
            return range.length == string.count
        }
        else if textField == tfPhoneNumber{
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfState{
            let selectStateVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: SelectStateVC.self)) as! SelectStateVC
            selectStateVC.arrStates = self.arrStates
            self.present(selectStateVC, animated: true, completion: nil)
            return false
        }
        return true
    }
}
extension SignUpVC{
    private func wsCallGetRegisterConfiguration(){
        self.showSpinner()
        WSCalls.sharedInstance.apiCall(url: WSRequest.registerConfiguration, method: .get, param:[:], successHandler: { (response, statuscode) in
            print("Success Response: \(response)")
            self.hideSpinner()
            self.arrStates.removeAll()
            let arrTemp = response["states"] as? [[String:Any]] ?? []
            if arrTemp.count > 0{
                for obj in arrTemp{
                    let obj = GetCommonIdAndNameDataModel(dictinfo: obj)
                    self.arrStates.append(obj)
                }
            }
            
        }, erroHandler: { (response, statuscode) in
            self.hideSpinner()
            self.showAlert(msg: response["Message"] as? String ?? "")
            
        }) { (error) in
            self.hideSpinner()
            print("Error Response: \(error)")
        }
    }
    private func wsCallRegister(){
        self.showSpinner()
        let param = ["phone_number":self.tfPhoneNumber.text ?? "",
                     "name":self.tfFullname.text ?? "",
                     "city":self.tfCity.text ?? "",
                     "state_id":self.selectedStateID,
                     "company_name":self.tfCompanyName.text ?? "",
                     "address":self.tvAddress.text ?? ""]
        
        WSCalls.sharedInstance.apiCall(url: WSRequest.register, method: .post, param: param, successHandler: { (response, statuscode) in
            print("Success Response: \(response)")
            self.hideSpinner()
            let verifyOtpVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: VerifyOtpVC.self)) as! VerifyOtpVC
            verifyOtpVC.phone_number = self.tfPhoneNumber.text ?? ""
            self.navigationController?.pushViewController(verifyOtpVC, animated: true)
            
        }, erroHandler: { (response, statuscode) in
            self.hideSpinner()
            self.showAlert(msg: response["Message"] as? String ?? "")
            
        }) { (error) in
            self.hideSpinner()
            print("Error Response: \(error)")
        }
    }
    
    
}
