//
//  EditProfileVC.swift
//  Tile Bazar
//
//  Created by Apple on 8/24/22.
//

import UIKit
import Photos
import AssetsPickerViewController
import Alamofire
import SDWebImage

class EditProfileVC: ParentVC,UITextViewDelegate{

    @IBOutlet weak var tfFullname: SkyFloatingLabelTextField!
    @IBOutlet weak var tfPhoneNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var tfCompanyName: SkyFloatingLabelTextField!
    @IBOutlet weak var tfState: SkyFloatingLabelTextField!
    @IBOutlet weak var tfCity: SkyFloatingLabelTextField!
    @IBOutlet weak var tvAddress: UITextView!
    var placeholderLabel : UILabel!
    var selectedStateID = ""
    static var sharedInstance:EditProfileVC?
    var arrStates:[GetCommonIdAndNameDataModel] = []
    var isFullnameValidated = false
    var isPhoneNumberValidated = false
    var isCompanyNameValidated = false
    var isStateValidated = false
    var isCityValidated = false
    @IBOutlet weak var imgUserIcon: UIImageView!
    @IBOutlet var CellData: UITableViewCell!
    @IBOutlet weak var tblView: UITableView!
    var assets = [PHAsset]() // Selected assets
    var arrSelectedImages: [UIImage] = []
    lazy var imageManager = {
        return PHCachingImageManager()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EditProfileVC.sharedInstance = self
        
        imgUserIcon.isUserInteractionEnabled = true // Remember to do this
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(toggleEditPhoto))
        tap.numberOfTapsRequired = 1
        imgUserIcon.addGestureRecognizer(tap)
        
