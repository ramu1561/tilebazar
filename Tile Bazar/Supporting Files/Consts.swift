//
//  Consts.swift
//  Tile Bazar
//
//  Created by Apple on 8/15/22.
//

import Foundation
import UIKit
var userInfo : UserInformation?

//MARK:- Device Sizes
struct DeviceType{
    static let IS_IPAD             = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE           = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA           = UIScreen.main.scale >= 2.0
    static let SCREEN_WIDTH        = Int(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT       = Int(UIScreen.main.bounds.size.height)
    static let SCREEN_MAX_LENGTH   = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
    static let SCREEN_MIN_LENGTH   = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
    static let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH  < 568
    static let IS_IPHONE_5         = IS_IPHONE && SCREEN_MAX_LENGTH == 568
    static let IS_IPHONE_6         = IS_IPHONE && SCREEN_MAX_LENGTH == 667
    static let IS_IPHONE_6P        = IS_IPHONE && SCREEN_MAX_LENGTH == 736
    static let IS_IPHONE_X         = IS_IPHONE && SCREEN_MAX_LENGTH == 812
    static let IS_IPAD_PRO_97 = (IS_IPAD && SCREEN_MAX_LENGTH == Int(1024.0))
    static let IS_IPAD_PRO_105 = (IS_IPAD && SCREEN_MAX_LENGTH == Int(1112.0))
    static let IS_IPAD_PRO_12_INCH = (IS_IPAD && SCREEN_MAX_LENGTH == Int(1366.0))
}

//MARK:- Web URLs
struct WSRequest{
    static let kBaseurl  = "http://tiles.tempoapp.in/api/v1/"
    static let register = "\(kBaseurl)kk-reg-user"
    static let login = "\(kBaseurl)kk-login"
    static let resendCode = "\(kBaseurl)kk-resend-code"
    static let verifyNumber = "\(kBaseurl)kk-verify-number"
    static let logout = "\(kBaseurl)logout"
    static let getProfile = "\(kBaseurl)get-profile"
    static let getProductFilters = "\(kBaseurl)get-product-filters"
    static let getDashboard = "\(kBaseurl)get-dashboard"
    static let getProductConfiguration = "\(kBaseurl)get-product-configuration"
    static let addProductToWatchlist = "\(kBaseurl)add-product-to-watchlist"
    static let removeProductFromWatchlist = "\(kBaseurl)remove-product-from-watchlist"
    static let featuredProducts = "\(kBaseurl)featured-products"
    static let recentlyAddedProducts = "\(kBaseurl)recently-added-products"
    static let firstChoiceProducts = "\(kBaseurl)first-choice-products"
    static let getDirectory = "\(kBaseurl)get-directory"
    static let addDirectoryToWatchlist = "\(kBaseurl)add-directory-to-watchlist"
    static let removeDirectoryFromWatchlist = "\(kBaseurl)remove-directory-from-watchlist"
    static let userProducts = "\(kBaseurl)user-products"
    static let getWatchlistProducts = "\(kBaseurl)get-watchlist-products"
    static let getWatchlistDirectory = "\(kBaseurl)get-watchlist-directory"
    static let categoryProducts = "\(kBaseurl)category-products"
    static let registerConfiguration = "\(kBaseurl)kk-reg-configuration"
    static let sellerReport = "\(kBaseurl)seller-report"
    static let productReport = "\(kBaseurl)product-report"
    static let storeProfile = "\(kBaseurl)store-profile"
    static let productDetail = "\(kBaseurl)product-detail"
    static let sellerDetail = "\(kBaseurl)seller-detail"
    static let paymentPlans = "\(kBaseurl)payment-plans"
    static let deleteProduct = "\(kBaseurl)delete-product"
    static let userViewCount = "\(kBaseurl)user-view-count"
    static let storeProduct = "\(kBaseurl)store-product"
    static let compareProducts = "\(kBaseurl)compare-products"
    static let removeAccount = "\(kBaseurl)remove-account"
    static let verifyRemoveAccount = "\(kBaseurl)verify-remove-account"
    static let storeDeviceToken = "\(kBaseurl)store-device-token"
}

//MARK:- API Error Messages
struct ErrorMsg{
    static let ERR100 = NSLocalizedString("ERR100", comment: "")
}
//MARK:- Save User Information locally
class UserInformation:Codable {
    var id : String?
    var name : String?
    var company_name : String?
    var phone_number : String?
    var state_id : String?
    var state_name : String?
    var city : String?
    var address : String?
    var image : String?
    var is_paid : String?
    var total_view_count : String?
    var view_count : String?
    var api_token : String?
    
