//
//  DirectoryVC.swift
//  Tile Bazar
//
//  Created by Apple on 8/14/22.
//

import UIKit
import FirebaseDynamicLinks

class CellDirectoryItems:UITableViewCell{
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblCityState: UILabel!
    @IBOutlet weak var lblProductsCount: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgReport: UIImageView!
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var imgWatchlistIcon: UIImageView!
    @IBOutlet weak var lblWatchList: UILabel!
    @IBOutlet weak var btnWatchlist: UIButton!
    @IBOutlet weak var imgShare: UIImageView!
    @IBOutlet weak var btnShare: UIButton!
}
//MARK:- GetDirectoryListDataModel
class GetDirectoryListDataModel {
    var id : String?
    var name : String?
    var phone_number : String?
    var company_name : String?
    var image : String?
    var lu_state_id : String?
    var city : String?
    var total_products : String?
    var address : String?
    var created_at : String?
    var state_name : String?
    var is_favourite : String?
    
    init(dictinfo : [String : Any]) {
        if let item = dictinfo["id"]{
            if item is String{
                id = item as? String
            }
            else if item is Int{
                id = String(item as! Int)
            }
        }
        if let item = dictinfo["lu_state_id"]{
            if item is String{
                lu_state_id = item as? String
            }
            else if item is Int{
                lu_state_id = String(item as! Int)
            }
        }
        if let item = dictinfo["total_products"]{
            if item is String{
                total_products = item as? String
            }
            else if item is Int{
                total_products = String(item as! Int)
            }
            else if item is Double{
                total_products = String(item as! Double)
            }
        }
        
        if let item = dictinfo["city"]{
            if item is String{
                city = item as? String
            }
            else if item is Int{
                city = String(item as! Int)
            }
        }
        if let item = dictinfo["company_name"]{
            if item is String{
                company_name = item as? String
            }
            else if item is Int{
                company_name = String(item as! Int)
            }
        }
        if let item = dictinfo["state_name"]{
            if item is String{
                state_name = item as? String
            }
            else if item is Int{
                state_name = String(item as! Int)
            }
        }
        if let item = dictinfo["created_at"]{
            if item is String{
                created_at = item as? String
            }
            else if item is Int{
                created_at = String(item as! Int)
            }
        }
        name = dictinfo["name"] as? String ?? ""
        if let item = dictinfo["phone_number"]{
            if item is String{
                phone_number = item as? String
            }
            else if item is Int{
                phone_number = String(item as! Int)
            }
        }
        address = dictinfo["address"] as? String ?? ""
        image = dictinfo["image"] as? String ?? ""
        if let item = dictinfo["is_favourite"]{
            if item is String{
                is_favourite = item as? String
            }
            else if item is Int{
                is_favourite = String(item as! Int)
            }
        }
    }
}
class DirectoryVC: ParentVC {