        tvAddress.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = NSLocalizedString("Address (Optional)", comment: "")
        placeholderLabel.font = UIFont(name: "Roboto-Regular", size: 15)
        placeholderLabel.sizeToFit()
        tvAddress.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (tvAddress.font?.pointSize)! / 2)
        placeholderLabel.textColor = .lightGray
        wsCallGetProfile()
        // Do any additional setup after loading the view.
    }
    @IBAction func toggleEditPhoto(_ sender: Any) {
        updateProfilePhotoOptions()
    }
    func updateProfilePhotoOptions(){
        let alert = UIAlertController(title: NSLocalizedString("Choose Image", comment: ""), message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Photos", comment: ""), style: .default, handler: { _ in
            //self.openGallery()
            self.checkPhotosPermission()
        }))
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        if let popoverController = alert.popoverPresentationController {
          popoverController.sourceView = self.view
          popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
          popoverController.permittedArrowDirections = []
        }
        self.present(alert, animated: true, completion: nil)
    }
    func checkPhotosPermission(){
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if photoAuthorizationStatus == .authorized{
            self.openGallery()
        }
        else if photoAuthorizationStatus == .notDetermined{
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                DispatchQueue.main.async {
                    if newStatus ==  PHAuthorizationStatus.authorized {
                        self.openGallery()
                    }else{
                        print("User denied")
                        self.showAlertForPhotosPermission()
                    }
                }})
        }
        else if photoAuthorizationStatus == .restricted{
            print("restricted")
            self.showAlertForPhotosPermission()
        }
        else{
            print("denied")
            self.showAlertForPhotosPermission()
        }
    }
    func openCamera()
    {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            let pickercontoller = UIImagePickerController()
            pickercontoller.sourceType = .camera
            pickercontoller.delegate = self
            self.present(pickercontoller, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery()
    {
        let picker = AssetsPickerViewController()
        picker.pickerDelegate = self
        self.present(picker, animated: true, completion: nil)
    }
    func applyChangesToTheSelectedImage(){
        guard let cropAndRotateVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: CropAndRotateVC.self)) as? CropAndRotateVC else {
            return
        }
        cropAndRotateVC.image = self.arrSelectedImages[0]
        self.navigationController?.pushViewController(cropAndRotateVC, animated: true)
    }
    func textViewDidChange(_ textView: UITextView){
        placeholderLabel.isHidden = !tvAddress.text.isEmpty
    }
    @IBAction func toggleButtons(_ sender: UIButton) {
        if sender.tag == 1{
            //save
            if checkValidation(){
                self.wsCallStoreProfile(name: tfFullname.text ?? "", address: tvAddress.text ?? "", email:"", company_name: tfCompanyName.text ?? "", state_id: selectedStateID, city: tfCity.text ?? "")
            }
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
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
}
//MARK:- ImagePicker delegate methods
extension EditProfileVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.arrSelectedImages.removeAll()
        if let img = info[.originalImage] as? UIImage{
            self.arrSelectedImages.append(img)
        }
        picker.dismiss(animated: false, completion: nil)
        self.applyChangesToTheSelectedImage()
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
extension EditProfileVC: AssetsPickerViewControllerDelegate {
    func assetsPicker(controller: AssetsPickerViewController, selected assets: [PHAsset]) {
        self.assets = assets
        self.arrSelectedImages.removeAll()
        for i in 0..<self.assets.count{
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            options.isNetworkAccessAllowed = true
            options.deliveryMode = .highQualityFormat
            imageManager.requestImage(for: assets[i], targetSize:CGSize(width: assets[i].pixelWidth, height: assets[i].pixelHeight), contentMode: .aspectFill, options: options) { (image, info) in
                if image == nil{
                }
                else{
                    self.arrSelectedImages.append(image!)
                }
            }
        }
        if self.arrSelectedImages.count > 0{
            self.applyChangesToTheSelectedImage()
        }
        else{
            self.showToast(title: NSLocalizedString("Seems you are trying to upload iCloud image, make sure your device is connected with internet.", comment: ""))
        }
    }
    func assetsPicker(controller: AssetsPickerViewController, shouldSelect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        // can limit selection count
        if controller.selectedAssets.count < 1{ // because count starts from 0
            // do your job here
            return true
        }
        return false
    }
    func assetsPicker(controller: AssetsPickerViewController, shouldDeselect asset: PHAsset, at indexPath: IndexPath) -> Bool {
        return true
    }
}
extension EditProfileVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return CellData
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 630
    }
}
extension EditProfileVC: UITextFieldDelegate {
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
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfState{
            let selectStateVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: SelectStateVC.self)) as! SelectStateVC
            selectStateVC.arrStates = self.arrStates
            selectStateVC.isComingFrom = "editProfile"
            self.present(selectStateVC, animated: true, completion: nil)
            return false
        }
        return true
    }
}
extension EditProfileVC{
    private func wsCallGetProfile(){
        self.showSpinner()
        WSCalls.sharedInstance.apiCallWithHeader(url: WSRequest.getProfile, method: .get, param: [:], headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            print(response)
            self.wsCallGetRegisterConfiguration()
            if let item = response["state_id"]{
                if item is String{
                    self.selectedStateID = (item as? String)!
                }
                else if item is Int{
                    self.selectedStateID = String(item as! Int)
                }
            }
            if let item = response["phone_number"]{
                if item is String{
                    self.tfPhoneNumber.text = (item as? String)!
                }
                else if item is Int{
                    self.tfPhoneNumber.text = String(item as! Int)
                }
            }
            self.tfFullname.text = response["name"] as? String ?? ""
            self.tfCompanyName.text = response["company_name"] as? String ?? ""
            self.tfState.text = response["state_name"] as? String ?? ""
            self.tfCity.text = response["city"] as? String ?? ""
            self.tvAddress.text = response["address"] as? String ?? ""
            self.placeholderLabel.isHidden = !self.tvAddress.text.isEmpty
            UserDefaults.standard.set(response["image"] as? String ?? "", forKey: "image")
            guard let url = URL(string:response["image"] as? String ?? "") else{
                return
            }
            self.imgUserIcon.sd_setImage(with:url,
                                 placeholderImage:UIImage(named: "profile-user"),
                                 options: SDWebImageOptions(rawValue: 0),
                                 completed: { (image, error, cacheType, imageUrl) in
            })
            
        }, erroHandler: { (response, statuscode) in
            self.hideSpinner()
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
                HomeVC.sharedInstance?.wscallLogoutUser()
            }
            else{
                self.showAlert(msg: response["Message"] as? String ?? "")
            }
        }) { (error) in
            self.hideSpinner()
        }
    }
    private func wsCallGetRegisterConfiguration(){
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
    private func wsCallStoreProfile(name:String,address:String,email:String,company_name:String,state_id:String,city:String){
        self.showSpinner()
        Alamofire.upload(multipartFormData: { multipartFormData in
            let param = ["name":name,
                         "address":address,
                         "company_name":company_name,
                         "state_id":state_id,
                         "city":city]
            for (key, value) in param {
                if let data = value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)){
                    multipartFormData.append(data, withName: key)
                }
            }
            if self.imgUserIcon.image != nil{
                let imageData = self.imgUserIcon.image!.jpegData(compressionQuality: 1.0)!
                multipartFormData.append(imageData, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
            }
            
            
        },to: WSRequest.storeProfile,method:HTTPMethod.post,headers:["Authorization":userInfo?.api_token ?? ""], encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload
                    .validate()
                    .responseJSON { response in
                        switch response.result {
                        case .success(_):
                            if let data = response.result.value{
                                if let jsonResponse = data as? [String : AnyObject]{
                                    print("Response \(jsonResponse)")
                                    if let success = jsonResponse["IsSuccess"] as? Bool{
                                        if success{
                                            self.hideSpinner()
                                            ProfileVC.sharedInstance?.wsCallGetProfile()
                                            self.navigationController?.popViewController(animated: true)
                                            
                                        }
                                        else{
                                            self.hideSpinner()
                                            print("Error Response: \(jsonResponse)")
                                            self.showAlert(msg: jsonResponse["Message"] as? String ?? "")
                                        }
                                    }
                                }
                            }
                            break
                            
                        case .failure(_):
                            if let data = response.data {
                                self.hideSpinner()
                                let json = String(data: data, encoding: String.Encoding.utf8)
                                print("Failure Response: \(String(describing: json))")
                            }
                            break
                        }
                }
            case .failure(let encodingError):
                self.hideSpinner()
                print("encodingError: \(encodingError)")
            }
        })
    }
}
