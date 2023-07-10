//
//  MarketVC.swift
//  Tile Bazar
//
//  Created by Apple on 8/13/22.
//

import UIKit
import FirebaseDynamicLinks

class MarketVC: ParentVC {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewSellBtn: UIView!
    var offset = "0"
    var sort_by = "0"
    var arrUserProducts:[GetDashboardProductsDataModel] = []
    var refreshcontrol : UIRefreshControl!
    var filter_params : [String:Any] = [:]
    var filterArray : [[String:Any]] = []
    var filterArrayForReset : [[String:Any]] = []
    static var sharedInstance:MarketVC?
    var arrProductIDs:[String] = []
    
    var arrayCompareProductIDs:[String] = []
    var arrayWatchlistProductIDs:[String] = []
    @IBOutlet weak var lblCompareCount: UILabel!
    @IBOutlet weak var viewCompareCount: UIView!
    @IBOutlet weak var viewNoData: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MarketVC.sharedInstance = self
        addRefreshcontrol()
        callWebservice()
        // Do any additional setup after loading the view.
    }
    func callWebservice(){
        offset = "0"
        self.arrProductIDs.removeAll()
        wsCallGetUserProducts(limit: "10", sort_by: sort_by)
    }
    func addRefreshcontrol(){
        refreshcontrol = UIRefreshControl()
        // Configure Refresh Control
        refreshcontrol.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tblView.addSubview(refreshcontrol)
    }
    override func viewWillAppear(_ animated: Bool) {
        arrayCompareProductIDs = UserDefaults.standard.stringArray(forKey: "arrayCompareProductIDs") ?? [String]()
        checkCompareProducts()
        arrayWatchlistProductIDs = UserDefaults.standard.stringArray(forKey: "arrayWatchlistProductIDs") ?? [String]()
        self.tblView.reloadData()
    }
    @objc private func refreshData(_ refreshcontrol: UIRefreshControl) {
        self.filterArray.removeAll()
        self.filterArrayForReset.removeAll()
        self.filter_params.removeAll()
        self.sort_by = "0"
        callWebservice()
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
    @IBAction func toggleButtons(_ sender: UIButton) {
        if sender.tag == 0{
            //sort
            let alert = UIAlertController(title:"Sort By", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title:"Name A to Z", style: .default, handler:{ _ in
                if self.sort_by != "1"{
                    self.sort_by = "1"
                    self.offset = "0"
                    self.arrProductIDs.removeAll()
                    self.wsCallGetUserProducts(limit: "10", sort_by: self.sort_by)
                }
            }))
            alert.addAction(UIAlertAction(title:"Name Z to A", style: .default, handler:{ _ in
                if self.sort_by != "2"{
                    self.sort_by = "2"
                    self.offset = "0"
                    self.arrProductIDs.removeAll()
                    self.wsCallGetUserProducts(limit: "10", sort_by: self.sort_by)
                }
            }))
            alert.addAction(UIAlertAction(title:"Price Low to High", style: .default, handler:{ _ in
                if self.sort_by != "3"{
                    self.sort_by = "3"
                    self.offset = "0"
                    self.arrProductIDs.removeAll()
                    self.wsCallGetUserProducts(limit: "10", sort_by: self.sort_by)
                }
            }))
            alert.addAction(UIAlertAction(title:"Price High to Low", style: .default, handler:{ _ in
                if self.sort_by != "4"{
                    self.sort_by = "4"
                    self.offset = "0"
                    self.arrProductIDs.removeAll()
                    self.wsCallGetUserProducts(limit: "10", sort_by: self.sort_by)
                }
            }))
            alert.addAction(UIAlertAction(title:"Date Modified", style: .default, handler:{ _ in
                if self.sort_by != "5"{
                    self.sort_by = "5"
                    self.offset = "0"
                    self.arrProductIDs.removeAll()
                    self.wsCallGetUserProducts(limit: "10", sort_by: self.sort_by)
                }
            }))
            alert.addAction(UIAlertAction.init(title:"Cancel", style: .cancel, handler: nil))
            if let popoverController = alert.popoverPresentationController {
              popoverController.sourceView = self.view
              popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
              popoverController.permittedArrowDirections = []
            }
            self.present(alert, animated: true, completion: nil)
        }
        else if sender.tag == 1{
            //filter
            let filtersVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: FiltersVC.self)) as! FiltersVC
            filtersVC.filterArray = self.filterArray
            self.navigationController?.pushViewController(filtersVC, animated: true)
        }
        else{
            //sell
            if let info = Helper.getDatafromUserDefault("UserInformation"){
                self.showAddProductScreen()
            }
            else{
                self.showLoginAlertPopUp()
            }
        }
    }
    //MARK: Button Actions
    @IBAction func toggleReportPost(_ sender: UIButton) {
        if let info = Helper.getDatafromUserDefault("UserInformation"){
            let reportPostVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: ReportPostVC.self)) as! ReportPostVC
            reportPostVC.isSellerReport = false
            reportPostVC.product_id = self.arrUserProducts[sender.tag].id ?? ""
            self.present(reportPostVC, animated: true, completion: nil)
        }
        else{
            self.showLoginAlertPopUp()
        }
    }
    @IBAction func toggleWatchlist(_ sender: UIButton) {
        if let info = Helper.getDatafromUserDefault("UserInformation"){
            if (self.arrUserProducts[sender.tag].is_favourite ?? "") == "1" || arrayWatchlistProductIDs.contains(self.arrUserProducts[sender.tag].id ?? ""){
                arrayWatchlistProductIDs.removeElement(element:self.arrUserProducts[sender.tag].id ?? "")
                wsCallRemoveProductFromWatchlist(product_id: self.arrUserProducts[sender.tag].id ?? "")
            }
            else{
                arrayWatchlistProductIDs.append(self.arrUserProducts[sender.tag].id ?? "")
                self.wsCallAddProductToWatchlist(product_id: self.arrUserProducts[sender.tag].id ?? "")
            }
            UserDefaults.standard.set(self.arrayWatchlistProductIDs, forKey: "arrayWatchlistProductIDs")
            self.tblView.reloadData()
        }
        else{
            self.showLoginAlertPopUp()
        }
    }
    @IBAction func toggleCompare(_ sender: UIButton) {
        if arrayCompareProductIDs.contains(self.arrUserProducts[sender.tag].id ?? ""){
            arrayCompareProductIDs.removeElement(element:self.arrUserProducts[sender.tag].id ?? "")
        }
        else{
            arrayCompareProductIDs.append(self.arrUserProducts[sender.tag].id ?? "")
        }
        UserDefaults.standard.set(self.arrayCompareProductIDs, forKey: "arrayCompareProductIDs")
        checkCompareProducts()
        self.tblView.reloadData()
    }
    @IBAction func toggleShare(_ sender: UIButton) {
        let product_id = arrUserProducts[sender.tag].id ?? ""
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
}
extension MarketVC:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUserProducts.count
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
        
        cell.imgProduct.sd_setImage(with:URL(string:arrUserProducts[indexPath.row].category_image ?? ""), completed: { (image, error, SDImageCacheTypeDisk, url) in
        })
        cell.lblCategoryName.text = self.arrUserProducts[indexPath.row].category_name ?? ""
        
        if (HomeVC.sharedInstance?.is_paid ?? "") == "2"{
            cell.lblCompanyName.text = self.arrUserProducts[indexPath.row].company_name ?? ""
        }
        else{
            cell.lblCompanyName.text = self.starifyNumber(number:self.arrUserProducts[indexPath.row].company_name ?? "")
        }
        
        let attributedStringSize = NSMutableAttributedString(string: "Size: ")
        let sizeAttrs = [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.black]
        let sizeNameFont = NSMutableAttributedString(string:self.arrUserProducts[indexPath.row].tile_size_name ?? "", attributes: sizeAttrs)
        attributedStringSize.insert(sizeNameFont, at: 6)
        cell.lblSize.attributedText = attributedStringSize
        
        if (self.arrUserProducts[indexPath.row].grade_name ?? "") == "Premium"{
            //green
            let attributedStringGrade = NSMutableAttributedString(string: "Grade: ")
            let gradeAttrs = [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor(hexString: "#00ae46")]
            let gradeNameFont = NSMutableAttributedString(string:self.arrUserProducts[indexPath.row].grade_name ?? "", attributes: gradeAttrs)
            attributedStringGrade.insert(gradeNameFont, at: 7)
            cell.lblGrade.attributedText = attributedStringGrade
        }
        else if (self.arrUserProducts[indexPath.row].grade_name ?? "") == "Standard" || (self.arrUserProducts[indexPath.row].grade_name ?? "") == "Commercial" || (self.arrUserProducts[indexPath.row].grade_name ?? "") == "Eco"{
            //blue
            let attributedStringGrade = NSMutableAttributedString(string: "Grade: ")
            let gradeAttrs = [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor(hexString: "#0065FF")]
            let gradeNameFont = NSMutableAttributedString(string:self.arrUserProducts[indexPath.row].grade_name ?? "", attributes: gradeAttrs)
            attributedStringGrade.insert(gradeNameFont, at: 7)
            cell.lblGrade.attributedText = attributedStringGrade
        }
        else{
            //red
            let attributedStringGrade = NSMutableAttributedString(string: "Grade: ")
            let gradeAttrs = [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor(hexString: "#e50914")]
            let gradeNameFont = NSMutableAttributedString(string:self.arrUserProducts[indexPath.row].grade_name ?? "", attributes: gradeAttrs)
            attributedStringGrade.insert(gradeNameFont, at: 7)
            cell.lblGrade.attributedText = attributedStringGrade
        }
        
        let priceTypeName = (self.arrUserProducts[indexPath.row].price_type_name ?? "").replacingOccurrences(of: "per ", with: "").firstCapitalized
        cell.lblPriceAndType.text = "\(self.arrUserProducts[indexPath.row].price ?? "")/\(priceTypeName)"
        if (self.arrUserProducts[indexPath.row].is_favourite ?? "") == "1" || arrayWatchlistProductIDs.contains(self.arrUserProducts[indexPath.row].id ?? ""){
            cell.imgWatchlistIcon.image = UIImage(named: "icon_remove_watchlist")
            cell.lblWatchList.textColor = UIColor(hexString: "#c0252b")
        }
        else{
            cell.imgWatchlistIcon.image = UIImage(named: "icon_add_watchlist")
            cell.lblWatchList.textColor = UIColor.darkGray
        }
        if arrayCompareProductIDs.contains(self.arrUserProducts[indexPath.row].id ?? "")
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
        productDetailsVC.product_id = self.arrUserProducts[indexPath.row].id ?? ""
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
                    wsCallGetUserProducts(limit: "10", sort_by: sort_by)
                }
            }
        }
    }
}
extension MarketVC{
    private func wsCallGetUserProducts(limit:String,sort_by:String){
        if !refreshcontrol.isRefreshing{
            self.showSpinner()
        }
        let jsonData = try! JSONSerialization.data(withJSONObject: self.filter_params, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
        
        let product_ids = self.arrProductIDs.joined(separator: ",")
        
        WSCalls.sharedInstance.apiCallWithHeader(url:WSRequest.userProducts, method: .post, param: ["limit":limit,"sort":sort_by,"filters":jsonString,"offset":self.offset,"product_ids":product_ids], headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            print(response)
            self.hideSpinner()
            self.refreshcontrol.endRefreshing()
            if self.offset == "0"{
                self.arrUserProducts.removeAll()
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
                        self.arrUserProducts.append(obj)
                    }
                }
            }
            
            if self.arrUserProducts.count > 0{
                self.viewNoData.isHidden = true
                for i in 0..<self.arrUserProducts.count{
                    self.arrProductIDs.append(self.arrUserProducts[i].id ?? "")
                }
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