    init(dictinfo : [String : Any]) {
        
        api_token = "Bearer \(dictinfo["api_token"] as? String ?? "")"
        
        if let item = dictinfo["id"]{
            if item is String{
                id = item as? String
            }
            else if item is Int{
                id = String(item as! Int)
            }
        }
        name = dictinfo["name"] as? String ?? ""
        company_name = dictinfo["company_name"] as? String ?? ""
        if let item = dictinfo["phone_number"]{
            if item is String{
                phone_number = item as? String
            }
            else if item is Int{
                phone_number = String(item as! Int)
            }
        }
        if let item = dictinfo["state_id"]{
            if item is String{
                state_id = item as? String
            }
            else if item is Int{
                state_id = String(item as! Int)
            }
        }
        state_name = dictinfo["state_name"] as? String ?? ""
        city = dictinfo["city"] as? String ?? ""
        address = dictinfo["address"] as? String ?? ""
        image = dictinfo["image"] as? String ?? ""
        if let item = dictinfo["is_paid"]{
            if item is String{
                is_paid = item as? String
            }
            else if item is Int{
                is_paid = String(item as! Int)
            }
        }
        if let item = dictinfo["total_view_count"]{
            if item is String{
                total_view_count = item as? String
            }
            else if item is Int{
                total_view_count = String(item as! Int)
            }
        }
        if let item = dictinfo["view_count"]{
            if item is String{
                view_count = item as? String
            }
            else if item is Int{
                view_count = String(item as! Int)
            }
        }
    }
}

//MARK:- Get local Data
class Helper: NSObject {
    class func setDatainUserDefault(value : Data,_ keyname : String){
        UserDefaults.standard.set(value, forKey: keyname)
        UserDefaults.standard.synchronize()
    }
    
    class func getDatafromUserDefault(_ keyname : String) -> Data?{
        return UserDefaults.standard.value(forKey: keyname) as? Data
    }
    
    class func getValueFromUserDefault(_ keyname : String) -> Any?{
        return UserDefaults.standard.value(forKey: keyname)
    }
    
    class func setValueInUserDefaults(_ value : Any,_ keyname : String){
        UserDefaults.standard.set(value, forKey: keyname)
        UserDefaults.standard.synchronize()
    }
    
    //MARK:- set and get preferences for NSString
    /*!
     method getPreferenceValueForKey
     abstract To get the preference value for the key that has been passed
     */
    // NSUserDefaults methods which have been used in entire app.
    
    class func getPREF(_ key:String)->String?
    {
        return UserDefaults.standard.value(forKey: key) as? String
    }
    
    class func getUserPREF(_ key:String)->Data?
    {
        return UserDefaults.standard.value(forKey: key as String) as? Data
    }
    
    class func removeValueFromUserDefault(_ key:String){
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    /*!
     method setPreferenceValueForKey for int value
     abstract To set the preference value for the key that has been passed
     */
    
    class func setPREF(_ sValue:String, key:String)
    {
        UserDefaults.standard.setValue(sValue, forKey: key as String)
        UserDefaults.standard.synchronize()
    }
    class func setBoolPREF(_ sValue:Bool , key:String){
        UserDefaults.standard.set(sValue, forKey: key as String)
        UserDefaults.standard.synchronize()
    }
    
    class func showOKAlert(onVC viewController:UIViewController,title:String,message:String){
        // Commonly used in entire app to show UIAlert with Ok
        DispatchQueue.main.async {
            let alert : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title:"Ok", style:.default, handler: nil))
            
            alert.view.setNeedsLayout()
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
