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
    var isComingFromRemoveAccount = false
    
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
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        if isComingFromRemoveAccount{
            self.tabBarController?.tabBar.isHidden = false
        }
        else{
            self.tabBarController?.tabBar.isHidden = false
        }
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
                if isComingFromRemoveAccount{
                    self.wsCallVerifyRemoveAccount(access_code: tfOTP.text ?? "")
                }
                else{
                    self.wsCallVerifyOTP(phone_number: phone_number, access_code: tfOTP.text ?? "")
                }
            }
        }
        else{
            //resend
            self.tfOTP.text = ""
            if isComingFromRemoveAccount{
                self.wscallResendRemoveAccount()
            }
            else{
                self.wsCallResendOTP()
            }
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
    func wsCallVerifyRemoveAccount(access_code:String){
       self.showSpinner()
       WSCalls.sharedInstance.apiCallWithHeader(url: WSRequest.verifyRemoveAccount, method: .post, param: ["access_code":access_code], headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (repsonse, statuscode) in
           print(repsonse)
           self.hideSpinner()
           UserDefaults.standard.removeObject(forKey: "UserInformation")
           DispatchQueue.main.async{
               let alert = UIAlertController(title: "", message: NSLocalizedString("Your account has been deleted successfully", comment: ""), preferredStyle:.alert)
               let yes = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style:.default) { _ in
                   self.makeRootViewController()
               }
               alert.addAction(yes)
               self.present(alert, animated: false, completion: nil)
           }
           
       }, erroHandler: { (response, statuscode) in
           print("Error\(response)")
           self.hideSpinner()
           self.showAlert(msg: response["Message"] as? String ?? "")
           
       }) { (error) in
           self.hideSpinner()
           print("Error\(error)")
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
    func wscallResendRemoveAccount(){
       self.showSpinner()
       WSCalls.sharedInstance.apiCallWithHeader(url: WSRequest.removeAccount, method: .get, param: [:], headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (repsonse, statuscode) in
           print(repsonse)
           self.hideSpinner()
           
       }, erroHandler: { (response, statuscode) in
           print("Error\(response)")
           self.hideSpinner()
           self.showAlert(msg: response["Message"] as? String ?? "")
           
       }) { (error) in
           self.hideSpinner()
           print("Error\(error)")
       }
   }
}
