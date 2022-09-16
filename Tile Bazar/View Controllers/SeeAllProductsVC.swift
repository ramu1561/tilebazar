//
//  SeeAllProductsVC.swift
//  Tile Bazar
//
//  Created by Apple on 8/13/22.
//

import UIKit

class SeeAllProductsVC: ParentVC {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    var titleName = ""
    var isComingFrom = ""
    @IBOutlet weak var viewSellBtn: UIView!
    var arrSeeAllProducts:[GetDashboardProductsDataModel] = []
    var refreshcontrol : UIRefreshControl!
    @IBOutlet weak var viewNoData: UIView!
    var offset = "0"
    var category_id = ""
    var sq_ft_price = ""
    
    var arrayCompareProductIDs:[String] = []
    @IBOutlet weak var lblCompareCount: UILabel!
    @IBOutlet weak var viewCompareCount: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = titleName
        addRefreshcontrol()
        if isComingFrom == "myProducts"{
            offset = "0"
            self.wsCallGetUserProducts(limit: "10", user_id: userInfo?.id ?? "")
        }
        else if isComingFrom == "categories"{
            offset = "0"
            self.wsCallGetCategoryProducts(limit: "10", category_id: self.category_id, sq_ft_price: self.sq_ft_price)
        }
        else{
            setupAPICalls()
        }
        // Do any additional setup after loading the view.
    }
    func addRefreshcontrol(){
        refreshcontrol = UIRefreshControl()
        // Configure Refresh Control
        refreshcontrol.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tblView.addSubview(refreshcontrol)
    }
    func setupAPICalls(){
        if isComingFrom == "featured_products"{
            wsCallGetAllProducts(url: WSRequest.featuredProducts)
        }
        else if isComingFrom == "recently_added"{
            wsCallGetAllProducts(url: WSRequest.recentlyAddedProducts)
        }
        else{
            wsCallGetAllProducts(url: WSRequest.firstChoiceProducts)
        }
    }
    @objc private func refreshData(_ refreshcontrol: UIRefreshControl) {
        if isComingFrom == "myProducts"{
            offset = "0"
            self.wsCallGetUserProducts(limit: "10", user_id: userInfo?.id ?? "")
        }
        else if isComingFrom == "categories"{
            offset = "0"
            self.wsCallGetCategoryProducts(limit: "10", category_id: self.category_id, sq_ft_price: self.sq_ft_price)
        }
        else{
            setupAPICalls()
        }
    }
    @IBAction func toggleBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        arrayCompareProductIDs = UserDefaults.standard.stringArray(forKey: "arrayCompareProductIDs") ?? [String]()
        checkCompareProducts()
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
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
    //MARK: Button Actions
    @IBAction func toggleReportPost(_ sender: UIButton) {
        let reportPostVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: ReportPostVC.self)) as! ReportPostVC
        reportPostVC.isSellerReport = false
        reportPostVC.product_id = self.arrSeeAllProducts[sender.tag].id ?? ""
        self.present(reportPostVC, animated: true, completion: nil)
    }
    @IBAction func toggleWatchlist(_ sender: UIButton) {
        if (self.arrSeeAllProducts[sender.tag].is_favourite ?? "") == "1"{
            wsCallRemoveProductFromWatchlist(product_id: self.arrSeeAllProducts[sender.tag].id ?? "")
        }
        else{
            self.wsCallAddProductToWatchlist(product_id: self.arrSeeAllProducts[sender.tag].id ?? "")
        }
    }
    @IBAction func toggleCompare(_ sender: UIButton) {
        if arrayCompareProductIDs.contains(self.arrSeeAllProducts[sender.tag].id ?? ""){
            arrayCompareProductIDs.removeElement(element:self.arrSeeAllProducts[sender.tag].id ?? "")
        }
        else{
            arrayCompareProductIDs.append(self.arrSeeAllProducts[sender.tag].id ?? "")
        }
        UserDefaults.standard.set(self.arrayCompareProductIDs, forKey: "arrayCompareProductIDs")
        checkCompareProducts()
        self.tblView.reloadData()
    }
    @IBAction func toggleShare(_ sender: UIButton) {
    }
}
extension SeeAllProductsVC:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSeeAllProducts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellHomeProducts") as! CellHomeProducts
        cell.btnReport.tag = indexPath.row
        cell.btnWatchlist.tag = indexPath.row
        cell.btnCompare.tag = indexPath.row
        cell.btnShare.tag = indexPath.row
        
        cell.imgProduct.sd_setImage(with:URL(string:arrSeeAllProducts[indexPath.row].category_image ?? ""), completed: { (image, error, SDImageCacheTypeDisk, url) in
        })
        cell.lblCategoryName.text = self.arrSeeAllProducts[indexPath.row].category_name ?? ""
        
        if (HomeVC.sharedInstance?.is_paid ?? "") == "2"{
            cell.lblCompanyName.text = self.arrSeeAllProducts[indexPath.row].company_name ?? ""
        }
        else{
            cell.lblCompanyName.text = self.starifyNumber(number:self.arrSeeAllProducts[indexPath.row].company_name ?? "")
        }
        
        let attributedStringSize = NSMutableAttributedString(string: "Size: ")
        let sizeAttrs = [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.black]
        let sizeNameFont = NSMutableAttributedString(string:self.arrSeeAllProducts[indexPath.row].tile_size_name ?? "", attributes: sizeAttrs)
        attributedStringSize.insert(sizeNameFont, at: 6)
        cell.lblSize.attributedText = attributedStringSize
        
        if (self.arrSeeAllProducts[indexPath.row].grade_name ?? "") == "Premium"{
            //green
            let attributedStringGrade = NSMutableAttributedString(string: "Grade: ")
            let gradeAttrs = [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor(hexString: "#00ae46")]
            let gradeNameFont = NSMutableAttributedString(string:self.arrSeeAllProducts[indexPath.row].grade_name ?? "", attributes: gradeAttrs)
            attributedStringGrade.insert(gradeNameFont, at: 7)
            cell.lblGrade.attributedText = attributedStringGrade
        }
        else if (self.arrSeeAllProducts[indexPath.row].grade_name ?? "") == "Standard" || (self.arrSeeAllProducts[indexPath.row].grade_name ?? "") == "Commercial" || (self.arrSeeAllProducts[indexPath.row].grade_name ?? "") == "Eco"{
            //blue
            let attributedStringGrade = NSMutableAttributedString(string: "Grade: ")
            let gradeAttrs = [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor(hexString: "#0065FF")]
            let gradeNameFont = NSMutableAttributedString(string:self.arrSeeAllProducts[indexPath.row].grade_name ?? "", attributes: gradeAttrs)
            attributedStringGrade.insert(gradeNameFont, at: 7)
            cell.lblGrade.attributedText = attributedStringGrade
        }
        else{
            //red
            let attributedStringGrade = NSMutableAttributedString(string: "Grade: ")
            let gradeAttrs = [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor(hexString: "#e50914")]
            let gradeNameFont = NSMutableAttributedString(string:self.arrSeeAllProducts[indexPath.row].grade_name ?? "", attributes: gradeAttrs)
            attributedStringGrade.insert(gradeNameFont, at: 7)
            cell.lblGrade.attributedText = attributedStringGrade
        }
        
        let priceTypeName = (self.arrSeeAllProducts[indexPath.row].price_type_name ?? "").replacingOccurrences(of: "per ", with: "").firstCapitalized
        cell.lblPriceAndType.text = "\(self.arrSeeAllProducts[indexPath.row].price ?? "")/\(priceTypeName)"
        if (self.arrSeeAllProducts[indexPath.row].is_favourite ?? "") == "1"{
            cell.imgWatchlistIcon.image = UIImage(named: "icon_remove_watchlist")
            cell.lblWatchList.textColor = UIColor(hexString: "#c0252b")
        }
        else{
            cell.imgWatchlistIcon.image = UIImage(named: "icon_add_watchlist")
            cell.lblWatchList.textColor = UIColor.darkGray
        }
        if arrayCompareProductIDs.contains(self.arrSeeAllProducts[indexPath.row].id ?? "")
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
        productDetailsVC.product_id = self.arrSeeAllProducts[indexPath.row].id ?? ""
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
                    if isComingFrom == "myProducts"{
                        wsCallGetUserProducts(limit: "10", user_id: userInfo?.id ?? "")
                    }
                    else if isComingFrom == "categories"{
                        wsCallGetCategoryProducts(limit: "10", category_id: self.category_id, sq_ft_price:self.sq_ft_price)
                    }
                }
            }
        }
    }
}
extension SeeAllProductsVC{
    private func wsCallGetAllProducts(url:String){
        if !refreshcontrol.isRefreshing{
            self.showSpinner()
        }
        WSCalls.sharedInstance.apiCallWithHeader(url:url, method: .get, param: [:], headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            print(response)
            self.hideSpinner()
            self.refreshcontrol.endRefreshing()
            self.arrSeeAllProducts.removeAll()
            let arrData = response["Data"] as? [[String:Any]] ?? []
            if arrData.count > 0{
                for obj in arrData{
                    let obj = GetDashboardProductsDataModel(dictinfo: obj)
                    self.arrSeeAllProducts.append(obj)
                }
            }
            
            if self.arrSeeAllProducts.count > 0{
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
        self.showSpinner()
        let param = ["product_id":product_id]
        WSCalls.sharedInstance.apiCallWithHeader(url: WSRequest.addProductToWatchlist, method: .post, param:param, headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            self.hideSpinner()
            print(response)
            if self.isComingFrom == "myProducts"{
                self.offset = "0"
                self.wsCallGetUserProducts(limit: "10", user_id: userInfo?.id ?? "")
            }
            else if self.isComingFrom == "categories"{
                self.offset = "0"
                self.wsCallGetCategoryProducts(limit: "10", category_id: self.category_id, sq_ft_price: self.sq_ft_price)
            }
            else{
                self.setupAPICalls()
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
    func wsCallRemoveProductFromWatchlist(product_id:String){
        self.showSpinner()
        let param = ["product_id":product_id]
        WSCalls.sharedInstance.apiCallWithHeader(url: WSRequest.removeProductFromWatchlist, method: .post, param:param, headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            self.hideSpinner()
            print(response)
            if self.isComingFrom == "myProducts"{
                self.offset = "0"
                self.wsCallGetUserProducts(limit: "10", user_id: userInfo?.id ?? "")
            }
            else if self.isComingFrom == "categories"{
                self.offset = "0"
                self.wsCallGetCategoryProducts(limit: "10", category_id: self.category_id, sq_ft_price: self.sq_ft_price)
            }
            else{
                self.setupAPICalls()
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
                self.arrSeeAllProducts.removeAll()
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
                        self.arrSeeAllProducts.append(obj)
                    }
                }
            }
            if self.arrSeeAllProducts.count > 0{
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
    private func wsCallGetCategoryProducts(limit:String,category_id:String,sq_ft_price:String){
        if !refreshcontrol.isRefreshing{
            self.showSpinner()
        }
        let params = ["limit":limit,
                      "offset":self.offset,
                      "category_id":self.category_id,
                      "sq_ft_price":self.sq_ft_price]
        
        WSCalls.sharedInstance.apiCallWithHeader(url:WSRequest.categoryProducts, method: .post, param: params, headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            print(response)
            self.hideSpinner()
            self.refreshcontrol.endRefreshing()
            if self.offset == "0"{
                self.arrSeeAllProducts.removeAll()
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
                        self.arrSeeAllProducts.append(obj)
                    }
                }
            }
            if self.arrSeeAllProducts.count > 0{
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
}
