//
//  ProductsVC.swift
//  Tile Bazar
//
//  Created by Apple on 8/14/22.
//

import UIKit
import FirebaseDynamicLinks

class ProductsVC: ParentVC {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    var offset = "0"
    var arrWatchlistProducts:[GetDashboardProductsDataModel] = []
    var refreshcontrol : UIRefreshControl!
    
    var arrayCompareProductIDs:[String] = []
    var arrayWatchlistProductIDs:[String] = []
    @IBOutlet weak var lblCompareCount: UILabel!
    @IBOutlet weak var viewCompareCount: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRefreshcontrol()
        // Do any additional setup after loading the view.
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
        offset = "0"
        wsCallGetWatchlistProducts(limit: "10")
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
    @objc private func refreshData(_ refreshcontrol: UIRefreshControl) {
        offset = "0"
        wsCallGetWatchlistProducts(limit: "10")
    }
    //MARK: Button Actions
    @IBAction func toggleReportPost(_ sender: UIButton) {
        if let info = Helper.getDatafromUserDefault("UserInformation"){
            let reportPostVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: ReportPostVC.self)) as! ReportPostVC
            reportPostVC.isSellerReport = false
            reportPostVC.product_id = self.arrWatchlistProducts[sender.tag].id ?? ""
            self.present(reportPostVC, animated: true, completion: nil)
        }
        else{
            self.showLoginAlertPopUp()
        }
        
    }
    @IBAction func toggleWatchlist(_ sender: UIButton) {
        if let info = Helper.getDatafromUserDefault("UserInformation"){
            arrayWatchlistProductIDs.removeElement(element:self.arrWatchlistProducts[sender.tag].id ?? "")
            wsCallRemoveProductFromWatchlist(product_id: self.arrWatchlistProducts[sender.tag].id ?? "")
            UserDefaults.standard.set(self.arrayWatchlistProductIDs, forKey: "arrayWatchlistProductIDs")
        }
        else{
            self.showLoginAlertPopUp()
        }
    }
    @IBAction func toggleCompare(_ sender: UIButton) {
        if arrayCompareProductIDs.contains(self.arrWatchlistProducts[sender.tag].id ?? ""){
            arrayCompareProductIDs.removeElement(element:self.arrWatchlistProducts[sender.tag].id ?? "")
        }
        else{
            arrayCompareProductIDs.append(self.arrWatchlistProducts[sender.tag].id ?? "")
        }
        UserDefaults.standard.set(self.arrayCompareProductIDs, forKey: "arrayCompareProductIDs")
        checkCompareProducts()
        self.tblView.reloadData()
    }
    @IBAction func toggleShare(_ sender: UIButton) {
        let product_id = arrWatchlistProducts[sender.tag].id ?? ""
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
extension ProductsVC:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrWatchlistProducts.count
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
        
        cell.imgProduct.sd_setImage(with:URL(string:arrWatchlistProducts[indexPath.row].category_image ?? ""), completed: { (image, error, SDImageCacheTypeDisk, url) in
        })
        cell.lblCategoryName.text = self.arrWatchlistProducts[indexPath.row].category_name ?? ""
        
        if (HomeVC.sharedInstance?.is_paid ?? "") == "2"{
            cell.lblCompanyName.text = self.arrWatchlistProducts[indexPath.row].company_name ?? ""
        }
        else{
            cell.lblCompanyName.text = self.starifyNumber(number:self.arrWatchlistProducts[indexPath.row].company_name ?? "")
        }
        
        let attributedStringSize = NSMutableAttributedString(string: "Size: ")
        let sizeAttrs = [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.black]
        let sizeNameFont = NSMutableAttributedString(string:self.arrWatchlistProducts[indexPath.row].tile_size_name ?? "", attributes: sizeAttrs)
        attributedStringSize.insert(sizeNameFont, at: 6)
        cell.lblSize.attributedText = attributedStringSize
        
        if (self.arrWatchlistProducts[indexPath.row].grade_name ?? "") == "Premium"{
            //green
            let attributedStringGrade = NSMutableAttributedString(string: "Grade: ")
            let gradeAttrs = [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor(hexString: "#00ae46")]
            let gradeNameFont = NSMutableAttributedString(string:self.arrWatchlistProducts[indexPath.row].grade_name ?? "", attributes: gradeAttrs)
            attributedStringGrade.insert(gradeNameFont, at: 7)
            cell.lblGrade.attributedText = attributedStringGrade
        }
        else if (self.arrWatchlistProducts[indexPath.row].grade_name ?? "") == "Standard" || (self.arrWatchlistProducts[indexPath.row].grade_name ?? "") == "Commercial" || (self.arrWatchlistProducts[indexPath.row].grade_name ?? "") == "Eco"{
            //blue
            let attributedStringGrade = NSMutableAttributedString(string: "Grade: ")
            let gradeAttrs = [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor(hexString: "#0065FF")]
            let gradeNameFont = NSMutableAttributedString(string:self.arrWatchlistProducts[indexPath.row].grade_name ?? "", attributes: gradeAttrs)
            attributedStringGrade.insert(gradeNameFont, at: 7)
            cell.lblGrade.attributedText = attributedStringGrade
        }
        else{
            //red
            let attributedStringGrade = NSMutableAttributedString(string: "Grade: ")
            let gradeAttrs = [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor(hexString: "#e50914")]
            let gradeNameFont = NSMutableAttributedString(string:self.arrWatchlistProducts[indexPath.row].grade_name ?? "", attributes: gradeAttrs)
            attributedStringGrade.insert(gradeNameFont, at: 7)
            cell.lblGrade.attributedText = attributedStringGrade
        }
        
        let priceTypeName = (self.arrWatchlistProducts[indexPath.row].price_type_name ?? "").replacingOccurrences(of: "per ", with: "").firstCapitalized
        cell.lblPriceAndType.text = "\(self.arrWatchlistProducts[indexPath.row].price ?? "")/\(priceTypeName)"
        cell.imgWatchlistIcon.image = UIImage(named: "icon_remove_watchlist")
        cell.lblWatchList.textColor = UIColor(hexString: "#c0252b")
        if arrayCompareProductIDs.contains(self.arrWatchlistProducts[indexPath.row].id ?? "")
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
        return 175
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productDetailsVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: ProductDetailsVC.self)) as! ProductDetailsVC
        productDetailsVC.product_id = self.arrWatchlistProducts[indexPath.row].id ?? ""
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
                    wsCallGetWatchlistProducts(limit: "10")
                }
            }
        }
    }
}
extension ProductsVC{
    private func wsCallGetWatchlistProducts(limit:String){
        if !refreshcontrol.isRefreshing{
            self.showSpinner()
        }
        WSCalls.sharedInstance.apiCallWithHeader(url:WSRequest.getWatchlistProducts, method: .post, param: ["limit":limit,"offset":self.offset], headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            print(response)
            self.hideSpinner()
            self.refreshcontrol.endRefreshing()
            if self.offset == "0"{
                self.arrWatchlistProducts.removeAll()
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
                        self.arrWatchlistProducts.append(obj)
                    }
                }
            }
            if self.arrWatchlistProducts.count > 0{
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
    func wsCallRemoveProductFromWatchlist(product_id:String){
        let param = ["product_id":product_id]
        WSCalls.sharedInstance.apiCallWithHeader(url: WSRequest.removeProductFromWatchlist, method: .post, param:param, headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            print(response)
            self.offset = "0"
            self.wsCallGetWatchlistProducts(limit: "10")
            
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
