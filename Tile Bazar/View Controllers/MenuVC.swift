//
//  MenuVC.swift
//  Tile Bazar
//
//  Created by Apple on 8/30/22.
//

import UIKit
import SDWebImage

class MenuVC: ParentVC,UIGestureRecognizerDelegate{

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewContainerTrailing: NSLayoutConstraint!//100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(MenuVC.viewTapped))
        tap.delegate = self
        self.view.addGestureRecognizer(tap)
        
        if let info = Helper.getDatafromUserDefault("UserInformation"){
            self.lblName.text = "\(UserDefaults.standard.string(forKey: "user_name") ?? userInfo?.name ?? "")"
            self.lblCompanyName.text = "\(UserDefaults.standard.string(forKey: "user_company_name") ?? userInfo?.company_name ?? "")"
            guard let url = URL(string: UserDefaults.standard.string(forKey: "user_image") ?? userInfo?.image ?? "") else{
                return
            }
            self.imgUser.sd_setImage(with:url,
                                 placeholderImage:UIImage(named: "profile-user"),
                                 options: SDWebImageOptions(rawValue: 0),
                                 completed: { (image, error, cacheType, imageUrl) in
            })
        }
        else{
            self.lblName.text = "Guest User"
            self.lblCompanyName.text = ""
            self.imgUser.image = UIImage(named: "profile-user")
        }
        // Do any additional setup after loading the view.
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool{
        if touch.view?.isDescendant(of: self.viewContainer) == true{
            return false
        }
        return true
    }
    @objc func viewTapped(){
        hideMenuWithAnimation()
    }
    func hideMenuWithAnimation(){
        UIView.transition(with:view, duration: 0.3, options: .transitionCrossDissolve, animations:{
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }
    @IBAction func toggleMenuButtons(_ sender: UIButton) {
        if sender.tag == 0{
            //profile tab
            if let info = Helper.getDatafromUserDefault("UserInformation"){
                tabBarController?.selectedIndex = 4
                hideMenuWithAnimation()
            }
            else{
                self.showLoginScreen()
                hideMenuWithAnimation()
            }
        }
        else if sender.tag == 1{
            //home tab
            tabBarController?.selectedIndex = 0
            hideMenuWithAnimation()
        }
        else if sender.tag == 2{
            //refer
            //["You can now download the Tile Bazar App on the AppStore. Get start today and reach millions of customers.","https://apps.apple.com/us/app/tile-bazar/id6443541980"]
            
            let appStore = ["Are you into CERAMICS ?\nGet the best deals or offer your products at best.\nGet start today and reach millions of buyers and sellers.\n\niOS app:\nhttps://apps.apple.com/us/app/tile-bazar/id6443541980\n\nAndroid app:\nhttps://play.google.com/store/apps/details?id=com.app.tilesbazar\n\nDownload TILE BAZAR app and get lowest price guaranteed in any ceramic tile products"]
            
            let activityViewController = UIActivityViewController(activityItems: appStore, applicationActivities: nil)
            if let popoverController = activityViewController.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            self.present(activityViewController, animated: true, completion: nil)
            hideMenuWithAnimation()
        }
        else if sender.tag == 3{
            //quick connect
            self.openWhatsapp(phoneNumber: self.contact_number)
            hideMenuWithAnimation()
        }
        else if sender.tag == 4{
            //faqs
            let tBWebVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: TBWebVC.self)) as! TBWebVC
            tBWebVC.isComingFrom = "faqs"
            self.navigationController?.pushViewController(tBWebVC, animated: true)
            hideMenuWithAnimation()
        }
        else if sender.tag == 5{
            //about us
            let tBWebVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: TBWebVC.self)) as! TBWebVC
            tBWebVC.isComingFrom = "about"
            self.navigationController?.pushViewController(tBWebVC, animated: true)
            hideMenuWithAnimation()
        }
        else{
            //membership
            self.showSubsciptionScreen()
            hideMenuWithAnimation()
        }
    }
}
