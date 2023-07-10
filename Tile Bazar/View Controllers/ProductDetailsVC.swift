//
//  ProductDetailsVC.swift
//  Tile Bazar
//
//  Created by Apple on 8/25/22.
//

import UIKit
import FirebaseDynamicLinks

class CellProductDetailsList:UITableViewCell{
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
}
class ProductDetailsVC: ParentVC {
    
    @IBOutlet var viewHeader: UIView!
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblGrade: UILabel!
    @IBOutlet weak var lblPriceAndType: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    
    @IBOutlet weak var lblReportTitle: UILabel!
    @IBOutlet weak var btnWatchlist: UIButton!
    @IBOutlet weak var btnCompare: UIButton!
    var product_id = ""
    var arrList = ["Size","No. of pcs/box","Thickness (in mm)","Weight/box (in kgs)","Coverage/box (in sq.ft)","Price (in INR ex. Morbi)","Price Type","Price Category","Payment Terms (in days)","Posted On"]
    var is_favourite = ""
    
    var tile_size_name = ""
    var quantity = ""
    var thickness = ""
    var weight = ""
    var coverage = ""
    var price = ""
    var price_type_name = ""
    var price_category_name = ""
    var payment_terms = ""
    var created_at = ""
    var phone_number = ""
    var is_paid = HomeVC.sharedInstance?.is_paid ?? ""
    static var sharedInstance:ProductDetailsVC?
    var arrayCompareProductIDs:[String] = []
    var arrayWatchlistProductIDs:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnWatchlist.setImage(UIImage(named: "icon_add_watchlist"), for: .normal)
        btnWatchlist.setImage(UIImage(named: "icon_remove_watchlist"), for: .selected)
        
        btnCompare.setImage(UIImage(named: "compare_select"), for: .normal)
        btnCompare.setImage(UIImage(named: "compare_selected"), for: .selected)
        
        self.lblCategoryName.font = UIFont(name: "Biennale-SemiBold", size: 16)
        self.lblCompanyName.font = UIFont(name: "Biennale-Medium", size: 12)
        self.lblGrade.font = UIFont(name: "Biennale-Regular", size: 13)
        self.lblReportTitle.font = UIFont(name: "Biennale-Regular", size: 12)
        
