//
//  AppDelegate.swift
//  Tile Bazar
//
//  Created by Apple on 8/12/22.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
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

