//
//  LoginVC.swift
//  Tile Bazar
//
//  Created by Apple on 8/12/22.
//

import UIKit

class LoginVC: TBParentVC {

    @IBOutlet weak var btnBackIcon: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblLoginTitle: UILabel!
    @IBOutlet weak var lblWhatsYour: UILabel!
    @IBOutlet weak var lblDontHaveAccount: UILabel!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var tfPhoneNumber: SkyFloatingLabelTextField!
    var isComingFromSignUp = false
    var IsRegister = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let arrayCompareProductIDs:[String] = []
        UserDefaults.standard.set(arrayCompareProductIDs, forKey: "arrayCompareProductIDs")
        
        let arrayWatchlistProductIDs:[String] = []
        UserDefaults.standard.set(arrayWatchlistProductIDs, forKey: "arrayWatchlistProductIDs")
        
        let arrayWatchlistSellerIDs:[String] = []
        UserDefaults.standard.set(arrayWatchlistSellerIDs, forKey: "arrayWatchlistSellerIDs")
        
        tfPhoneNumber.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func toggleLoginButtons(_ sender: UIButton) {
        if sender.tag == 1{
            //login
            if checkValidation(){
                self.wsCallLogin()
            }
        }
        else if sender.tag == 2{
            //sign up
            let signUpVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: SignUpVC.self)) as! SignUpVC
            self.navigationController?.pushViewController(signUpVC, animated: true)
            
        }
        else{
            //close
            if isComingFromSignUp{
                self.navigationController?.popViewController(animated: true)
            }
            else{
            UIControl().sendAction(#selector(NSXPCConnection.suspend),
                                   to: UIApplication.shared, for: nil)
            }
        }
    }
    func checkValidation() -> Bool{
        if tfPhoneNumber.text?.isEmptyOrWhitespace() ?? true{
            tfPhoneNumber.errorMessage = NSLocalizedString("Enter Phone Number", comment: "")
            return false
        }
        else if (tfPhoneNumber.text?.count ?? 0) < 10{
            tfPhoneNumber.errorMessage = NSLocalizedString("Phone number must contain 10 digits", comment: "")
            return false
        }
        else if tfPhoneNumber.text?.hasPrefix("0") ?? true{
            tfPhoneNumber.errorMessage = NSLocalizedString("Phone number cannot start with zero", comment: "")
            return false
        }
        return true
    }
}
//MARK: - Textfield delegate methods
extension LoginVC : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
            // The error message will only disappear when we reset it to nil or empty string
            floatingLabelTextField.errorMessage = ""
        }
        if textField == tfPhoneNumber{
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
}
//MARK: Web Service Calls
extension LoginVC{
    private func wsCallLogin(){
        self.showSpinner()
        let param = ["phone_number":self.tfPhoneNumber.text ?? ""]
        WSCalls.sharedInstance.apiCall(url: WSRequest.login, method: .post, param: param, successHandler: { (response, statuscode) in
            print("Success Response: \(response)")
            self.hideSpinner()
            
            if let item = response["IsRegister"]{
                if item is String{
                    self.IsRegister = (item as? String)!
                }
                else if item is Int{
                    self.IsRegister = String(item as! Int)
                }
            }
            else{
                self.IsRegister = ""
            }
            
            if self.IsRegister == "1"{
                let signUpVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: SignUpVC.self)) as! SignUpVC
                signUpVC.phone_number = self.tfPhoneNumber.text ?? ""
                self.navigationController?.pushViewController(signUpVC, animated: true)
            }
            else{
                let verifyOtpVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: VerifyOtpVC.self)) as! VerifyOtpVC
                verifyOtpVC.phone_number = self.tfPhoneNumber.text ?? ""
                self.navigationController?.pushViewController(verifyOtpVC, animated: true)
            }
            
        }, erroHandler: { (response, statuscode) in
            self.hideSpinner()
            self.showAlert(msg: response["Message"] as? String ?? "")
            
        }) { (error) in
            self.hideSpinner()
            print("Error Response: \(error)")
        }
    }
}
extension String {
    func isEmptyOrWhitespace() -> Bool {
        if(self.isEmpty) {
            return true
        }
        return (self.trimmingCharacters(in: NSCharacterSet.whitespaces) == "")
    }
}
