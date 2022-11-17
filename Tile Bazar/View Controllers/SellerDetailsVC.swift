//
//  SellerDetailsVC.swift
//  Tile Bazar
//
//  Created by Apple on 8/27/22.
//

import UIKit
import FirebaseDynamicLinks

class SellerDetailsVC: ParentVC {

    @IBOutlet weak var viewNoData: UIView!
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblCityState: UILabel!
    @IBOutlet weak var lblProductsCount: UILabel!
    @IBOutlet weak var imgWatchlistIcon: UIImageView!
    @IBOutlet weak var lblWatchList: UILabel!
    @IBOutlet weak var lblFollowersCount: UILabel!
    
    var offset = "0"
    var arrSellerProducts:[GetDashboardProductsDataModel] = []
    var refreshcontrol : UIRefreshControl!
    var user_id = ""
    var is_favourite = ""
    var phone_number = ""
    @IBOutlet weak var viewContainer: UIView!
    var is_paid = HomeVC.sharedInstance?.is_paid ?? ""
    static var sharedInstance:SellerDetailsVC?
    var isSubscribePressed = false
    var arrayWatchlistSellerIDs:[String] = []
    var arrayWatchlistProductIDs:[String] = []
    var arrayCompareProductIDs:[String] = []
    @IBOutlet weak var lblCompareCount: UILabel!
    @IBOutlet weak var viewCompareCount: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SellerDetailsVC.sharedInstance = self
        addRefreshcontrol()
        viewContainer.clipsToBounds = true
        viewContainer.layer.cornerRadius = 50
        if #available(iOS 11.0, *) {
            viewContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
        