    @IBOutlet weak var tblView: UITableView!
    var offset = "0"
    var arrDirectory:[GetDirectoryListDataModel] = []
    var refreshcontrol : UIRefreshControl!
    var sort_by = "0"
    var arrSellerIDs:[String] = []
    var arrayWatchlistSellerIDs:[String] = []
    @IBOutlet weak var viewNoData: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRefreshcontrol()
        offset = "0"
        arrSellerIDs.removeAll()
        wsCallGetDirectory(limit: "10")
        // Do any additional setup after loading the view.
    }
    func addRefreshcontrol(){
        refreshcontrol = UIRefreshControl()
        // Configure Refresh Control
        refreshcontrol.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tblView.addSubview(refreshcontrol)
    }
    override func viewWillAppear(_ animated: Bool) {
        arrayWatchlistSellerIDs = UserDefaults.standard.stringArray(forKey: "arrayWatchlistSellerIDs") ?? [String]()
        self.tblView.reloadData()
    }
    @objc private func refreshData(_ refreshcontrol: UIRefreshControl) {
        self.sort_by = "0"
        offset = "0"
        arrSellerIDs.removeAll()
        wsCallGetDirectory(limit: "10")
    }
    @IBAction func toggleButtons(_ sender: UIButton) {
        let alert = UIAlertController(title:"Sort By", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title:"Name A to Z", style: .default, handler:{ _ in
            if self.sort_by != "1"{
                self.sort_by = "1"
                self.offset = "0"
                self.arrSellerIDs.removeAll()
                self.wsCallGetDirectory(limit: "10")
            }
        }))
        alert.addAction(UIAlertAction(title:"Name Z to A", style: .default, handler:{ _ in
            if self.sort_by != "2"{
                self.sort_by = "2"
                self.offset = "0"
                self.arrSellerIDs.removeAll()
                self.wsCallGetDirectory(limit: "10")
            }
        }))
        alert.addAction(UIAlertAction(title:"Date Modified", style: .default, handler:{ _ in
            if self.sort_by != "3"{
                self.sort_by = "3"
                self.offset = "0"
                self.arrSellerIDs.removeAll()
                self.wsCallGetDirectory(limit: "10")
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
    @IBAction func toggleReportPost(_ sender: UIButton) {
        if let info = Helper.getDatafromUserDefault("UserInformation"){
            let reportPostVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: ReportPostVC.self)) as! ReportPostVC
            reportPostVC.isSellerReport = true
            reportPostVC.user_id = self.arrDirectory[sender.tag].id ?? ""
            self.present(reportPostVC, animated: true, completion: nil)
        }
        else{
            self.showLoginAlertPopUp()
        }
    }
    @IBAction func toggleWatchlist(_ sender: UIButton) {
        if let info = Helper.getDatafromUserDefault("UserInformation"){
            if (self.arrDirectory[sender.tag].is_favourite ?? "") == "1" || arrayWatchlistSellerIDs.contains(self.arrDirectory[sender.tag].id ?? ""){
                arrayWatchlistSellerIDs.removeElement(element:self.arrDirectory[sender.tag].id ?? "")
                wsCallRemoveDirectoryFromWatchlist(user_id: self.arrDirectory[sender.tag].id ?? "")
            }
            else{
                arrayWatchlistSellerIDs.append(self.arrDirectory[sender.tag].id ?? "")
                self.wsCallAddDirectoryToWatchlist(user_id: self.arrDirectory[sender.tag].id ?? "")
            }
            UserDefaults.standard.set(self.arrayWatchlistSellerIDs, forKey: "arrayWatchlistSellerIDs")
            self.tblView.reloadData()
        }
        else{
            self.showLoginAlertPopUp()
        }
    }
    @IBAction func toggleShare(_ sender: UIButton) {
        let seller_id = arrDirectory[sender.tag].id ?? ""
        guard let link = URL(string:"https://tilesbazar.page.link/sellerdetails/\(seller_id)") else { return }
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
extension DirectoryVC:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDirectory.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellDirectoryItems") as! CellDirectoryItems
        cell.btnReport.tag = indexPath.row
        cell.btnWatchlist.tag = indexPath.row
        cell.btnShare.tag = indexPath.row
        cell.lblCompanyName.font = UIFont(name: "Biennale-SemiBold", size: 16)
        cell.imgUser.sd_setImage(with:URL(string:arrDirectory[indexPath.row].image ?? ""), completed: { (image, error, SDImageCacheTypeDisk, url) in
        })
        
        if (HomeVC.sharedInstance?.is_paid ?? "") == "2"{
            cell.lblCompanyName.text = self.arrDirectory[indexPath.row].company_name ?? ""
        }
        else{
            cell.lblCompanyName.text = self.starifyNumber(number:self.arrDirectory[indexPath.row].company_name ?? "")
        }
        
        cell.lblCityState.text = "\(self.arrDirectory[indexPath.row].city ?? ""), \(self.arrDirectory[indexPath.row].state_name ?? "")"
        cell.lblDate.text = self.arrDirectory[indexPath.row].created_at ?? ""
        cell.lblProductsCount.text = "\(self.arrDirectory[indexPath.row].total_products ?? "") Products"
        
        if (self.arrDirectory[indexPath.row].is_favourite ?? "") == "1" || arrayWatchlistSellerIDs.contains(self.arrDirectory[indexPath.row].id ?? ""){
            cell.imgWatchlistIcon.image = UIImage(named: "icon_remove_watchlist")
            cell.lblWatchList.textColor = UIColor(hexString: "#c0252b")
        }
        else{
            cell.imgWatchlistIcon.image = UIImage(named: "icon_add_watchlist")
            cell.lblWatchList.textColor = UIColor.darkGray
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sellerDetailsVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: SellerDetailsVC.self)) as! SellerDetailsVC
        sellerDetailsVC.user_id = self.arrDirectory[indexPath.row].id ?? ""
        self.navigationController?.pushViewController(sellerDetailsVC, animated: true)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        if scrollView == tblView{
            // UITableView only moves in one direction, y axis
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            // Change 10.0 to adjust the distance from bottom
            if maximumOffset - currentOffset <= 10.0 {
                if self.offset != "0"{
                    wsCallGetDirectory(limit: "10")
                }
            }
        }
    }
}
extension DirectoryVC{
    private func wsCallGetDirectory(limit:String){
        if !refreshcontrol.isRefreshing{
            self.showSpinner()
        }
        let seller_ids = self.arrSellerIDs.joined(separator: ",")
        WSCalls.sharedInstance.apiCallWithHeader(url:WSRequest.getDirectory, method: .post, param: ["limit":limit,"sort":self.sort_by,"offset":self.offset,"seller_ids":seller_ids], headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            print(response)
            self.hideSpinner()
            self.refreshcontrol.endRefreshing()
            if self.offset == "0"{
                self.arrDirectory.removeAll()
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
                        let obj = GetDirectoryListDataModel(dictinfo: obj)
                        self.arrDirectory.append(obj)
                    }
                }
            }
            if self.arrDirectory.count > 0{
                self.viewNoData.isHidden = true
                for i in 0..<self.arrDirectory.count{
                    self.arrSellerIDs.append(self.arrDirectory[i].id ?? "")
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
}
