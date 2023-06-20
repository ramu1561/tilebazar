//
//  AddProductVC.swift
//  Tile Bazar
//
//  Created by Apple on 8/31/22.
//

import UIKit

class AddProductVC: ParentVC,UITextViewDelegate{

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet var CellData: UITableViewCell!
    var isEditProduct = false
    @IBOutlet weak var tfCategory: SkyFloatingLabelTextField!
    @IBOutlet weak var tfGrade: SkyFloatingLabelTextField!
    @IBOutlet weak var tfSize: SkyFloatingLabelTextField!
    @IBOutlet weak var tfNoOfPcs: SkyFloatingLabelTextField!
    @IBOutlet weak var tfThickness: SkyFloatingLabelTextField!
    @IBOutlet weak var tfWeight: SkyFloatingLabelTextField!
    @IBOutlet weak var tfCoverage: SkyFloatingLabelTextField!
    @IBOutlet weak var tfPrice: SkyFloatingLabelTextField!
    @IBOutlet weak var tfPriceType: SkyFloatingLabelTextField!
    @IBOutlet weak var imgRadioBasic: UIImageView!
    @IBOutlet weak var btnBasicRate: UIButton!
    @IBOutlet weak var imgRadioTax: UIImageView!
    @IBOutlet weak var btnTaxpaid: UIButton!
    @IBOutlet weak var imgRateNotAdded: UIImageView!
    @IBOutlet weak var tfPaymentTerms: SkyFloatingLabelTextField!
    @IBOutlet weak var tvNotes: UITextView!
    @IBOutlet weak var lblNoteCount: UILabel!
    @IBOutlet var viewToolbar: UIView!
    @IBOutlet var pickerView: UIPickerView!
    var placeholderLabel : UILabel!
    
    var arrCategories:[GetCommonIdAndNameDataModel] = []
    var arrGrades:[GetCommonIdAndNameDataModel] = []
    var arrSizes:[GetCommonIdAndNameDataModel] = []
    var arrPriceTypes:[GetCommonIdAndNameDataModel] = []
    var product_id = ""
    var category_id = ""
    var grade_id = ""
    var tile_size_id = ""
    var price_type_id = ""
    var price_category_id = ""
    var whichIsSelected = ""
    var arrNoOfPcs = ["1","2","3","4","5","6","7","8","9","10","11","12"]
    var selectedPickerRow:Int = 0
    static var sharedInstance:AddProductVC?
    
    var isCategoryValidated = false
    var isGradeValidated = false
    var isSizeValidated = false
    var isPcsValidated = false
    var isThicknessValidated = false
    var isWeightValidated = false
    var isCoverageValidated = false
    var isPriceValidated = false
    var isPriceTypeValidated = false
    var isRateTypeValidated = false
    var isPaymentTermsValidated = false
    
    var is_paid = HomeVC.sharedInstance?.is_paid ?? ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AddProductVC.sharedInstance = self
        tfThickness.keyboardType = .decimalPad
        tfWeight.keyboardType = .decimalPad
        tfCoverage.keyboardType = .decimalPad
        tfPrice.keyboardType = .decimalPad
        tfPaymentTerms.keyboardType = .numberPad
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        tfCategory.delegate = self
        tfCategory.tintColor = .clear
        
        tfGrade.delegate = self
        tfGrade.tintColor = .clear
        
        tfSize.delegate = self
        tfSize.tintColor = .clear
        
        tfNoOfPcs.delegate = self
        tfNoOfPcs.tintColor = .clear
        tfNoOfPcs.inputView = pickerView
        tfNoOfPcs.inputAccessoryView = viewToolbar
        
        tfThickness.delegate = self
        tfWeight.delegate = self
        tfCoverage.delegate = self
        tfPrice.delegate = self
        
        tfPriceType.delegate = self
        tfPriceType.tintColor = .clear
        tfPriceType.inputView = pickerView
        tfPriceType.inputAccessoryView = viewToolbar
        
        tfPaymentTerms.delegate = self
        
