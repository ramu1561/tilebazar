//
//  ProfileVC.swift
//  Tile Bazar
//
//  Created by Apple on 8/13/22.
//

import UIKit
import SDWebImage

class ProfileVC: ParentVC {

    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var lblProfileTitle: UILabel!
    @IBOutlet weak var lblSeparator: UILabel!
    @IBOutlet weak var imgUserIcon: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblUserCompany: UILabel!
    @IBOutlet weak var lblUserAddress: UILabel!
    static var sharedInstance:ProfileVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProfileVC.sharedInstance = self
        wsCallGetProfile()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    @IBAction func toggleButtons(_ sender: UIButton) {
        if sender.tag == 1{
            //my products
            let myProductsVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: MyProductsVC.self)) as! MyProductsVC
            self.navigationController?.pushViewController(myProductsVC, animated: true)
        }
        else if sender.tag == 2{
            //watchlist
            tabBarController?.selectedIndex = 3
        }
        else if sender.tag == 3{
            //logout
            toggleUserLogOut()
        }
        else if sender.tag == 4{
            //membership
            self.showSubsciptionScreen()
        }
        else{
            //edit
            let editProfileVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: EditProfileVC.self)) as! EditProfileVC
            self.navigationController?.pushViewController(editProfileVC, animated: true)
        }
    }
    func toggleUserLogOut(){
        DispatchQueue.main.async{
            let alert = UIAlertController(title: "", message: NSLocalizedString("Are you sure you want to logout?", comment: ""), preferredStyle:.alert)
            let yes = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style:.default) { _ in
                //api call
                self.wsCallLogOut()
            }
            let dismiss = UIAlertAction(title: NSLocalizedString("No", comment: ""), style:.cancel, handler: nil)
            alert.addAction(yes)
            alert.addAction(dismiss)
            self.present(alert, animated: false, completion: nil)
        }
    }
}
extension ProfileVC{
    func wsCallGetProfile(){
        WSCalls.sharedInstance.apiCallWithHeader(url: WSRequest.getProfile, method: .get, param: [:], headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            print(response)
            self.lblUsername.text = response["name"] as? String ?? ""
            self.lblUserCompany.text = response["company_name"] as? String ?? ""
            self.lblUserAddress.text = response["city"] as? String ?? ""
            
            UserDefaults.standard.set(response["name"] as? String ?? "", forKey: "user_name")
            UserDefaults.standard.set(response["image"] as? String ?? "", forKey: "image")
            UserDefaults.standard.set(response["company_name"] as? String ?? "", forKey: "user_company_name")
            
            guard let url = URL(string:response["image"] as? String ?? "") else{
                return
            }
            self.imgUserIcon.sd_setImage(with:url,
                                 placeholderImage:UIImage(named: "profile-user"),
                                 options: SDWebImageOptions(rawValue: 0),
                                 completed: { (image, error, cacheType, imageUrl) in
            })
            
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
    private func wsCallLogOut(){
        self.showSpinner()
        WSCalls.sharedInstance.apiCallWithHeader(url: WSRequest.logout, method: .post, param: [:], headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (repsonse, statuscode) in
            self.hideSpinner()
            UserDefaults.standard.removeObject(forKey: "UserInformation")
            self.makeRootViewController()
            
        }, erroHandler: { (response, statuscode) in
            print("Error\(response)")
            self.hideSpinner()
            UserDefaults.standard.removeObject(forKey: "UserInformation")
            self.makeRootViewController()
            
        }) { (error) in
            self.hideSpinner()
            UserDefaults.standard.removeObject(forKey: "UserInformation")
            self.makeRootViewController()
        }
    }
    
}
