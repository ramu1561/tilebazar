//
//  ReportPostVC.swift
//  Tile Bazar
//
//  Created by Apple on 8/22/22.
//

import UIKit

class ReportPostVC: ParentVC,UITextViewDelegate{

    @IBOutlet weak var tfIssueType: SkyFloatingLabelTextField!
    @IBOutlet weak var tvNote: UITextView!
    var placeholderLabel : UILabel!
    var product_id = ""
    var user_id = ""
    var isSellerReport = false
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var viewToolbar: UIView!
    @IBOutlet var pickerView: UIPickerView!
    var arrIssueTypes = ["Price","Quality","Delivery","Cheating","Other"]
    var selectedPickerRow:Int = 0
    @IBOutlet weak var viewContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewContainer.isHidden = false
        if isSellerReport{
            lblTitle.text = "Report this seller"
        }
        else{
            lblTitle.text = "Report this post"
        }
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        tfIssueType.delegate = self
        tfIssueType.tintColor = .clear
        tfIssueType.inputView = pickerView
        tfIssueType.inputAccessoryView = viewToolbar
        
        tvNote.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = NSLocalizedString("Note", comment: "")
        placeholderLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        placeholderLabel.sizeToFit()
        tvNote.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (tvNote.font?.pointSize)! / 2)
        placeholderLabel.textColor = .lightGray
        // Do any additional setup after loading the view.
    }
    func textViewDidChange(_ textView: UITextView){
        placeholderLabel.isHidden = !tvNote.text.isEmpty
    }
    @IBAction func toggleButtons(_ sender: UIButton) {
        if sender.tag == 1{
            //submit
            if checkValidation(){
                if isSellerReport{
                    wsCallSellerReport(user_id: self.user_id)
                }
                else{
                    wsCallProductReport(product_id: self.product_id)
                }
            }
        }
        else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    func showAlertMessage(msg:String){
        DispatchQueue.main.async{
            let alert = UIAlertController(title: "", message:msg, preferredStyle:.alert)
            let yes = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style:.default) { _ in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(yes)
            self.present(alert, animated: false, completion: nil)
        }
    }
    @IBAction func toggleToolbar(_ sender: UIButton) {
        if sender.tag == 1{
            tfIssueType.errorMessage = ""
            tfIssueType.text = arrIssueTypes[selectedPickerRow]
            selectedPickerRow = 0
            tfIssueType.resignFirstResponder()
        }
        else{
            tfIssueType.resignFirstResponder()
            selectedPickerRow = 0
        }
    }
    func checkValidation()->Bool{
        if tfIssueType.text?.isEmptyOrWhitespace() ?? true{
            tfIssueType.errorMessage = NSLocalizedString("Please select issue type", comment: "")
            return false
        }
        return true
    }
}
extension ReportPostVC : UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrIssueTypes.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return arrIssueTypes[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPickerRow = row
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
}
extension ReportPostVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
            // The error message will only disappear when we reset it to nil or empty string
            floatingLabelTextField.errorMessage = ""
        }
        return true
    }
}
extension ReportPostVC{
    func wsCallProductReport(product_id:String){
        self.showSpinner()
        let param = ["product_id":product_id,
                     "reason":self.tfIssueType.text ?? "",
                     "comment":self.tvNote.text ?? ""]
        WSCalls.sharedInstance.apiCallWithHeader(url: WSRequest.productReport, method: .post, param:param, headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            self.hideSpinner()
            print(response)
            self.viewContainer.isHidden = true
            self.showAlertMessage(msg: response["Data"] as? String ?? "")
            
        }, erroHandler: { (response, statuscode) in
            print("Error\(response)")
            self.hideSpinner()
            var errorCode = ""
            if let item = response["ErrorCode"]{
                if item is String{
                    errorCode = (item as? String)!
                }
                else if item is Int{
                    errorCode = String(item as! Int)
                }
            }
            if errorCode == "401"{
                HomeVC.sharedInstance?.wscallLogoutUser()
            }
            else{
                self.showToast(title:response["Message"] as? String ?? "")
            }
            
        }) { (error) in
            self.hideSpinner()
        }
    }
    func wsCallSellerReport(user_id:String){
        self.showSpinner()
        let param = ["user_id":user_id,
                     "reason":self.tfIssueType.text ?? "",
                     "comment":self.tvNote.text ?? ""]
        WSCalls.sharedInstance.apiCallWithHeader(url: WSRequest.sellerReport, method: .post, param:param, headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            self.hideSpinner()
            print(response)
            self.viewContainer.isHidden = true
            self.showAlertMessage(msg: response["Data"] as? String ?? "")
            
        }, erroHandler: { (response, statuscode) in
            print("Error\(response)")
            self.hideSpinner()
            var errorCode = ""
            if let item = response["ErrorCode"]{
                if item is String{
                    errorCode = (item as? String)!
                }
                else if item is Int{
                    errorCode = String(item as! Int)
                }
            }
            if errorCode == "401"{
                HomeVC.sharedInstance?.wscallLogoutUser()
            }
            else{
                self.showToast(title:response["Message"] as? String ?? "")
            }
            
        }) { (error) in
            self.hideSpinner()
        }
    }
}
