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
import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var firebaseToken = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Thread.sleep(forTimeInterval: 3.0)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

        showDashboard()
        return true
    }
    func showDashboard(){
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
    }
    func notificationRedirection(){
        showDashboard()
    }
    //MARK:- Push notifications methods
    // [END receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification
       userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    // increase badge count, but no need if you include content-available
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Couldn't register: \(error)")
    }
    func handlePushNotificationsData(userInfo: [AnyHashable : Any]){
        print(userInfo)
    }
}
//MARK:- Push Notifications
// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // This method will be called when app received push notifications in foreground
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        let userInfo = notification.request.content.userInfo
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        self.handlePushNotificationsData(userInfo: userInfo)
        // Change this to your preferred presentation option
        completionHandler([.alert, .badge, .sound])
        
    }
    // This method will be called when app received push notifications in background. Data will display when user taps on notification to open the app
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        self.handlePushNotificationsData(userInfo: userInfo)
        // Print full message.
        /*
        print(userInfo)
        let title = userInfo["body"] as? String ?? ""
        print("body:\(title)")
        
        if let item = userInfo["user_id"]{
            if item is String{
                self.push_user_id = (item as? String)!
            }
            else if item is Int{
                self.push_user_id = String(item as! Int)
            }
        }
        if let item = userInfo["notification_type"]{
            if item is String{
                self.push_notification_type = (item as? String)!
            }
            else if item is Int{
                self.push_notification_type = String(item as! Int)
            }
        }
        if let item = userInfo["type"]{
            if item is String{
                self.push_type = (item as? String)!
            }
            else if item is Int{
                self.push_type = String(item as! Int)
            }
        }
        print("push_user_id:\(self.push_user_id)")
        print("push_notification_type:\(self.push_notification_type)")
        print("push_type:\(self.push_type)")
        */
        notificationRedirection()
        //redirection takes place from here
        completionHandler()
    }
}
// [END ios_10_message_handling]
extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        firebaseToken = fcmToken
        if userInfo?.api_token == nil || userInfo?.api_token == ""{
        }
        else{
            let param = ["device_token":fcmToken]
            WSCalls.sharedInstance.apiCallWithHeader(url: WSRequest.storeDeviceToken, method: .post, param: param , headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (repsonse, statuscode) in
                print(repsonse)
                
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
                    //DashboardVC.sharedInstace?.wscallLogoutUser()
                }
                else{
                }
                
            }) { (error) in
                
            }
        }
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    // [END ios_10_data_message]
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("message data : \(remoteMessage.appData)")
    }
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
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

