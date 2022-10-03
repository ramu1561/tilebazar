//
//  AppDelegate.swift
//  Tile Bazar
//
//  Created by Apple on 8/12/22.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseCore
import FirebaseDynamicLinks


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Thread.sleep(forTimeInterval: 3.0)
        FirebaseApp.configure()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        
        if let info = Helper.getDatafromUserDefault("UserInformation"){
            do {
                userInfo = try JSONDecoder().decode(UserInformation.self, from: info)
                let rootViewController = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: "TBTabbar") as! UITabBarController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = rootViewController
            }
            catch{

            }
        }
        
        /*
        let rootViewController = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: "TBTabbar") as! UITabBarController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootViewController
         */
        return true
    }
}
//MARK: Firebase dynamic links
extension AppDelegate{
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
      let handled = DynamicLinks.dynamicLinks()
        .handleUniversalLink(userActivity.webpageURL!) { dynamiclink, error in
          // ...
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if let url = dynamiclink?.url{
                let urlString = "\(url)"
                let linkArray = urlString.components(separatedBy: "/")
                let linkID = linkArray.last
                
                if urlString.contains("sellerdetails"){
                    if  let sellerDetailsVC = storyboard.instantiateViewController(withIdentifier: "SellerDetailsVC") as? SellerDetailsVC,
                        let tabBarController = self.window?.rootViewController as? UITabBarController,
                        let navController = tabBarController.selectedViewController as? UINavigationController {
                        sellerDetailsVC.user_id = linkID ?? ""
                        navController.pushViewController(sellerDetailsVC, animated:false)
                    }
                }
                else if urlString.contains("productdetails"){
                    if  let productDetailsVC = storyboard.instantiateViewController(withIdentifier: "ProductDetailsVC") as? ProductDetailsVC,
                        let tabBarController = self.window?.rootViewController as? UITabBarController,
                        let navController = tabBarController.selectedViewController as? UINavigationController {
                        productDetailsVC.product_id = linkID ?? ""
                        navController.pushViewController(productDetailsVC, animated:false)
                    }
                }
                else{
                    
                }
            }
            
        }
      return handled
    }
}
extension AppDelegate {
    class func mainWindow() -> UIWindow {
        return ((UIApplication.shared.delegate?.window)!)!
    }
    class func shared() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
}
extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