        tvNotes.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = NSLocalizedString("Note", comment: "")
        placeholderLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        placeholderLabel.sizeToFit()
        tvNotes.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (tvNotes.font?.pointSize)! / 2)
        placeholderLabel.textColor = .lightGray
        checkRateTypes()
        wsCallGetProductConfiguration()
        if self.isEditProduct{
            wsCallProductDetails(product_id: self.product_id)
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func toggleBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    @IBAction func toggleSubmit(_ sender: UIButton) {
        if checkValidation(){
            //now here check membership conditions.
            if is_paid == "2"{
                callAddProductApi()
            }
            else{
                let subscriptionAlertVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: SubscriptionAlertVC.self)) as! SubscriptionAlertVC
                subscriptionAlertVC.isComingFromAddProduct = true
                self.present(subscriptionAlertVC, animated: true, completion: nil)
                /*
                let free_product = Int(HomeVC.sharedInstance?.free_product ?? "") ?? 0
                if free_product > 0{
                    let viewContactAlertVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: ViewContactAlertVC.self)) as! ViewContactAlertVC
                    viewContactAlertVC.isComingFromAddProduct = true
                    self.present(viewContactAlertVC, animated: true, completion: nil)
                }
                else{
                    //limit reached, so show subscribe screen
                    let subscriptionAlertVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: SubscriptionAlertVC.self)) as! SubscriptionAlertVC
                    subscriptionAlertVC.isComingFromAddProduct = true
                    self.present(subscriptionAlertVC, animated: true, completion: nil)
                }
                */
            }
        }
    }
    func callAddProductApi(){
        self.wsCallAddProduct(category_id: self.category_id, grade_id: self.grade_id, tile_size_id: self.tile_size_id, quantity: self.tfNoOfPcs.text ?? "", thickness: tfThickness.text ?? "", weight: tfWeight.text ?? "", coverage: tfCoverage.text ?? "", price: tfPrice.text ?? "", price_type_id: price_type_id, price_category_id: price_category_id, payment_terms: tfPaymentTerms.text ?? "", note: tvNotes.text ?? "", id: product_id)
    }
    func checkValidation()->Bool{
        if tfCategory.text?.isEmptyOrWhitespace() ?? true{
            isCategoryValidated = false
            tfCategory.errorMessage = NSLocalizedString("Select Category", comment: "")
        }
        else{
            isCategoryValidated = true
        }
        if tfGrade.text?.isEmptyOrWhitespace() ?? true{
            isGradeValidated = false
            tfGrade.errorMessage = NSLocalizedString("Select Grade", comment: "")
        }
        else{
            isGradeValidated = true
        }
        if tfSize.text?.isEmptyOrWhitespace() ?? true{
            isSizeValidated = false
            tfSize.errorMessage = NSLocalizedString("Select Size", comment: "")
        }
        else{
            isSizeValidated = true
        }
        if tfNoOfPcs.text?.isEmptyOrWhitespace() ?? true{
            isPcsValidated = false
            tfNoOfPcs.errorMessage = NSLocalizedString("Select no of pcs", comment: "")
        }
        else{
            isPcsValidated = true
        }
        if tfThickness.text?.isEmptyOrWhitespace() ?? true{
            isThicknessValidated = false
            tfThickness.errorMessage = NSLocalizedString("Enter Thickness", comment: "")
        }
        else{
            isThicknessValidated = true
        }
        if tfWeight.text?.isEmptyOrWhitespace() ?? true{
            isWeightValidated = false
            tfWeight.errorMessage = NSLocalizedString("Enter Weight", comment: "")
        }
        else{
            isWeightValidated = true
        }
        if tfCoverage.text?.isEmptyOrWhitespace() ?? true{
            isCoverageValidated = false
            tfCoverage.errorMessage = NSLocalizedString("Enter Coverage", comment: "")
        }
        else{
            isCoverageValidated = true
        }
        if tfPrice.text?.isEmptyOrWhitespace() ?? true{
            isPriceValidated = false
            tfPrice.errorMessage = NSLocalizedString("Enter Price", comment: "")
        }
        else{
            isPriceValidated = true
        }
        if tfPriceType.text?.isEmptyOrWhitespace() ?? true{
            isPriceTypeValidated = false
            tfPriceType.errorMessage = NSLocalizedString("Select Price Type", comment: "")
        }
        else{
            isPriceTypeValidated = true
        }
        if price_category_id == ""{
            isRateTypeValidated = false
            imgRateNotAdded.isHidden = false
        }
        else{
            isRateTypeValidated = true
            imgRateNotAdded.isHidden = true
        }
        if tfPaymentTerms.text?.isEmptyOrWhitespace() ?? true{
            isPaymentTermsValidated = false
            tfPaymentTerms.errorMessage = NSLocalizedString("Enter Payment Terms", comment: "")
        }
        else{
            isPaymentTermsValidated = true
        }
        if isCategoryValidated && isGradeValidated && isSizeValidated && isPcsValidated && isThicknessValidated && isWeightValidated && isCoverageValidated && isPriceValidated && isPriceTypeValidated && isRateTypeValidated && isPaymentTermsValidated{
            return true
        }
        else{
            return false
        }
    }
    func showMembership(){
        self.showSubsciptionScreen()
    }
    @IBAction func toggleBasicRate(_ sender: UIButton) {
        self.price_category_id = "1"
        imgRateNotAdded.isHidden = true
        checkRateTypes()
    }
    @IBAction func toggleTaxpaidRate(_ sender: UIButton) {
        self.price_category_id = "2"
        imgRateNotAdded.isHidden = true
        checkRateTypes()
    }
    @IBAction func toggleToolbar(_ sender: UIButton) {
        if sender.tag == 1{
            if tfNoOfPcs.isFirstResponder{
                self.tfNoOfPcs.text = self.arrNoOfPcs[selectedPickerRow]
                tfNoOfPcs.resignFirstResponder()
                selectedPickerRow = 0
                self.tfNoOfPcs.errorMessage = ""
            }
            else{
                self.tfPriceType.text = self.arrPriceTypes[selectedPickerRow].name ?? ""
                self.price_type_id = self.arrPriceTypes[selectedPickerRow].id ?? ""
                tfPriceType.resignFirstResponder()
                self.tfPriceType.errorMessage = ""
                selectedPickerRow = 0
            }
        }
        else{
            if tfNoOfPcs.isFirstResponder{
                tfNoOfPcs.resignFirstResponder()
                selectedPickerRow = 0
            }
            else{
                tfPriceType.resignFirstResponder()
                selectedPickerRow = 0
            }
        }
    }
    func textViewDidChange(_ textView: UITextView){
        checkTextViewData()
        
    }
    func checkTextViewData(){
        placeholderLabel.isHidden = !tvNotes.text.isEmpty
        lblNoteCount.text = "\(tvNotes.text.count)/200"
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        /*
        // get the current text, or use an empty string if that failed
        let currentText = textView.text ?? ""
        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }
        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        // make sure the result is under 200 characters
        return updatedText.count <= 200
        */
        
        let regex = try! NSRegularExpression(pattern: "[a-zA-Z\\s]+", options: [])
        let range = regex.rangeOfFirstMatch(in: text, options: [], range: NSRange(location: 0, length: text.count))
        return range.length == text.count && self.textLimit(existingText: textView.text,
                                                            newText: text,
                                                            limit: 200)
    }
    private func textLimit(existingText: String?,
                           newText: String,
                           limit: Int) -> Bool {
        let text = existingText ?? ""
        let isAtLimit = text.count + newText.count <= limit
        return isAtLimit
    }
    func checkRateTypes(){
        if price_category_id == "1"{
            btnBasicRate.isSelected = true
            btnTaxpaid.isSelected = false
            imgRadioBasic.image = UIImage(named: "radiobox-marked")
            imgRadioTax.image = UIImage(named: "radiobox-blank")
        }
        else if price_category_id == "2"{
            btnBasicRate.isSelected = false
            btnTaxpaid.isSelected = true
            imgRadioBasic.image = UIImage(named: "radiobox-blank")
            imgRadioTax.image = UIImage(named: "radiobox-marked")
        }
        else{
            btnBasicRate.isSelected = false
            btnTaxpaid.isSelected = false
            imgRadioBasic.image = UIImage(named: "radiobox-blank")
            imgRadioTax.image = UIImage(named: "radiobox-blank")
        }
    }
}
extension AddProductVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        if let floatingLabelTextField = textField as? SkyFloatingLabelTextField {
            // The error message will only disappear when we reset it to nil or empty string
            floatingLabelTextField.errorMessage = ""
        }
        if textField == tfThickness{
            // CUSTOM SETUP
            let c = Locale(identifier: "en_US").decimalSeparator ?? "."
            //let c = NSLocale.current.decimalSeparator ?? "."
            let limitBeforeSeparator = 2
            let limitAfterSeparator = 2
            // ---------
            var validatorUserInput:Bool = false
            let text = (textField.text ?? "") as NSString
            let newText = text.replacingCharacters(in: range, with: string)
            // Validator
            let pattern = "(?!0[0-9])\\d*(?!\\\(c))^[0-9]{0,\(limitBeforeSeparator)}((\\\(c))[0-9]{0,\(limitAfterSeparator)})?$"
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                validatorUserInput = regex.numberOfMatches(in: newText, options: .reportProgress, range: NSRange(location: 0, length: (newText as NSString).length)) > 0
            }
            if validatorUserInput {
                // setting data or something eles before the return
                if let char = string.cString(using: String.Encoding.utf8) {
                    let isBackSpace = strcmp(char, "\\b")
                    if (isBackSpace == -92 && textField.text?.count == 1) {
                        print(newText)
                    }
                    else{
                        print(newText)
                    }
                }
                return validatorUserInput
            } else {
                return validatorUserInput
            }
        }
        else if textField == tfWeight{
            // CUSTOM SETUP
            let c = Locale(identifier: "en_US").decimalSeparator ?? "."
            //let c = NSLocale.current.decimalSeparator ?? "."
            let limitBeforeSeparator = 3
            let limitAfterSeparator = 2
            // ---------
            var validatorUserInput:Bool = false
            let text = (textField.text ?? "") as NSString
            let newText = text.replacingCharacters(in: range, with: string)
            // Validator
            let pattern = "(?!0[0-9])\\d*(?!\\\(c))^[0-9]{0,\(limitBeforeSeparator)}((\\\(c))[0-9]{0,\(limitAfterSeparator)})?$"
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                validatorUserInput = regex.numberOfMatches(in: newText, options: .reportProgress, range: NSRange(location: 0, length: (newText as NSString).length)) > 0
            }
            if validatorUserInput {
                // setting data or something eles before the return
                if let char = string.cString(using: String.Encoding.utf8) {
                    let isBackSpace = strcmp(char, "\\b")
                    if (isBackSpace == -92 && textField.text?.count == 1) {
                        print(newText)
                    }
                    else{
                        print(newText)
                    }
                }
                return validatorUserInput
            } else {
                return validatorUserInput
            }
        }
        else if textField == tfPrice{
            // CUSTOM SETUP
            let c = Locale(identifier: "en_US").decimalSeparator ?? "."
            //let c = NSLocale.current.decimalSeparator ?? "."
            let limitBeforeSeparator = 10
            let limitAfterSeparator = 2
            // ---------
            var validatorUserInput:Bool = false
            let text = (textField.text ?? "") as NSString
            let newText = text.replacingCharacters(in: range, with: string)
            // Validator
            let pattern = "(?!0[0-9])\\d*(?!\\\(c))^[0-9]{0,\(limitBeforeSeparator)}((\\\(c))[0-9]{0,\(limitAfterSeparator)})?$"
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                validatorUserInput = regex.numberOfMatches(in: newText, options: .reportProgress, range: NSRange(location: 0, length: (newText as NSString).length)) > 0
            }
            if validatorUserInput {
                // setting data or something eles before the return
                if let char = string.cString(using: String.Encoding.utf8) {
                    let isBackSpace = strcmp(char, "\\b")
                    if (isBackSpace == -92 && textField.text?.count == 1) {
                        print(newText)
                    }
                    else{
                        print(newText)
                    }
                }
                return validatorUserInput
            } else {
                return validatorUserInput
            }
        }
        else if textField == tfPaymentTerms{
            let maxLength = 3
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == tfNoOfPcs{
            self.whichIsSelected = "pcs"
            self.pickerView.reloadAllComponents()
            pickerView.selectRow(0, inComponent: 0, animated: true)
        }
        else if textField == tfPriceType{
            self.whichIsSelected = "priceType"
            self.pickerView.reloadAllComponents()
            pickerView.selectRow(0, inComponent: 0, animated: true)
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfCategory{
            if arrCategories.count>0{
                let selectStateVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: SelectStateVC.self)) as! SelectStateVC
                selectStateVC.arrStates = self.arrCategories
                selectStateVC.isComingFrom = "addProduct_category"
                self.present(selectStateVC, animated: true, completion: nil)
            }
            else{
                self.view.endEditing(true)
                self.showToast(title:NSLocalizedString("No categories found", comment: ""))
            }
            return false
        }
        else if textField == tfGrade{
            if arrGrades.count>0{
                let selectStateVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: SelectStateVC.self)) as! SelectStateVC
                selectStateVC.arrStates = self.arrGrades
                selectStateVC.isComingFrom = "addProduct_grade"
                self.present(selectStateVC, animated: true, completion: nil)
            }
            else{
                self.view.endEditing(true)
                self.showToast(title:NSLocalizedString("No grades found", comment: ""))
            }
            return false
        }
        else if textField == tfSize{
            if arrSizes.count>0{
                let selectStateVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: SelectStateVC.self)) as! SelectStateVC
                selectStateVC.arrStates = self.arrSizes
                selectStateVC.isComingFrom = "addProduct_size"
                self.present(selectStateVC, animated: true, completion: nil)
            }
            else{
                self.view.endEditing(true)
                self.showToast(title:NSLocalizedString("No sizes found", comment: ""))
            }
            return false
        }
        else if textField == tfPriceType{
            if arrPriceTypes.count>0{
                return true
            }
            else{
                self.view.endEditing(true)
                self.showToast(title:NSLocalizedString("No price types found", comment: ""))
                return false
            }
        }
        return true
    }
}
extension AddProductVC : UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if whichIsSelected == "pcs"{
            return arrNoOfPcs.count
        }
        else{
            return arrPriceTypes.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if whichIsSelected == "pcs"{
            return arrNoOfPcs[row]
        }
        else{
            return self.arrPriceTypes[row].name ?? ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPickerRow = row
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
}
extension AddProductVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return CellData
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 800
    }
}
extension AddProductVC{
    private func wsCallGetProductConfiguration(){
        WSCalls.sharedInstance.apiCallWithHeader(url: WSRequest.getProductConfiguration, method: .get, param: [:], headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            print(response)
            self.arrCategories.removeAll()
            self.arrGrades.removeAll()
            self.arrSizes.removeAll()
            self.arrPriceTypes.removeAll()
            
            let arrTempCategories = response["categories"] as? [[String:Any]] ?? []
            if arrTempCategories.count > 0{
                for obj in arrTempCategories{
                    let obj = GetCommonIdAndNameDataModel(dictinfo: obj)
                    self.arrCategories.append(obj)
                }
            }
            
            let arrTempGrades = response["grades"] as? [[String:Any]] ?? []
            if arrTempGrades.count > 0{
                for obj in arrTempGrades{
                    let obj = GetCommonIdAndNameDataModel(dictinfo: obj)
                    self.arrGrades.append(obj)
                }
            }
            
            let arrTempSizes = response["sizes"] as? [[String:Any]] ?? []
            if arrTempSizes.count > 0{
                for obj in arrTempSizes{
                    let obj = GetCommonIdAndNameDataModel(dictinfo: obj)
                    self.arrSizes.append(obj)
                }
            }
            
            let arrTempPriceTypes = response["priceTypes"] as? [[String:Any]] ?? []
            if arrTempPriceTypes.count > 0{
                for obj in arrTempPriceTypes{
                    let obj = GetCommonIdAndNameDataModel(dictinfo: obj)
                    self.arrPriceTypes.append(obj)
                }
            }

            
        }, erroHandler: { (response, statuscode) in
            print("Error\(response)")
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
                self.hideSpinner()
                HomeVC.sharedInstance?.wscallLogoutUser()
            }
            else{
                self.showAlert(msg: response["Message"] as? String ?? "")
            }
        }) { (error) in
        }
    }
    func wsCallProductDetails(product_id:String){
        self.showSpinner()
        let param = ["id":product_id]
        WSCalls.sharedInstance.apiCallWithHeader(url: WSRequest.productDetail, method: .post, param:param, headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            self.hideSpinner()
            print(response)
            
            self.tfCategory.text = response["Data"]!["category_name"] as? String ?? ""
            if let item = response["Data"]!["category_id"]{
                if item is String{
                    self.category_id = (item as? String)!
                }
                else if item is Int{
                    self.category_id = String(item as! Int)
                }
            }
            
            self.tfGrade.text = response["Data"]!["grade_name"] as? String ?? ""
            if let item = response["Data"]!["grade_id"]{
                if item is String{
                    self.grade_id = (item as? String)!
                }
                else if item is Int{
                    self.grade_id = String(item as! Int)
                }
            }
            
            if let item = response["Data"]!["tile_size_name"]{
                if item is String{
                    self.tfSize.text = (item as? String)!
                }
                else if item is Int{
                    self.tfSize.text = String(item as! Int)
                }
            }
            if let item = response["Data"]!["tile_size_id"]{
                if item is String{
                    self.tile_size_id = (item as? String)!
                }
                else if item is Int{
                    self.tile_size_id = String(item as! Int)
                }
            }
            if let item = response["Data"]!["quantity"]{
                if item is String{
                    self.tfNoOfPcs.text = (item as? String)!
                }
                else if item is Int{
                    self.tfNoOfPcs.text = String(item as! Int)
                }
            }
            if let item = response["Data"]!["thickness"]{
                if item is String{
                    self.tfThickness.text = (item as? String)!
                }
                else if item is Int{
                    self.tfThickness.text = String(item as! Int)
                }
                else if item is Double{
                    self.tfThickness.text = String(item as! Double)
                }
            }
            if let item = response["Data"]!["weight"]{
                if item is String{
                    self.tfWeight.text = (item as? String)!
                }
                else if item is Int{
                    self.tfWeight.text = String(item as! Int)
                }
                else if item is Double{
                    self.tfWeight.text = String(item as! Double)
                }
            }
            if let item = response["Data"]!["coverage"]{
                if item is String{
                    self.tfCoverage.text = (item as? String)!
                }
                else if item is Int{
                    self.tfCoverage.text = String(item as! Int)
                }
                else if item is Double{
                    self.tfCoverage.text = String(item as! Double)
                }
            }
            
            var price = ""
            if let item = response["Data"]!["price"]{
                if item is String{
                    price = (item as? String)!
                }
                else if item is Int{
                    price = String(item as! Int)
                }
                else if item is Double{
                    price = String(item as! Double)
                }
            }
            
            self.tfPrice.text = price.replacingOccurrences(of: ",", with: "")
            
            self.tfPriceType.text = response["Data"]!["price_type_name"] as? String ?? ""
            if let item = response["Data"]!["price_type_id"]{
                if item is String{
                    self.price_type_id = (item as? String)!
                }
                else if item is Int{
                    self.price_type_id = String(item as! Int)
                }
            }
            
            if let item = response["Data"]!["price_category_id"]{
                if item is String{
                    self.price_category_id = (item as? String)!
                }
                else if item is Int{
                    self.price_category_id = String(item as! Int)
                }
            }
            
            if let item = response["Data"]!["payment_terms"]{
                if item is String{
                    self.tfPaymentTerms.text = (item as? String)!
                }
                else if item is Int{
                    self.tfPaymentTerms.text = String(item as! Int)
                }
            }
            self.tvNotes.text = response["Data"]!["note"] as? String ?? ""
            self.checkRateTypes()
            self.checkTextViewData()
            
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
    private func wsCallAddProduct(category_id:String,grade_id:String,tile_size_id:String,quantity:String,thickness:String,weight:String,coverage:String,price:String,price_type_id:String,price_category_id:String,payment_terms:String,note:String,id:String){
        self.showSpinner()
        let params = ["category_id":category_id,
                      "grade_id":grade_id,
                      "tile_size_id":tile_size_id,
                      "quantity":quantity,
                      "thickness":thickness,
                      "weight":weight,
                      "coverage":coverage,
                      "price":price,
                      "price_type_id":price_type_id,
                      "price_category_id":price_category_id,
                      "payment_terms":payment_terms,
                      "note":note,
                      "id":id]
        
        WSCalls.sharedInstance.apiCallWithHeader(url: WSRequest.storeProduct, method: .post, param:params, headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            print(response)
            self.hideSpinner()
            self.navigationController?.popViewController(animated: true)

            
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
                self.hideSpinner()
                HomeVC.sharedInstance?.wscallLogoutUser()
            }
            else{
                self.showAlert(msg: response["Message"] as? String ?? "")
            }
        }) { (error) in
            self.hideSpinner()
        }
    }
}