        ProductDetailsVC.sharedInstance = self
        tblView.tableHeaderView = viewHeader
        wsCallProductDetails(product_id: product_id)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        arrayCompareProductIDs = UserDefaults.standard.stringArray(forKey: "arrayCompareProductIDs") ?? [String]()
        checkCompareProducts()
        arrayWatchlistProductIDs = UserDefaults.standard.stringArray(forKey: "arrayWatchlistProductIDs") ?? [String]()
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    @IBAction func toggleBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func toggleReportPost(_ sender: UIButton) {
        if let info = Helper.getDatafromUserDefault("UserInformation"){
            let reportPostVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: ReportPostVC.self)) as! ReportPostVC
            reportPostVC.isSellerReport = false
            reportPostVC.product_id = self.product_id
            self.present(reportPostVC, animated: true, completion: nil)
        }
        else{
            self.showLoginAlertPopUp()
        }
    }
    @IBAction func toggleWatchlist(_ sender: UIButton) {
        if let info = Helper.getDatafromUserDefault("UserInformation"){
            if self.is_favourite == "1" || arrayWatchlistProductIDs.contains(self.product_id){
                arrayWatchlistProductIDs.removeElement(element:self.product_id)
                wsCallRemoveProductFromWatchlist(product_id: self.product_id)
            }
            else{
                arrayWatchlistProductIDs.append(self.product_id)
                self.wsCallAddProductToWatchlist(product_id: self.product_id)
            }
            UserDefaults.standard.set(self.arrayWatchlistProductIDs, forKey: "arrayWatchlistProductIDs")
        }
        else{
            self.showLoginAlertPopUp()
        }
    }
    @IBAction func toggleCompare(_ sender: UIButton) {
        if arrayCompareProductIDs.contains(product_id){
            arrayCompareProductIDs.removeElement(element:product_id)
        }
        else{
            arrayCompareProductIDs.append(product_id)
        }
        UserDefaults.standard.set(self.arrayCompareProductIDs, forKey: "arrayCompareProductIDs")
        checkCompareProducts()
    }
    @IBAction func toggleShare(_ sender: UIButton) {
        guard let link = URL(string:"https://tilesbazar.page.link/productdetails/\(product_id)") else { return }
        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix:"https://tilesbazar.page.link")
        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID:"com.app.Tile-Bazar")
        linkBuilder?.iOSParameters?.appStoreID = "6443541980"
        linkBuilder?.androidParameters = DynamicLinkAndroidParameters(packageName: "com.app.tilesbazar")
        guard let longDynamicLink = linkBuilder?.url else { return }
       
        DynamicLinkComponents.shortenURL(longDynamicLink, options: nil) { url, warnings, error in
            if url != nil{
                let activityViewController = UIActivityViewController(activityItems: ["\(userInfo?.name ?? "") shared a best deal with you. Please check and get more exclusive deals.",url!], applicationActivities: nil)
                if let popoverController = activityViewController.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    func checkCompareProducts(){
        if arrayCompareProductIDs.contains(product_id)
        {
            btnCompare.isSelected = true
        }
        else{
            btnCompare.isSelected = false
        }
    }
    @IBAction func toggleContactButtons(_ sender: UIButton) {
        //here check for subscription plan and show subscribe
        if let info = Helper.getDatafromUserDefault("UserInformation"){
            if is_paid == "2"{
                //premium
                if sender.tag == 1{
                    //whatsapp
                    self.openWhatsapp(phoneNumber: self.phone_number)
                }
                else{
                    //call
                    self.makeAPhoneCall(phoneNumber: self.phone_number)
                }
            }
            else{
                //free user
                let subscriptionAlertVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: SubscriptionAlertVC.self)) as! SubscriptionAlertVC
                subscriptionAlertVC.isComingFromAddProduct = false
                subscriptionAlertVC.whichScreen = "ProductDetailsVC"
                self.present(subscriptionAlertVC, animated: true, completion: nil)
                /*
                let view_count = Int(HomeVC.sharedInstance?.view_count ?? "") ?? 0
                if view_count > 0{
                    let viewContactAlertVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: ViewContactAlertVC.self)) as! ViewContactAlertVC
                    viewContactAlertVC.isComingFromAddProduct = false
                    viewContactAlertVC.phone_number = self.phone_number
                    if sender.tag == 1{
                        //whatsapp
                        viewContactAlertVC.isCallSelected = false
                    }
                    else{
                        //call
                        viewContactAlertVC.isCallSelected = true
                    }
                    viewContactAlertVC.whichScreen = "ProductDetailsVC"
                    self.present(viewContactAlertVC, animated: true, completion: nil)
                }
                else{
                    //limit reached, so show subscribe screen
                    let subscriptionAlertVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: SubscriptionAlertVC.self)) as! SubscriptionAlertVC
                    subscriptionAlertVC.isComingFromAddProduct = false
                    subscriptionAlertVC.whichScreen = "ProductDetailsVC"
                    self.present(subscriptionAlertVC, animated: true, completion: nil)
                }
                */
            }
        }
        else{
            self.showLoginAlertPopUp()
        }
    }
    func showMembership(){
        self.showSubsciptionScreen()
    }
}
extension ProductDetailsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellProductDetailsList") as! CellProductDetailsList
        cell.lblTitle.text = arrList[indexPath.row]
        if indexPath.row == 0{
            cell.lblValue.text = tile_size_name
        }
        else if indexPath.row == 1{
            cell.lblValue.text = quantity
        }
        else if indexPath.row == 2{
            cell.lblValue.text = thickness
        }
        else if indexPath.row == 3{
            cell.lblValue.text = weight
        }
        else if indexPath.row == 4{
            cell.lblValue.text = coverage
        }
        else if indexPath.row == 5{
            cell.lblValue.text = price
        }
        else if indexPath.row == 6{
            cell.lblValue.text = price_type_name
        }
        else if indexPath.row == 7{
            cell.lblValue.text = price_category_name
        }
        else if indexPath.row == 8{
            cell.lblValue.text = payment_terms
        }
        else if indexPath.row == 9{
            cell.lblValue.text = created_at
        }
        else{
            cell.lblValue.text = ""
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
extension ProductDetailsVC{
    func wsCallProductDetails(product_id:String){
        self.showSpinner()
        let param = ["id":product_id]
        WSCalls.sharedInstance.apiCallWithHeader(url: WSRequest.productDetail, method: .post, param:param, headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            self.hideSpinner()
            print(response)
            
            let category_image = response["Data"]!["category_image"] as? String ?? ""
            let category_name = response["Data"]!["category_name"] as? String ?? ""
            let company_name = response["Data"]!["company_name"] as? String ?? ""
            let grade_name = response["Data"]!["grade_name"] as? String ?? ""
            let city = response["Data"]!["city"] as? String ?? ""
            let state_name = response["Data"]!["state_name"] as? String ?? ""
            
            self.imgProduct.sd_setImage(with:URL(string:category_image), completed: { (image, error, SDImageCacheTypeDisk, url) in
            })
            self.lblCategoryName.text = category_name
            
            if (HomeVC.sharedInstance?.is_paid ?? "") == "2"{
                self.lblCompanyName.text = company_name
            }
            else{
                self.lblCompanyName.text = self.starifyNumber(number:company_name)
            }
            
            self.lblAddress.text = "\(city), \(state_name)"
            
            if grade_name == "Premium"{
                //green
                let attributedStringGrade = NSMutableAttributedString(string: "Grade: ")
                let gradeAttrs = [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor(hexString: "#00ae46")]
                let gradeNameFont = NSMutableAttributedString(string:grade_name, attributes: gradeAttrs)
                attributedStringGrade.insert(gradeNameFont, at: 7)
                self.lblGrade.attributedText = attributedStringGrade
            }
            else if grade_name == "Standard" || grade_name == "Commercial" || grade_name == "Eco"{
                //blue
                let attributedStringGrade = NSMutableAttributedString(string: "Grade: ")
                let gradeAttrs = [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor(hexString: "#0065FF")]
                let gradeNameFont = NSMutableAttributedString(string:grade_name, attributes: gradeAttrs)
                attributedStringGrade.insert(gradeNameFont, at: 7)
                self.lblGrade.attributedText = attributedStringGrade
            }
            else{
                //red
                let attributedStringGrade = NSMutableAttributedString(string: "Grade: ")
                let gradeAttrs = [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor(hexString: "#e50914")]
                let gradeNameFont = NSMutableAttributedString(string:grade_name, attributes: gradeAttrs)
                attributedStringGrade.insert(gradeNameFont, at: 7)
                self.lblGrade.attributedText = attributedStringGrade
            }
            
            let price_type_name = response["Data"]!["price_type_name"] as? String ?? ""
            
            if let item = response["Data"]!["price"]{
                if item is String{
                    self.price = (item as? String)!
                }
                else if item is Int{
                    self.price = String(item as! Int)
                }
                else if item is Double{
                    self.price = String(item as! Double)
                }
            }
            let priceTypeName = (price_type_name).replacingOccurrences(of: "per ", with: "").firstCapitalized
            self.lblPriceAndType.text = "\(self.price)/\(priceTypeName)"
            
            if let item = response["Data"]!["is_favourite"]{
                if item is String{
                    self.is_favourite = (item as? String)!
                }
                else if item is Int{
                    self.is_favourite = String(item as! Int)
                }
            }
            if self.is_favourite == "1" || self.arrayWatchlistProductIDs.contains(self.product_id){
                self.btnWatchlist.isSelected = true
            }
            else{
                self.btnWatchlist.isSelected = false
            }
            if let item = response["Data"]!["tile_size_name"]{
                if item is String{
                    self.tile_size_name = (item as? String)!
                }
                else if item is Int{
                    self.tile_size_name = String(item as! Int)
                }
            }
            if let item = response["Data"]!["quantity"]{
                if item is String{
                    self.quantity = (item as? String)!
                }
                else if item is Int{
                    self.quantity = String(item as! Int)
                }
                else if item is Double{
                    self.quantity = String(item as! Double)
                }
            }
            if let item = response["Data"]!["thickness"]{
                if item is String{
                    self.thickness = (item as? String)!
                }
                else if item is Int{
                    self.thickness = String(item as! Int)
                }
                else if item is Double{
                    self.thickness = String(item as! Double)
                }
            }
            if let item = response["Data"]!["weight"]{
                if item is String{
                    self.weight = (item as? String)!
                }
                else if item is Int{
                    self.weight = String(item as! Int)
                }
                else if item is Double{
                    self.weight = String(item as! Double)
                }
            }
            if let item = response["Data"]!["coverage"]{
                if item is String{
                    self.coverage = (item as? String)!
                }
                else if item is Int{
                    self.coverage = String(item as! Int)
                }
                else if item is Double{
                    self.coverage = String(item as! Double)
                }
            }
            if let item = response["Data"]!["price"]{
                if item is String{
                    self.price = (item as? String)!
                }
                else if item is Int{
                    self.price = String(item as! Int)
                }
                else if item is Double{
                    self.price = String(item as! Double)
                }
            }
            if let item = response["Data"]!["price_type_name"]{
                if item is String{
                    self.price_type_name = (item as? String)!
                }
                else if item is Int{
                    self.price_type_name = String(item as! Int)
                }
            }
            if let item = response["Data"]!["price_category_name"]{
                if item is String{
                    self.price_category_name = (item as? String)!
                }
                else if item is Int{
                    self.price_category_name = String(item as! Int)
                }
            }
            if let item = response["Data"]!["payment_terms"]{
                if item is String{
                    self.payment_terms = (item as? String)!
                }
                else if item is Int{
                    self.payment_terms = String(item as! Int)
                }
            }
            if let item = response["Data"]!["created_at"]{
                if item is String{
                    self.created_at = (item as? String)!
                }
                else if item is Int{
                    self.created_at = String(item as! Int)
                }
            }
            if let item = response["Data"]!["phone_number"]{
                if item is String{
                    self.phone_number = (item as? String)!
                }
                else if item is Int{
                    self.phone_number = String(item as! Int)
                }
            }
            self.tblView.reloadData()
            
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
    func wsCallAddProductToWatchlist(product_id:String){
        let param = ["product_id":product_id]
        WSCalls.sharedInstance.apiCallWithHeader(url: WSRequest.addProductToWatchlist, method: .post, param:param, headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            print(response)
            self.btnWatchlist.isSelected = true
            self.is_favourite = "1"
            
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
                HomeVC.sharedInstance?.wscallLogoutUser()
            }
            else{
                self.showToast(title:response["Message"] as? String ?? "")
            }
            
        }) { (error) in
        }
    }
    func wsCallRemoveProductFromWatchlist(product_id:String){
        let param = ["product_id":product_id]
        WSCalls.sharedInstance.apiCallWithHeader(url: WSRequest.removeProductFromWatchlist, method: .post, param:param, headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            print(response)
            self.btnWatchlist.isSelected = false
            self.is_favourite = "0"
            
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
                HomeVC.sharedInstance?.wscallLogoutUser()
            }
            else{
                self.showToast(title:response["Message"] as? String ?? "")
            }
            
        }) { (error) in
        }
    }
}
