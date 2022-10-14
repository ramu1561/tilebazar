//
//  ParentVC.swift
//  Tile Bazar
//
//  Created by Apple on 8/13/22.
//

import UIKit
import Toast_Swift

class ParentVC: UIViewController {
    
    var contact_number = "+919108093080"
    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator()
        // Do any additional setup after loading the view.
    }
    func activityIndicator(){
        indicator = UIActivityIndicatorView(frame: CGRect(origin: self.view.center, size: CGSize(width: 40, height: 40)))
        indicator.style = UIActivityIndicatorView.Style.gray
        self.view.addSubview(indicator)
    }
    func showSpinner(){
        //UIApplication.shared.beginIgnoringInteractionEvents()
        indicator.startAnimating()
    }
    func hideSpinner(){
        //UIApplication.shared.endIgnoringInteractionEvents()
        indicator.stopAnimating()
        indicator.hidesWhenStopped = true
    }
    func makeRootViewController(){
        let rootViewController = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: "RootViewController") as! RootViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootViewController
    }
    func starifyNumber(number: String) -> String {
        let intLetters = number.prefix(4)
        let endLetters = number.suffix(0)
        let numberOfStars = number.count - (intLetters.count + endLetters.count)
        var starString = ""
        if numberOfStars > 0{
            for _ in 1...numberOfStars {
                starString += "*"
            }
        }
        let finalNumberToShow: String = intLetters + starString + endLetters
        return finalNumberToShow
    }
    func showToast(title : String){
        ToastManager.shared.position = .bottom
        self.view.makeToast(title)
    }
    func showAlert(msg : String){
        let alert = UIAlertController(title:"", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:NSLocalizedString("Ok", comment: ""), style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func showAlertForPhotosPermission(){
        let alert = UIAlertController(title:NSLocalizedString("This app does not have access to your photos", comment:""), message:NSLocalizedString("You can enable this in privacy settings", comment: ""), preferredStyle:.alert)
        let ok = UIAlertAction(title:NSLocalizedString("Privacy Settings", comment: ""), style:.default) { _ in
            if let bundleId = Bundle.main.bundleIdentifier,
               let url = URL(string: "\(UIApplication.openSettingsURLString)&path=Photos/\(bundleId)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let no = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style:.default) { _ in
            
        }
        alert.addAction(ok)
        alert.addAction(no)
        present(alert, animated: true, completion: nil)
    }
    //open whatsapp
    func openWhatsapp(phoneNumber:String){
        
        var phone = ""
        if phoneNumber.hasPrefix("+"){
            phone = phoneNumber
        }
        else{
            phone = "+91\(phoneNumber)"
        }
        
        let urlWhats = "whatsapp://send?phone=\(phone)"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(whatsappURL)
                    }
                }
                else {
                    print("Install Whatsapp")
                }
            }
        }
    }
    //call
    func makeAPhoneCall(phoneNumber:String){
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url){
            if #available(iOS 10, *){
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    func showSubsciptionScreen(){
        let membershipVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: MembershipVC.self)) as! MembershipVC
        self.navigationController?.pushViewController(membershipVC, animated: true)
    }
    func showAddProductScreen(){
        let addProductVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: AddProductVC.self)) as! AddProductVC
        self.navigationController?.pushViewController(addProductVC, animated: true)
    }
    @IBAction func toggleSideMenu(_ sender: UIButton) {
        guard let menuVC = self.storyboard!.instantiateViewController(withIdentifier: String(describing: MenuVC.self)) as? MenuVC else {
            return
        }
        menuVC.willMove(toParent: self)
        self.tabBarController?.view.addSubview(menuVC.view)
        self.tabBarController?.addChild(menuVC)
        self.addChild(menuVC)
        //menuVC.didMove(toParent: self)
    }
    @IBAction func toggleCompareScreen(_ sender: Any) {
        let arrayCompareProductIDs = UserDefaults.standard.stringArray(forKey: "arrayCompareProductIDs") ?? [String]()
        if arrayCompareProductIDs.count >= 2{
            let compareProductsVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: CompareProductsVC.self)) as! CompareProductsVC
            self.navigationController?.pushViewController(compareProductsVC, animated: true)
        }
        else{
            self.showToast(title: "Please select at least 2 products to compare")
        }
    }
}
extension UIViewController {
    func setStatusBarStyle(_ style: UIStatusBarStyle) {
        if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = style == .lightContent ? UIColor.black : .white
            statusBar.setValue(style == .lightContent ? UIColor.white : .black, forKey: "foregroundColor")
        }
    }
}
