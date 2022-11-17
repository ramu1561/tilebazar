//
//  SellersVC.swift
//  Tile Bazar
//
//  Created by Apple on 8/14/22.
//

import UIKit
import FirebaseDynamicLinks

class SellersVC: ParentVC {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewNoData: UIView!
    var offset = "0"
    var arrDirectoryWatchlist:[GetDirectoryListDataModel] = []
    var refreshcontrol : UIRefreshControl!
    var arrayWatchlistSellerIDs:[String] = []
    
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
        arrayWatchlistSellerIDs = UserDefaults.standard.stringArray(forKey: "arrayWatchlistSellerIDs") ?? [String]()
        offset = "0"
        wsCallGetDirectoryWatchlist(limit: "10")
    }
    @objc private func refreshData(_ refreshcontrol: UIRefreshControl) {
        offset = "0"
        wsCallGetDirectoryWatchlist(limit: "10")
    }
    @IBAction func toggleReportPost(_ sender: UIButton) {
        let reportPostVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: ReportPostVC.self)) as! ReportPostVC
        reportPostVC.isSellerReport = true
        reportPostVC.user_id = self.arrDirectoryWatchlist[sender.tag].id ?? ""
        self.present(reportPostVC, animated: true, completion: nil)
    }
    @IBAction func toggleWatchlist(_ sender: UIButton) {
        arrayWatchlistSellerIDs.removeElement(element:self.arrDirectoryWatchlist[sender.tag].id ?? "")
        wsCallRemoveDirectoryFromWatchlist(user_id: self.arrDirectoryWatchlist[sender.tag].id ?? "")
        UserDefaults.standard.set(self.arrayWatchlistSellerIDs, forKey: "arrayWatchlistSellerIDs")
    }
    @IBAction func toggleShare(_ sender: UIButton) {
        let seller_id = arrDirectoryWatchlist[sender.tag].id ?? ""
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
extension SellersVC:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDirectoryWatchlist.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellDirectoryItems") as! CellDirectoryItems
        cell.btnReport.tag = indexPath.row
        cell.btnWatchlist.tag = indexPath.row
        cell.btnShare.tag = indexPath.row
        cell.lblCompanyName.font = UIFont(name: "Biennale-SemiBold", size: 16)
        cell.imgUser.sd_setImage(with:URL(string:arrDirectoryWatchlist[indexPath.row].image ?? ""), completed: { (image, error, SDImageCacheTypeDisk, url) in
        })
        if (HomeVC.sharedInstance?.is_paid ?? "") == "2"{
            cell.lblCompanyName.text = self.arrDirectoryWatchlist[indexPath.row].company_name ?? ""
        }
        else{
            cell.lblCompanyName.text = self.starifyNumber(number:self.arrDirectoryWatchlist[indexPath.row].company_name ?? "")
        }
        cell.lblCityState.text = "\(self.arrDirectoryWatchlist[indexPath.row].city ?? ""), \(self.arrDirectoryWatchlist[indexPath.row].state_name ?? "")"
        cell.lblDate.text = self.arrDirectoryWatchlist[indexPath.row].created_at ?? ""
        cell.lblProductsCount.text = "\(self.arrDirectoryWatchlist[indexPath.row].total_products ?? "") Products"
        cell.imgWatchlistIcon.image = UIImage(named: "icon_remove_watchlist")
        cell.lblWatchList.textColor = UIColor(hexString: "#c0252b")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sellerDetailsVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: SellerDetailsVC.self)) as! SellerDetailsVC
        sellerDetailsVC.user_id = self.arrDirectoryWatchlist[indexPath.row].id ?? ""
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
                    wsCallGetDirectoryWatchlist(limit: "10")
                }
            }
        }
    }
}
extension SellersVC{
    private func wsCallGetDirectoryWatchlist(limit:String){
        if !refreshcontrol.isRefreshing{
            self.showSpinner()
        }
        WSCalls.sharedInstance.apiCallWithHeader(url:WSRequest.getWatchlistDirectory, method: .post, param: ["limit":limit,"offset":self.offset], headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            print(response)
            self.hideSpinner()
            self.refreshcontrol.endRefreshing()
            if self.offset == "0"{
                self.arrDirectoryWatchlist.removeAll()
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
                        self.arrDirectoryWatchlist.append(obj)
                    }
                }
            }
            if self.arrDirectoryWatchlist.count > 0{
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
    func wsCallRemoveDirectoryFromWatchlist(user_id:String){
        let param = ["user_id":user_id]
        WSCalls.sharedInstance.apiCallWithHeader(url: WSRequest.removeDirectoryFromWatchlist, method: .post, param:param, headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            print(response)
            self.offset = "0"
            self.wsCallGetDirectoryWatchlist(limit: "10")
            
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