        // Do any additional setup after loading the view.
        self.wsCallSellerDetails(user_id: self.user_id)
        self.offset = "0"
        self.wsCallGetUserProducts(limit: "10", user_id: self.user_id)
    }
    func addRefreshcontrol(){
        refreshcontrol = UIRefreshControl()
        // Configure Refresh Control
        refreshcontrol.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tblView.addSubview(refreshcontrol)
    }
    override func viewWillAppear(_ animated: Bool) {
        if isSubscribePressed{
            isSubscribePressed = false
            self.showSubsciptionScreen()
        }
        arrayCompareProductIDs = UserDefaults.standard.stringArray(forKey: "arrayCompareProductIDs") ?? [String]()
        checkCompareProducts()
        arrayWatchlistProductIDs = UserDefaults.standard.stringArray(forKey: "arrayWatchlistProductIDs") ?? [String]()
        arrayWatchlistSellerIDs = UserDefaults.standard.stringArray(forKey: "arrayWatchlistSellerIDs") ?? [String]()
        self.tabBarController?.tabBar.isHidden = true
    }
    func checkCompareProducts(){
        self.lblCompareCount.text = "\(self.arrayCompareProductIDs.count)"
        if self.arrayCompareProductIDs.count > 0{
            self.viewCompareCount.isHidden = false
        }
        else{
            self.viewCompareCount.isHidden = true
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    @objc private func refreshData(_ refreshcontrol: UIRefreshControl) {
        offset = "0"
        self.wsCallGetUserProducts(limit: "10", user_id: user_id)
    }
    @IBAction func toggleBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: Button Actions
    @IBAction func toggleReportPost(_ sender: UIButton) {
        let reportPostVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: ReportPostVC.self)) as! ReportPostVC
        reportPostVC.isSellerReport = false
        reportPostVC.product_id = self.arrSellerProducts[sender.tag].id ?? ""
        self.present(reportPostVC, animated: true, completion: nil)
    }
    @IBAction func toggleWatchlist(_ sender: UIButton) {
        if (self.arrSellerProducts[sender.tag].is_favourite ?? "") == "1" || arrayWatchlistProductIDs.contains(self.arrSellerProducts[sender.tag].id ?? ""){
            arrayWatchlistProductIDs.removeElement(element:self.arrSellerProducts[sender.tag].id ?? "")
            wsCallRemoveProductFromWatchlist(product_id: self.arrSellerProducts[sender.tag].id ?? "")
        }
        else{
            arrayWatchlistProductIDs.append(self.arrSellerProducts[sender.tag].id ?? "")
            self.wsCallAddProductToWatchlist(product_id: self.arrSellerProducts[sender.tag].id ?? "")
        }
        UserDefaults.standard.set(self.arrayWatchlistProductIDs, forKey: "arrayWatchlistProductIDs")
        self.tblView.reloadData()
    }
    @IBAction func toggleCompare(_ sender: UIButton) {
        if arrayCompareProductIDs.contains(self.arrSellerProducts[sender.tag].id ?? ""){
            arrayCompareProductIDs.removeElement(element:self.arrSellerProducts[sender.tag].id ?? "")
        }
        else{
            arrayCompareProductIDs.append(self.arrSellerProducts[sender.tag].id ?? "")
        }
        UserDefaults.standard.set(self.arrayCompareProductIDs, forKey: "arrayCompareProductIDs")
        checkCompareProducts()
        self.tblView.reloadData()
    }
    @IBAction func toggleShare(_ sender: UIButton) {
        let product_id = arrSellerProducts[sender.tag].id ?? ""
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
    @IBAction func toggleContactButtons(_ sender: UIButton) {
        //here check for subscription plan and show subscribe
        //is_paid = "2"
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
                viewContactAlertVC.whichScreen = "SellerDetailsVC"
                self.present(viewContactAlertVC, animated: true, completion: nil)
            }
            else{
                //limit reached, so show subscribe screen
                let subscriptionAlertVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: SubscriptionAlertVC.self)) as! SubscriptionAlertVC
                subscriptionAlertVC.isComingFromAddProduct = false
                subscriptionAlertVC.whichScreen = "SellerDetailsVC"
                self.present(subscriptionAlertVC, animated: true, completion: nil)
            }
        }
    }
    @IBAction func toggleButtons(_ sender: UIButton) {
        if sender.tag == 0{
            //watchlist
            if self.is_favourite == "1" || arrayWatchlistSellerIDs.contains(self.user_id){
                arrayWatchlistSellerIDs.removeElement(element:self.user_id)
                wsCallRemoveDirectoryFromWatchlist(user_id: self.user_id)
                self.is_favourite = "0"
                self.imgWatchlistIcon.image = UIImage(named: "icon_add_watchlist")
                self.lblWatchList.textColor = UIColor.darkGray
            }
            else{
                self.is_favourite = "1"
                self.imgWatchlistIcon.image = UIImage(named: "icon_remove_watchlist")
                self.lblWatchList.textColor = UIColor(hexString: "#c0252b")
                arrayWatchlistSellerIDs.append(self.user_id)
                self.wsCallAddDirectoryToWatchlist(user_id: self.user_id)
            }
            UserDefaults.standard.set(self.arrayWatchlistSellerIDs, forKey: "arrayWatchlistSellerIDs")
            
        }
        else if sender.tag == 1{
            //share
            guard let link = URL(string:"https://tilesbazar.page.link/sellerdetails/\(user_id)") else { return }
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
        else{
            //report
            let reportPostVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: ReportPostVC.self)) as! ReportPostVC
            reportPostVC.isSellerReport = true
            reportPostVC.user_id = self.user_id
            self.present(reportPostVC, animated: true, completion: nil)
        }
    }
    func showMembership(){
        self.showSubsciptionScreen()
    }
}
extension SellerDetailsVC:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSellerProducts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellHomeProducts") as! CellHomeProducts
        cell.btnReport.tag = indexPath.row
        cell.btnWatchlist.tag = indexPath.row
        cell.btnCompare.tag = indexPath.row
        cell.btnShare.tag = indexPath.row
        
        cell.lblCategoryName.font = UIFont(name: "Biennale-SemiBold", size: 16)
        cell.lblCompanyName.font = UIFont(name: "Biennale-Medium", size: 12)
        cell.lblSize.font = UIFont(name: "Biennale-Regular", size: 13)
        cell.lblGrade.font = UIFont(name: "Biennale-Regular", size: 13)
        cell.lblReportTitle.font = UIFont(name: "Biennale-Regular", size: 12)
        
        cell.imgProduct.sd_setImage(with:URL(string:arrSellerProducts[indexPath.row].category_image ?? ""), completed: { (image, error, SDImageCacheTypeDisk, url) in
        })
        cell.lblCategoryName.text = self.arrSellerProducts[indexPath.row].category_name ?? ""
        
        if (HomeVC.sharedInstance?.is_paid ?? "") == "2"{
            cell.lblCompanyName.text = self.arrSellerProducts[indexPath.row].company_name ?? ""
        }
        else{
            cell.lblCompanyName.text = self.starifyNumber(number:self.arrSellerProducts[indexPath.row].company_name ?? "")
        }
        
        let attributedStringSize = NSMutableAttributedString(string: "Size: ")
        let sizeAttrs = [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.black]
        let sizeNameFont = NSMutableAttributedString(string:self.arrSellerProducts[indexPath.row].tile_size_name ?? "", attributes: sizeAttrs)
        attributedStringSize.insert(sizeNameFont, at: 6)
        cell.lblSize.attributedText = attributedStringSize
        
        if (self.arrSellerProducts[indexPath.row].grade_name ?? "") == "Premium"{
            //green
            let attributedStringGrade = NSMutableAttributedString(string: "Grade: ")
            let gradeAttrs = [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor(hexString: "#00ae46")]
            let gradeNameFont = NSMutableAttributedString(string:self.arrSellerProducts[indexPath.row].grade_name ?? "", attributes: gradeAttrs)
            attributedStringGrade.insert(gradeNameFont, at: 7)
            cell.lblGrade.attributedText = attributedStringGrade
        }
        else if (self.arrSellerProducts[indexPath.row].grade_name ?? "") == "Standard" || (self.arrSellerProducts[indexPath.row].grade_name ?? "") == "Commercial" || (self.arrSellerProducts[indexPath.row].grade_name ?? "") == "Eco"{
            //blue
            let attributedStringGrade = NSMutableAttributedString(string: "Grade: ")
            let gradeAttrs = [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor(hexString: "#0065FF")]
            let gradeNameFont = NSMutableAttributedString(string:self.arrSellerProducts[indexPath.row].grade_name ?? "", attributes: gradeAttrs)
            attributedStringGrade.insert(gradeNameFont, at: 7)
            cell.lblGrade.attributedText = attributedStringGrade
        }
        else{
            //red
            let attributedStringGrade = NSMutableAttributedString(string: "Grade: ")
            let gradeAttrs = [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor(hexString: "#e50914")]
            let gradeNameFont = NSMutableAttributedString(string:self.arrSellerProducts[indexPath.row].grade_name ?? "", attributes: gradeAttrs)
            attributedStringGrade.insert(gradeNameFont, at: 7)
            cell.lblGrade.attributedText = attributedStringGrade
        }
        
        let priceTypeName = (self.arrSellerProducts[indexPath.row].price_type_name ?? "").replacingOccurrences(of: "per ", with: "").firstCapitalized
        cell.lblPriceAndType.text = "\(self.arrSellerProducts[indexPath.row].price ?? "")/\(priceTypeName)"
        if (self.arrSellerProducts[indexPath.row].is_favourite ?? "") == "1" || arrayWatchlistProductIDs.contains(self.arrSellerProducts[indexPath.row].id ?? ""){
            cell.imgWatchlistIcon.image = UIImage(named: "icon_remove_watchlist")
            cell.lblWatchList.textColor = UIColor(hexString: "#c0252b")
        }
        else{
            cell.imgWatchlistIcon.image = UIImage(named: "icon_add_watchlist")
            cell.lblWatchList.textColor = UIColor.darkGray
        }
        if arrayCompareProductIDs.contains(self.arrSellerProducts[indexPath.row].id ?? "")
        {
            cell.imgCompare.image = UIImage(named: "compare_selected")
            cell.lblCompare.textColor = UIColor(hexString: "#c0252b")
        }
        else{
            cell.imgCompare.image = UIImage(named: "compare_select")
            cell.lblCompare.textColor = UIColor.darkGray
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productDetailsVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: ProductDetailsVC.self)) as! ProductDetailsVC
        productDetailsVC.product_id = self.arrSellerProducts[indexPath.row].id ?? ""
        self.navigationController?.pushViewController(productDetailsVC, animated: true)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        if scrollView == tblView{
            // UITableView only moves in one direction, y axis
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            // Change 10.0 to adjust the distance from bottom
            if maximumOffset - currentOffset <= 10.0 {
                if self.offset != "0"{
                    wsCallGetUserProducts(limit: "10", user_id: self.user_id)
                }
            }
        }
    }
}
extension SellerDetailsVC{
    func wsCallSellerDetails(user_id:String){
        self.showSpinner()
        let param = ["id":user_id]
        WSCalls.sharedInstance.apiCallWithHeader(url: WSRequest.sellerDetail, method: .post, param:param, headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            self.hideSpinner()
            print(response)
            let image = response["Data"]!["image"] as? String ?? ""
            let company_name = response["Data"]!["company_name"] as? String ?? ""
            let city = response["Data"]!["city"] as? String ?? ""
            let state_name = response["Data"]!["state_name"] as? String ?? ""
            self.imgUser.sd_setImage(with:URL(string:image), completed: { (image, error, SDImageCacheTypeDisk, url) in
            })
            self.lblCompanyName.text = company_name
            
            if (HomeVC.sharedInstance?.is_paid ?? "") == "2"{
                self.lblCompanyName.text = company_name
            }
            else{
                self.lblCompanyName.text = self.starifyNumber(number:company_name)
            }
            
            self.lblCityState.text = "\(city), \(state_name)"
        
            var total_products = ""
            if let item = response["Data"]!["total_products"]{
                if item is String{
                    total_products = (item as? String)!
                }
                else if item is Int{
                    total_products = String(item as! Int)
                }
                else if item is Double{
                    total_products = String(item as! Double)
                }
            }
            self.lblProductsCount.text = "\(total_products) Products"
        
            if let item = response["Data"]!["is_favourite"]{
                if item is String{
                    self.is_favourite = (item as? String)!
                }
                else if item is Int{
                    self.is_favourite = String(item as! Int)
                }
            }
            if self.is_favourite == "1" || self.arrayWatchlistSellerIDs.contains(self.user_id){
                self.imgWatchlistIcon.image = UIImage(named: "icon_remove_watchlist")
                self.lblWatchList.textColor = UIColor(hexString: "#c0252b")
            }
            else{
                self.imgWatchlistIcon.image = UIImage(named: "icon_add_watchlist")
                self.lblWatchList.textColor = UIColor.darkGray
            }
            
            if let item = response["Data"]!["phone_number"]{
                if item is String{
                    self.phone_number = (item as? String)!
                }
                else if item is Int{
                    self.phone_number = String(item as! Int)
                }
            }
            
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
    private func wsCallGetUserProducts(limit:String,user_id:String){
        if !refreshcontrol.isRefreshing{
            self.showSpinner()
        }
        WSCalls.sharedInstance.apiCallWithHeader(url:WSRequest.userProducts, method: .post, param: ["limit":limit,"user_id":user_id,"offset":self.offset], headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            print(response)
            self.hideSpinner()
            self.refreshcontrol.endRefreshing()
            if self.offset == "0"{
                self.arrSellerProducts.removeAll()
            }
            if let item = response["offset"]{
                if item is String{
                    self.offset = (item as? String)!
                }
                else if item is Int{
                    self.offset = String(item as! Int)
                }
                let arrData = response["Data"] as? [[String:Any]] ?? []
                if arrData.count > 0{
                    for obj in arrData{
                        let obj = GetDashboardProductsDataModel(dictinfo: obj)
                        self.arrSellerProducts.append(obj)
                    }
                }
            }
            if self.arrSellerProducts.count > 0{
                self.viewNoData.isHidden = true
            }
            else{
                self.viewNoData.isHidden = false
            }
            self.tblView.reloadData()
            
        }, erroHandler: { (response, statuscode) in
            print("Error\(response)")
            self.hideSpinner()
            self.refreshcontrol.endRefreshing()
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
            self.refreshcontrol.endRefreshing()
        }
    }
    func wsCallAddProductToWatchlist(product_id:String){
        let param = ["product_id":product_id]
        WSCalls.sharedInstance.apiCallWithHeader(url: WSRequest.addProductToWatchlist, method: .post, param:param, headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            print(response)
            
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
        }
    }
    func wsCallAddDirectoryToWatchlist(user_id:String){
        let param = ["user_id":user_id]
        WSCalls.sharedInstance.apiCallWithHeader(url: WSRequest.addDirectoryToWatchlist, method: .post, param:param, headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            print(response)
            
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
    func wsCallRemoveDirectoryFromWatchlist(user_id:String){
        let param = ["user_id":user_id]
        WSCalls.sharedInstance.apiCallWithHeader(url: WSRequest.removeDirectoryFromWatchlist, method: .post, param:param, headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            print(response)
            
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

