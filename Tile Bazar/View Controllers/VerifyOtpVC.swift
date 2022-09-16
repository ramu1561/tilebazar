//
//  VerifyOtpVC.swift
//  Tile Bazar
//
//  Created by Apple on 8/15/22.
//

import UIKit

class VerifyOtpVC: TBParentVC {

    @IBOutlet weak var tfOTP: SkyFloatingLabelTextField!
    var phone_number = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 12.0, *) {
            tfOTP.textContentType = .oneTimeCode
        } else {
            // Fallback on earlier versions
        }
        tfOTP.delegate = self
        // Do any additional setup after loading the view.
    }
    func checkValidation() -> Bool{
        if tfOTP.text?.isEmptyOrWhitespace() ?? true{
            tfOTP.errorMessage = NSLocalizedString("Enter OTP Code", comment: "")
            return false
        }
        return true
    }
    @IBAction func toggleBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func toggleButtons(_ sender: UIButton) {
        if sender.tag == 1{
            //verify
            if checkValidation(){
                self.wsCallVerifyOTP(phone_number: phone_number, access_code: tfOTP.text ?? "")
            }
        }
        else{
            //resend
            self.tfOTP.text = ""
            self.wsCallResendOTP()
        }
    }
}
//MARK: - Textfield delegate methods
extension VerifyOtpVC : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
            // The error message will only disappear when we reset it to nil or empty string
            floatingLabelTextField.errorMessage = ""
        }
        if textField == tfOTP{
            let maxLength = 4
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
    
}
//MARK: Web Service calls
extension VerifyOtpVC{
    private func wsCallVerifyOTP(phone_number:String,access_code:String){
        self.showSpinner()
        let param = ["phone_number":phone_number,
                     "access_code":self.tfOTP.text ?? ""]
        WSCalls.sharedInstance.apiCall(url: WSRequest.verifyNumber, method: .post, param: param, successHandler: { (response, statuscode) in
            print("Success Response: \(response)")
            self.hideSpinner()
            userInfo = UserInformation(dictinfo: response["Data"] as? [String : Any] ?? [:])
            if let item = response["Data"]?.object(forKey: "name"){
                UserDefaults.standard.set(item, forKey: "user_name")
            }
            if let item = response["Data"]?.object(forKey: "image"){
                UserDefaults.standard.set(item, forKey: "user_image")
            }
            if let item = response["Data"]?.object(forKey: "company_name"){
                UserDefaults.standard.set(item, forKey: "user_company_name")
            }
            if let item = response["Data"]?.object(forKey: "city"){
                UserDefaults.standard.set(item, forKey: "user_city")
            }
            
            do{
                //Login success, goto dashboard
                let data = try JSONEncoder().encode(userInfo)
                let rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "TBTabbar") as! UITabBarController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = rootViewController
                Helper.setDatainUserDefault(value:data, "UserInformation")
            }
            catch{
                
            }
            
            
        }, erroHandler: { (response, statuscode) in
            self.hideSpinner()
            self.showAlert(msg: response["Message"] as? String ?? "")
            
        }) { (error) in
            self.hideSpinner()
            print("Error Response: \(error)")
        }
    }
    private func wsCallResendOTP(){
        self.showSpinner()
        let param = ["phone_number":self.phone_number]
        WSCalls.sharedInstance.apiCall(url: WSRequest.resendCode, method: .post, param: param, successHandler: { (response, statuscode) in
            print("Success Response: \(response)")
            self.hideSpinner()
            
        }, erroHandler: { (response, statuscode) in
            self.hideSpinner()
            self.showAlert(msg: response["Message"] as? String ?? "")
            
        }) { (error) in
            self.hideSpinner()
            print("Error Response: \(error)")
        }
    }
}
