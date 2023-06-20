//
//  HomeVC.swift
//  Tile Bazar
//
//  Created by Apple on 8/13/22.
//

import UIKit
import FirebaseDynamicLinks
import Siren

class CellHomeProductsHeader:UITableViewCell{
    @IBOutlet weak var lblTitle: UILabel!
}
class CellHomeProducts:UITableViewCell{
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblGrade: UILabel!
    @IBOutlet weak var lblPriceAndType: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblReportTitle: UILabel!
    @IBOutlet weak var imgReport: UIImageView!
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var imgWatchlistIcon: UIImageView!
    @IBOutlet weak var lblWatchList: UILabel!
    @IBOutlet weak var btnWatchlist: UIButton!
    @IBOutlet weak var imgCompare: UIImageView!
    @IBOutlet weak var lblCompare: UILabel!
    @IBOutlet weak var btnCompare: UIButton!
    @IBOutlet weak var imgShare: UIImageView!
    @IBOutlet weak var btnShare: UIButton!
    
    //My products extra elements
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
}
class CellHomeProductsFooter:UITableViewCell{
    @IBOutlet weak var btnSeeAll: UIButton!
}
class CollectionCellHomeBanners:UICollectionViewCell{
    @IBOutlet weak var imgView: UIImageView!
}
//MARK:- NewSlidersDataModel
class NewSlidersDataModel{
    var file_name : String?
    var product_id : String?
    var seller_id : String?
    
    init(dictinfo : [String : Any]) {
        file_name = dictinfo["file_name"] as? String ?? ""
        if let item = dictinfo["product_id"]{
            if item is String{
                product_id = item as? String
            }
            else if item is Int{
                product_id = String(item as! Int)
            }
        }
        if let item = dictinfo["seller_id"]{
            if item is String{
                seller_id = item as? String
            }
            else if item is Int{
                seller_id = String(item as! Int)
            }
        }
    }
}
//MARK:- GetDashboardProductsDataModel
class GetDashboardProductsDataModel {
    var id : String?
    var user_id : String?
    var category_id : String?
    var grade_id : String?
    var tile_size_id : String?
    var price_category_id : String?
    var price_type_id : String?
    var city : String?
    var company_name : String?
    var state_name : String?
    var created_at : String?
    var category_name : String?
    var category_image : String?
    var name : String?
    var email : String?
    var phone_number : String?
    var address : String?
    var image : String?
    var grade_name : String?
    var tile_size_name : String?
    var price_category_name : String?
    var price_type_name : String?
    var quantity : String?
    var payment_terms : String?
    var price : String?
    var thickness : String?
    var weight : String?
    var coverage : String?
    var note : String?
    var deleted_at : String?
    var rejection_note : String?
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
        if let item = dictinfo["user_id"]{
            if item is String{
                user_id = item as? String
            }
            else if item is Int{
                user_id = String(item as! Int)
            }
        }
        if let item = dictinfo["category_id"]{
            if item is String{
                category_id = item as? String
            }
            else if item is Int{
                category_id = String(item as! Int)
            }
        }
        if let item = dictinfo["grade_id"]{
            if item is String{
                grade_id = item as? String
            }
            else if item is Int{
                grade_id = String(item as! Int)
            }
        }
        if let item = dictinfo["tile_size_id"]{
            if item is String{
                tile_size_id = item as? String
            }
            else if item is Int{
                tile_size_id = String(item as! Int)
            }
        }
        if let item = dictinfo["price_category_id"]{
            if item is String{
                price_category_id = item as? String
            }
            else if item is Int{
                price_category_id = String(item as! Int)
            }
        }
        if let item = dictinfo["price_type_id"]{
            if item is String{
                price_type_id = item as? String
            }
            else if item is Int{
                price_type_id = String(item as! Int)
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
        if let item = dictinfo["category_name"]{
            if item is String{
                category_name = item as? String
            }
            else if item is Int{
                category_name = String(item as! Int)
            }
        }
        category_image = dictinfo["category_image"] as? String ?? ""
        name = dictinfo["name"] as? String ?? ""
        email = dictinfo["email"] as? String ?? ""
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
        if let item = dictinfo["grade_name"]{
            if item is String{
                grade_name = item as? String
            }
            else if item is Int{
                grade_name = String(item as! Int)
            }
        }
        if let item = dictinfo["tile_size_name"]{
            if item is String{
                tile_size_name = item as? String
            }
            else if item is Int{
                tile_size_name = String(item as! Int)
            }
        }
        if let item = dictinfo["price_category_name"]{
            if item is String{
                price_category_name = item as? String
            }
            else if item is Int{
                price_category_name = String(item as! Int)
            }
        }
        if let item = dictinfo["price_type_name"]{
            if item is String{
                price_type_name = item as? String
            }
            else if item is Int{
                price_type_name = String(item as! Int)
            }
        }
        if let item = dictinfo["quantity"]{
            if item is String{
                quantity = item as? String
            }
            else if item is Int{
                quantity = String(item as! Int)
            }
            else if item is Double{
                quantity = String(item as! Double)
            }
        }
        if let item = dictinfo["payment_terms"]{
            if item is String{
                payment_terms = item as? String
            }
            else if item is Int{
                payment_terms = String(item as! Int)
            }
        }
        if let item = dictinfo["price"]{
            if item is String{
                price = item as? String
            }
            else if item is Int{
                price = String(item as! Int)
            }
            else if item is Double{
                price = String(item as! Double)
            }
        }
        if let item = dictinfo["thickness"]{
            if item is String{
                thickness = item as? String
            }
            else if item is Int{
                thickness = String(item as! Int)
            }
            else if item is Double{
                thickness = String(item as! Double)
            }
        }
        if let item = dictinfo["weight"]{
            if item is String{
                weight = item as? String
            }
            else if item is Int{
                weight = String(item as! Int)
            }
            else if item is Double{
                weight = String(item as! Double)
            }
        }
        if let item = dictinfo["coverage"]{
            if item is String{
                coverage = item as? String
            }
            else if item is Int{
                coverage = String(item as! Int)
            }
            else if item is Double{
                coverage = String(item as! Double)
            }
        }
        if let item = dictinfo["note"]{
            if item is String{
                note = item as? String
            }
            else if item is Int{
                note = String(item as! Int)
            }
        }
        if let item = dictinfo["deleted_at"]{
            if item is String{
                deleted_at = item as? String
            }
            else if item is Int{
                deleted_at = String(item as! Int)
            }
        }
        if let item = dictinfo["rejection_note"]{
            if item is String{
                rejection_note = item as? String
            }
            else if item is Int{
                rejection_note = String(item as! Int)
            }
        }
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
class HomeVC: ParentVC {

    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var lblHomeTitle: UILabel!
    @IBOutlet weak var lblSeparator: UILabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet var CellData: UITableViewCell!
    @IBOutlet weak var viewCollectionBannerContainer: UIView!
    @IBOutlet weak var viewCollectionBannerContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewBanner: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var tblViewProducts: UITableView!
    @IBOutlet weak var tblViewProductsHeight: NSLayoutConstraint!
    var countOfLogoutErrorMsgs : Int = 0
    //var arrSliders:[String] = []
    var is_paid = ""
    var view_count = ""
    var total_view_count = ""
    var free_product = ""
    var total_free_product = ""
    static var sharedInstance:HomeVC?
    var arrFeaturedProducts:[GetDashboardProductsDataModel] = []
    var arrRecentlyAddedProducts:[GetDashboardProductsDataModel] = []
    var arrFirstChoiceProducts:[GetDashboardProductsDataModel] = []
    var arrNewSliders:[NewSlidersDataModel] = []
    var refreshcontrol : UIRefreshControl!
    var plan_id = ""
    var plan_days = ""
    var payment_plan_name = ""
    var plan_end_date = ""
    var arrayCompareProductIDs:[String] = []
    var arrayWatchlistProductIDs:[String] = []
    @IBOutlet weak var lblCompareCount: UILabel!
    @IBOutlet weak var viewCompareCount: UIView!
    @IBOutlet weak var viewNoData: UIView!
    var timer : Timer?
    var pageIndex : Int = 0
    var support_number = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewBanner.delegate = self
        collectionViewBanner.dataSource = self
        tblViewProducts.delegate = self
        tblViewProducts.dataSource = self
        HomeVC.sharedInstance = self
        addRefreshcontrol()
        wsCallDashboard()
        // Do any additional setup after loading the view.
    }
    func addRefreshcontrol(){
        refreshcontrol = UIRefreshControl()
        // Configure Refresh Control
        refreshcontrol.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tblView.addSubview(refreshcontrol)
    }
    @objc private func refreshData(_ refreshcontrol: UIRefreshControl) {
        wsCallDashboard()
    }
    @IBAction func toggleSeeAll(_ sender: UIButton) {
        let seeAllProductsVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: SeeAllProductsVC.self)) as! SeeAllProductsVC
        if sender.tag == 0{
            seeAllProductsVC.titleName = "Featured Products"
            seeAllProductsVC.isComingFrom = "featured_products"
        }
        else if sender.tag == 1{
            seeAllProductsVC.titleName = "Recently Added Products"
            seeAllProductsVC.isComingFrom = "recently_added"
        }
        else{
            seeAllProductsVC.titleName = "First Choice Products"
            seeAllProductsVC.isComingFrom = "first_choice"
        }
        self.navigationController?.pushViewController(seeAllProductsVC, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        Siren.shared.checkVersion(checkType: .immediately)
        Siren.shared.alertType = .force
        arrayCompareProductIDs = UserDefaults.standard.stringArray(forKey: "arrayCompareProductIDs") ?? [String]()
        checkCompareProducts()
        arrayWatchlistProductIDs = UserDefaults.standard.stringArray(forKey: "arrayWatchlistProductIDs") ?? [String]()
        self.tblViewProducts.reloadData()
        
        collectionViewBanner.scrollRectToVisible(CGRect(x: 0, y: collectionViewBanner.contentOffset.y, width: self.collectionViewBanner.frame.size.width, height:self.collectionViewBanner.frame.size.height), animated: true)
        self.pageIndex = 0
        self.pageControl.currentPage = 0
        startTimer()
    }
    override func viewWillDisappear(_ animated: Bool) {
        stopTimer()
    }
    //MARK: Button Actions
    @IBAction func toggleHomeButtons(_ sender: UIButton) {
        if sender.tag == 0{
            //category
            let categoriesVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: CategoriesVC.self)) as! CategoriesVC
            self.navigationController?.pushViewController(categoriesVC, animated: true)
        }
        else if sender.tag == 1{
            //buy
            tabBarController?.selectedIndex = 1
        }
        else if sender.tag == 2{
            //sell
            self.showAddProductScreen()
        }
        else{
            //compare
        }
    }
    @IBAction func toggleReportPost(_ sender: UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblViewProducts)
        let indexPath = self.tblViewProducts.indexPathForRow(at:buttonPosition)
        print("section:\(indexPath?.section ?? 0) row:\(indexPath?.row ?? 0)")
        
        let reportPostVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: ReportPostVC.self)) as! ReportPostVC
        reportPostVC.isSellerReport = false
        if (indexPath?.section ?? 0) == 0{
            reportPostVC.product_id = self.arrFeaturedProducts[indexPath?.row ?? 0].id ?? ""
        }
        else if (indexPath?.section ?? 0) == 1{
            reportPostVC.product_id = self.arrRecentlyAddedProducts[indexPath?.row ?? 0].id ?? ""
        }
        else{
            reportPostVC.product_id = self.arrFirstChoiceProducts[indexPath?.row ?? 0].id ?? ""
        }
        self.present(reportPostVC, animated: true, completion: nil)
    }
    @IBAction func toggleWatchlist(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblViewProducts)
        let indexPath = self.tblViewProducts.indexPathForRow(at:buttonPosition)
        print("section:\(indexPath?.section ?? 0) row:\(indexPath?.row ?? 0)")
        
        if (indexPath?.section ?? 0) == 0{
            if (self.arrFeaturedProducts[indexPath?.row ?? 0].is_favourite ?? "") == "1" || arrayWatchlistProductIDs.contains(self.arrFeaturedProducts[indexPath?.row ?? 0].id ?? ""){
                arrayWatchlistProductIDs.removeElement(element:self.arrFeaturedProducts[indexPath?.row ?? 0].id ?? "")
                wsCallRemoveProductFromWatchlist(product_id: self.arrFeaturedProducts[indexPath?.row ?? 0].id ?? "")
            }
            else{
                arrayWatchlistProductIDs.append(self.arrFeaturedProducts[indexPath?.row ?? 0].id ?? "")
                self.wsCallAddProductToWatchlist(product_id: self.arrFeaturedProducts[indexPath?.row ?? 0].id ?? "")
            }
        }
        else if (indexPath?.section ?? 0) == 1{
            if (self.arrRecentlyAddedProducts[indexPath?.row ?? 0].is_favourite ?? "") == "1" || arrayWatchlistProductIDs.contains(self.arrRecentlyAddedProducts[indexPath?.row ?? 0].id ?? ""){
                arrayWatchlistProductIDs.removeElement(element:self.arrRecentlyAddedProducts[indexPath?.row ?? 0].id ?? "")
                wsCallRemoveProductFromWatchlist(product_id: self.arrRecentlyAddedProducts[indexPath?.row ?? 0].id ?? "")
            }
            else{
                arrayWatchlistProductIDs.append(self.arrRecentlyAddedProducts[indexPath?.row ?? 0].id ?? "")
                self.wsCallAddProductToWatchlist(product_id: self.arrRecentlyAddedProducts[indexPath?.row ?? 0].id ?? "")
            }
        }
        else{
            if (self.arrFirstChoiceProducts[indexPath?.row ?? 0].is_favourite ?? "") == "1" || arrayWatchlistProductIDs.contains(self.arrFirstChoiceProducts[indexPath?.row ?? 0].id ?? ""){
                arrayWatchlistProductIDs.removeElement(element:self.arrFirstChoiceProducts[indexPath?.row ?? 0].id ?? "")
                wsCallRemoveProductFromWatchlist(product_id: self.arrFirstChoiceProducts[indexPath?.row ?? 0].id ?? "")
            }
            else{
                arrayWatchlistProductIDs.append(self.arrFirstChoiceProducts[indexPath?.row ?? 0].id ?? "")
                self.wsCallAddProductToWatchlist(product_id: self.arrFirstChoiceProducts[indexPath?.row ?? 0].id ?? "")
            }
        }
        UserDefaults.standard.set(self.arrayWatchlistProductIDs, forKey: "arrayWatchlistProductIDs")
        self.tblViewProducts.reloadData()
    }
    @IBAction func toggleCompare(_ sender: UIButton) {
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblViewProducts)
        let indexPath = self.tblViewProducts.indexPathForRow(at:buttonPosition)
        print("section:\(indexPath?.section ?? 0) row:\(indexPath?.row ?? 0)")

        if (indexPath?.section ?? 0) == 0{
            if arrayCompareProductIDs.contains(self.arrFeaturedProducts[indexPath?.row ?? 0].id ?? ""){
                arrayCompareProductIDs.removeElement(element:self.arrFeaturedProducts[indexPath?.row ?? 0].id ?? "")
            }
            else{
                arrayCompareProductIDs.append(self.arrFeaturedProducts[indexPath?.row ?? 0].id ?? "")
            }
        }
        else if (indexPath?.section ?? 0) == 1{
            if arrayCompareProductIDs.contains(self.arrRecentlyAddedProducts[indexPath?.row ?? 0].id ?? ""){
                arrayCompareProductIDs.removeElement(element:self.arrRecentlyAddedProducts[indexPath?.row ?? 0].id ?? "")
            }
            else{
                arrayCompareProductIDs.append(self.arrRecentlyAddedProducts[indexPath?.row ?? 0].id ?? "")
            }
        }
        else{
            if arrayCompareProductIDs.contains(self.arrFirstChoiceProducts[indexPath?.row ?? 0].id ?? ""){
                arrayCompareProductIDs.removeElement(element:self.arrFirstChoiceProducts[indexPath?.row ?? 0].id ?? "")
            }
            else{
                arrayCompareProductIDs.append(self.arrFirstChoiceProducts[indexPath?.row ?? 0].id ?? "")
            }
        }
        
        UserDefaults.standard.set(self.arrayCompareProductIDs, forKey: "arrayCompareProductIDs")
        checkCompareProducts()
        self.tblViewProducts.reloadData()
    }
    @IBAction func toggleShare(_ sender: UIButton) {
        
        var product_id = ""//arrFeaturedProducts[sender.tag].id ?? ""
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblViewProducts)
        let indexPath = self.tblViewProducts.indexPathForRow(at:buttonPosition)
        
        if (indexPath?.section ?? 0) == 0{
            product_id = self.arrFeaturedProducts[indexPath?.row ?? 0].id ?? ""
        }
        else if (indexPath?.section ?? 0) == 1{
            product_id = self.arrRecentlyAddedProducts[indexPath?.row ?? 0].id ?? ""
        }
        else{
            product_id = self.arrFirstChoiceProducts[indexPath?.row ?? 0].id ?? ""
        }
        
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
        self.lblCompareCount.text = "\(self.arrayCompareProductIDs.count)"
        if self.arrayCompareProductIDs.count > 0{
            self.viewCompareCount.isHidden = false
        }
        else{
            self.viewCompareCount.isHidden = true
        }
    }
    //MARK: Sliders Auto Scroll
    @objc func scrollToNextCell(){
        //get cell size
        let cellSize = CGSize(width: self.collectionViewBanner.frame.size.width, height: self.collectionViewBanner.frame.size.height)
        //get current content Offset of the Collection view
        let contentOffset = collectionViewBanner.contentOffset
        if collectionViewBanner.contentSize.width <= collectionViewBanner.contentOffset.x + cellSize.width
        {
            collectionViewBanner.scrollRectToVisible(CGRect(x: 0, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
            self.pageIndex = 0
            
        } else {
            collectionViewBanner.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
            self.pageIndex = self.pageIndex + 1
        }
        for cell in collectionViewBanner.visibleCells as [UICollectionViewCell]{
            let indexPath = collectionViewBanner.indexPath(for: cell as! CollectionCellHomeBanners)
            if (collectionViewBanner.cellForItem(at: IndexPath(item: (indexPath?.item)!, section: 0)) as? CollectionCellHomeBanners) != nil{
                pageControl.currentPage = self.pageIndex
            }
        }
    }
    func startTimer()
    {
        if timer == nil{
            timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(HomeVC.scrollToNextCell), userInfo: nil, repeats: true)
        }
    }
    func stopTimer()
    {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
    }
}
extension HomeVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblViewProducts{
            return 3
        }
        else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblViewProducts{
            if section == 0{
                return arrFeaturedProducts.count
            }
            else if section == 1{
                return arrRecentlyAddedProducts.count
            }
            else{
                return arrFirstChoiceProducts.count
            }
        }
        else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tblViewProducts{
            let header = tableView.dequeueReusableCell(withIdentifier: "CellHomeProductsHeader") as! CellHomeProductsHeader
            if section == 0{
                header.lblTitle.text = "Featured Products"
                if self.arrFeaturedProducts.count > 0{
                    return header
                }
                else{
                    return nil
                }
            }
            else if section == 1{
                header.lblTitle.text = "Recently Added Products"
                if self.arrRecentlyAddedProducts.count > 0{
                    return header
                }
                else{
                    return nil
                }
            }
            else{
                header.lblTitle.text = "First Choice Products"
                if self.arrFirstChoiceProducts.count > 0{
                    return header
                }
                else{
                    return nil
                }
            }
        }
        else{
            return nil
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblViewProducts{
            if section == 0{
                if self.arrFeaturedProducts.count > 0{
                    return 40
                }
                else{
                    return 0.1
                }
            }
            else if section == 1{
                if self.arrRecentlyAddedProducts.count > 0{
                    return 40
                }
                else{
                    return 0.1
                }
            }
            else{
                if self.arrFirstChoiceProducts.count > 0{
                    return 40
                }
                else{
                    return 0.1
                }
            }
        }
        else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == tblViewProducts{
            let footer = tableView.dequeueReusableCell(withIdentifier: "CellHomeProductsFooter") as! CellHomeProductsFooter
            footer.btnSeeAll.tag = section
            if section == 0{
                if self.arrFeaturedProducts.count > 0{
                    return footer
                }
                else{
                    return nil
                }
            }
            else if section == 1{
                if self.arrRecentlyAddedProducts.count > 0{
                    return footer
                }
                else{
                    return nil
                }
            }
            else{
                if self.arrFirstChoiceProducts.count > 0{
                    return footer
                }
                else{
                    return nil
                }
            }
        }
        else{
            return nil
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == tblViewProducts{
            if section == 0{
                if self.arrFeaturedProducts.count > 0{
                    return 30
                }
                else{
                    return 0.1
                }
            }
            else if section == 1{
                if self.arrRecentlyAddedProducts.count > 0{
                    return 30
                }
                else{
                    return 0.1
                }
            }
            else{
                if self.arrFirstChoiceProducts.count > 0{
                    return 30
                }
                else{
                    return 0.1
                }
            }
        }
        else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblViewProducts{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellHomeProducts") as! CellHomeProducts
            
            cell.lblCity.text = "Ex. Morbi"
            
            cell.lblCategoryName.font = UIFont(name: "Biennale-SemiBold", size: 16)
            cell.lblCompanyName.font = UIFont(name: "Biennale-Medium", size: 12)
            cell.lblSize.font = UIFont(name: "Biennale-Regular", size: 13)
            cell.lblGrade.font = UIFont(name: "Biennale-Regular", size: 13)
            cell.lblReportTitle.font = UIFont(name: "Biennale-Regular", size: 12)
            
            
            if indexPath.section == 0{
                cell.btnReport.tag = indexPath.row
                cell.btnWatchlist.tag = indexPath.row
                cell.btnCompare.tag = indexPath.row
                cell.btnShare.tag = indexPath.row
                
                cell.imgProduct.sd_setImage(with:URL(string:arrFeaturedProducts[indexPath.row].category_image ?? ""), completed: { (image, error, SDImageCacheTypeDisk, url) in
                })
                cell.lblCategoryName.text = self.arrFeaturedProducts[indexPath.row].category_name ?? ""
                
                if self.is_paid == "2"{
                    cell.lblCompanyName.text = self.arrFeaturedProducts[indexPath.row].company_name ?? ""
                }
                else{
                    cell.lblCompanyName.text = self.starifyNumber(number:self.arrFeaturedProducts[indexPath.row].company_name ?? "")
                }
                
                let attributedStringSize = NSMutableAttributedString(string: "Size: ")
                let sizeAttrs = [NSAttributedString.Key.font : UIFont(name: "Biennale-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13),NSAttributedString.Key.foregroundColor:UIColor.black]
                let sizeNameFont = NSMutableAttributedString(string:self.arrFeaturedProducts[indexPath.row].tile_size_name ?? "", attributes: sizeAttrs)
                attributedStringSize.insert(sizeNameFont, at: 6)
                cell.lblSize.attributedText = attributedStringSize
                
                if (self.arrFeaturedProducts[indexPath.row].grade_name ?? "") == "Premium"{
                    //green
                    let attributedStringGrade = NSMutableAttributedString(string: "Grade: ")
                    let gradeAttrs = [NSAttributedString.Key.font : UIFont(name: "Biennale-Regular", size: 13) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor(hexString: "#00ae46")]
                    let gradeNameFont = NSMutableAttributedString(string:self.arrFeaturedProducts[indexPath.row].grade_name ?? "", attributes: gradeAttrs)
                    attributedStringGrade.insert(gradeNameFont, at: 7)
                    cell.lblGrade.attributedText = attributedStringGrade
                }
                else if (self.arrFeaturedProducts[indexPath.row].grade_name ?? "") == "Standard" || (self.arrFeaturedProducts[indexPath.row].grade_name ?? "") == "Commercial" || (self.arrFeaturedProducts[indexPath.row].grade_name ?? "") == "Eco"{
                    //blue
                    let attributedStringGrade = NSMutableAttributedString(string: "Grade: ")
                    let gradeAttrs = [NSAttributedString.Key.font : UIFont(name: "Biennale-Regular", size: 13) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor(hexString: "#0065FF")]
                    let gradeNameFont = NSMutableAttributedString(string:self.arrFeaturedProducts[indexPath.row].grade_name ?? "", attributes: gradeAttrs)
                    attributedStringGrade.insert(gradeNameFont, at: 7)
                    cell.lblGrade.attributedText = attributedStringGrade
                }
                else{
                    //red
                    let attributedStringGrade = NSMutableAttributedString(string: "Grade: ")
                    let gradeAttrs = [NSAttributedString.Key.font : UIFont(name: "Biennale-Regular", size: 13) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor(hexString: "#e50914")]
                    let gradeNameFont = NSMutableAttributedString(string:self.arrFeaturedProducts[indexPath.row].grade_name ?? "", attributes: gradeAttrs)
                    attributedStringGrade.insert(gradeNameFont, at: 7)
                    cell.lblGrade.attributedText = attributedStringGrade
                }
                
                let priceTypeName = (self.arrFeaturedProducts[indexPath.row].price_type_name ?? "").replacingOccurrences(of: "per ", with: "").firstCapitalized
                cell.lblPriceAndType.text = "\(self.arrFeaturedProducts[indexPath.row].price ?? "")/\(priceTypeName)"
                
                if (self.arrFeaturedProducts[indexPath.row].is_favourite ?? "") == "1" || arrayWatchlistProductIDs.contains(self.arrFeaturedProducts[indexPath.row].id ?? ""){
                    cell.imgWatchlistIcon.image = UIImage(named: "icon_remove_watchlist")
                    cell.lblWatchList.textColor = UIColor(hexString: "#c0252b")
                }
                else{
                    cell.imgWatchlistIcon.image = UIImage(named: "icon_add_watchlist")
                    cell.lblWatchList.textColor = UIColor.darkGray
                }
                
                if arrayCompareProductIDs.contains(self.arrFeaturedProducts[indexPath.row].id ?? "")
                {
                    cell.imgCompare.image = UIImage(named: "compare_selected")
                    cell.lblCompare.textColor = UIColor(hexString: "#c0252b")
                }
                else{
                    cell.imgCompare.image = UIImage(named: "compare_select")
                    cell.lblCompare.textColor = UIColor.darkGray
                }
            }
            else if indexPath.section == 1{
                cell.btnReport.tag = indexPath.row
                cell.btnWatchlist.tag = indexPath.row
                cell.btnCompare.tag = indexPath.row
                cell.btnShare.tag = indexPath.row
                cell.imgProduct.sd_setImage(with:URL(string:arrRecentlyAddedProducts[indexPath.row].category_image ?? ""), completed: { (image, error, SDImageCacheTypeDisk, url) in
                })
                cell.lblCategoryName.text = self.arrRecentlyAddedProducts[indexPath.row].category_name ?? ""
                
                if self.is_paid == "2"{
                    cell.lblCompanyName.text = self.arrRecentlyAddedProducts[indexPath.row].company_name ?? ""
                }
                else{
                    cell.lblCompanyName.text = self.starifyNumber(number:self.arrRecentlyAddedProducts[indexPath.row].company_name ?? "")
                }
                
                let attributedStringSize = NSMutableAttributedString(string: "Size: ")
                let sizeAttrs = [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.black]
                let sizeNameFont = NSMutableAttributedString(string:self.arrRecentlyAddedProducts[indexPath.row].tile_size_name ?? "", attributes: sizeAttrs)
                attributedStringSize.insert(sizeNameFont, at: 6)
                cell.lblSize.attributedText = attributedStringSize
                
                if (self.arrRecentlyAddedProducts[indexPath.row].grade_name ?? "") == "Premium"{
                    //green
                    let attributedStringGrade = NSMutableAttributedString(string: "Grade: ")
                    let gradeAttrs = [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor(hexString: "#00ae46")]
                    let gradeNameFont = NSMutableAttributedString(string:self.arrRecentlyAddedProducts[indexPath.row].grade_name ?? "", attributes: gradeAttrs)
                    attributedStringGrade.insert(gradeNameFont, at: 7)
                    cell.lblGrade.attributedText = attributedStringGrade
                }
                else if (self.arrRecentlyAddedProducts[indexPath.row].grade_name ?? "") == "Standard" || (self.arrRecentlyAddedProducts[indexPath.row].grade_name ?? "") == "Commercial" || (self.arrRecentlyAddedProducts[indexPath.row].grade_name ?? "") == "Eco"{
                    //blue
                    let attributedStringGrade = NSMutableAttributedString(string: "Grade: ")
                    let gradeAttrs = [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor(hexString: "#0065FF")]
                    let gradeNameFont = NSMutableAttributedString(string:self.arrRecentlyAddedProducts[indexPath.row].grade_name ?? "", attributes: gradeAttrs)
                    attributedStringGrade.insert(gradeNameFont, at: 7)
                    cell.lblGrade.attributedText = attributedStringGrade
                }
                else{
                    //red
                    let attributedStringGrade = NSMutableAttributedString(string: "Grade: ")
                    let gradeAttrs = [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor(hexString: "#e50914")]
                    let gradeNameFont = NSMutableAttributedString(string:self.arrRecentlyAddedProducts[indexPath.row].grade_name ?? "", attributes: gradeAttrs)
                    attributedStringGrade.insert(gradeNameFont, at: 7)
                    cell.lblGrade.attributedText = attributedStringGrade
                }
                
                let priceTypeName = (self.arrRecentlyAddedProducts[indexPath.row].price_type_name ?? "").replacingOccurrences(of: "per ", with: "").firstCapitalized
                cell.lblPriceAndType.text = "\(self.arrRecentlyAddedProducts[indexPath.row].price ?? "")/\(priceTypeName)"
                
                if (self.arrRecentlyAddedProducts[indexPath.row].is_favourite ?? "") == "1" || arrayWatchlistProductIDs.contains(self.arrRecentlyAddedProducts[indexPath.row].id ?? ""){
                    cell.imgWatchlistIcon.image = UIImage(named: "icon_remove_watchlist")
                    cell.lblWatchList.textColor = UIColor(hexString: "#c0252b")
                }
                else{
                    cell.imgWatchlistIcon.image = UIImage(named: "icon_add_watchlist")
                    cell.lblWatchList.textColor = UIColor.darkGray
                }
                if arrayCompareProductIDs.contains(self.arrRecentlyAddedProducts[indexPath.row].id ?? "")
                {
                    cell.imgCompare.image = UIImage(named: "compare_selected")
                    cell.lblCompare.textColor = UIColor(hexString: "#c0252b")
                }
                else{
                    cell.imgCompare.image = UIImage(named: "compare_select")
                    cell.lblCompare.textColor = UIColor.darkGray
                }
            }
            else{
                cell.btnReport.tag = indexPath.row
                cell.btnWatchlist.tag = indexPath.row
                cell.btnCompare.tag = indexPath.row
                cell.btnShare.tag = indexPath.row
                cell.imgProduct.sd_setImage(with:URL(string:arrFirstChoiceProducts[indexPath.row].category_image ?? ""), completed: { (image, error, SDImageCacheTypeDisk, url) in
                })
                cell.lblCategoryName.text = self.arrFirstChoiceProducts[indexPath.row].category_name ?? ""
                
                if self.is_paid == "2"{
                    cell.lblCompanyName.text = self.arrFirstChoiceProducts[indexPath.row].company_name ?? ""
                }
                else{
                    cell.lblCompanyName.text = self.starifyNumber(number:self.arrFirstChoiceProducts[indexPath.row].company_name ?? "")
                }
                
                let attributedStringSize = NSMutableAttributedString(string: "Size: ")
                let sizeAttrs = [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.black]
                let sizeNameFont = NSMutableAttributedString(string:self.arrFirstChoiceProducts[indexPath.row].tile_size_name ?? "", attributes: sizeAttrs)
                attributedStringSize.insert(sizeNameFont, at: 6)
                cell.lblSize.attributedText = attributedStringSize
                
                if (self.arrFirstChoiceProducts[indexPath.row].grade_name ?? "") == "Premium"{
                    //green
                    let attributedStringGrade = NSMutableAttributedString(string: "Grade: ")
                    let gradeAttrs = [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor(hexString: "#00ae46")]
                    let gradeNameFont = NSMutableAttributedString(string:self.arrFirstChoiceProducts[indexPath.row].grade_name ?? "", attributes: gradeAttrs)
                    attributedStringGrade.insert(gradeNameFont, at: 7)
                    cell.lblGrade.attributedText = attributedStringGrade
                }
                else if (self.arrFirstChoiceProducts[indexPath.row].grade_name ?? "") == "Standard" || (self.arrFirstChoiceProducts[indexPath.row].grade_name ?? "") == "Commercial" || (self.arrFirstChoiceProducts[indexPath.row].grade_name ?? "") == "Eco"{
                    //blue
                    let attributedStringGrade = NSMutableAttributedString(string: "Grade: ")
                    let gradeAttrs = [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor(hexString: "#0065FF")]
                    let gradeNameFont = NSMutableAttributedString(string:self.arrFirstChoiceProducts[indexPath.row].grade_name ?? "", attributes: gradeAttrs)
                    attributedStringGrade.insert(gradeNameFont, at: 7)
                    cell.lblGrade.attributedText = attributedStringGrade
                }
                else{
                    //red
                    let attributedStringGrade = NSMutableAttributedString(string: "Grade: ")
                    let gradeAttrs = [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor(hexString: "#e50914")]
                    let gradeNameFont = NSMutableAttributedString(string:self.arrFirstChoiceProducts[indexPath.row].grade_name ?? "", attributes: gradeAttrs)
                    attributedStringGrade.insert(gradeNameFont, at: 7)
                    cell.lblGrade.attributedText = attributedStringGrade
                }
                
                let priceTypeName = (self.arrFirstChoiceProducts[indexPath.row].price_type_name ?? "").replacingOccurrences(of: "per ", with: "").firstCapitalized
                
                cell.lblPriceAndType.text = "\(self.arrFirstChoiceProducts[indexPath.row].price ?? "")/\(priceTypeName)"
                
                if (self.arrFirstChoiceProducts[indexPath.row].is_favourite ?? "") == "1" || arrayWatchlistProductIDs.contains(self.arrFirstChoiceProducts[indexPath.row].id ?? ""){
                    cell.imgWatchlistIcon.image = UIImage(named: "icon_remove_watchlist")
                    cell.lblWatchList.textColor = UIColor(hexString: "#c0252b")
                }
                else{
                    cell.imgWatchlistIcon.image = UIImage(named: "icon_add_watchlist")
                    cell.lblWatchList.textColor = UIColor.darkGray
                }
                if arrayCompareProductIDs.contains(self.arrFirstChoiceProducts[indexPath.row].id ?? "")
                {
                    cell.imgCompare.image = UIImage(named: "compare_selected")
                    cell.lblCompare.textColor = UIColor(hexString: "#c0252b")
                }
                else{
                    cell.imgCompare.image = UIImage(named: "compare_select")
                    cell.lblCompare.textColor = UIColor.darkGray
                }
            }
            
            return cell
        }
        else{
            return CellData
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblViewProducts{
            return 170
        }
        else{
            return UITableView.automaticDimension//CellData.frame.size.height
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblViewProducts{
            return 170
        }
        else{
            return 600
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productDetailsVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: ProductDetailsVC.self)) as! ProductDetailsVC
        if indexPath.section == 0{
            productDetailsVC.product_id = self.arrFeaturedProducts[indexPath.row].id ?? ""
        }
        else if indexPath.section == 1{
            productDetailsVC.product_id = self.arrRecentlyAddedProducts[indexPath.row].id ?? ""
        }
        else{
            productDetailsVC.product_id = self.arrFirstChoiceProducts[indexPath.row].id ?? ""
        }
        self.navigationController?.pushViewController(productDetailsVC, animated: true)
    }
}
extension HomeVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrNewSliders.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCellHomeBanners", for: indexPath) as? CollectionCellHomeBanners else{
            return UICollectionViewCell()
        }
        cell.imgView.sd_setImage(with:URL(string:arrNewSliders[indexPath.item].file_name ?? ""), completed: { (image, error, SDImageCacheTypeDisk, url) in
        })
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if DeviceType.IS_IPAD{
            return CGSize(width: collectionViewBanner.frame.size.width, height: 500)
        }
        else{
            return CGSize(width: collectionViewBanner.frame.size.width, height: 120)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == collectionViewBanner{
            self.pageIndex = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
            pageControl.currentPage = self.pageIndex
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (Int(arrNewSliders[indexPath.item].product_id ?? "") ?? 0) > 0{
            let productDetailsVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: ProductDetailsVC.self)) as! ProductDetailsVC
            productDetailsVC.product_id = arrNewSliders[indexPath.item].product_id ?? ""
            self.navigationController?.pushViewController(productDetailsVC, animated: true)
        }
        else if (Int(arrNewSliders[indexPath.item].seller_id ?? "") ?? 0) > 0{
            let sellerDetailsVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: SellerDetailsVC.self)) as! SellerDetailsVC
            sellerDetailsVC.user_id = arrNewSliders[indexPath.item].seller_id ?? ""
            self.navigationController?.pushViewController(sellerDetailsVC, animated: true)
        }
        else{
            
        }
    }
}
extension HomeVC{
    private func wsCallDashboard(){
        if !refreshcontrol.isRefreshing{
            self.showSpinner()
        }
        WSCalls.sharedInstance.apiCallWithHeader(url: WSRequest.getDashboard, method: .get, param: [:], headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            print(response)
            self.hideSpinner()
            self.refreshcontrol.endRefreshing()
            //self.arrSliders.removeAll()
            self.arrNewSliders.removeAll()
            self.arrFeaturedProducts.removeAll()
            self.arrRecentlyAddedProducts.removeAll()
            self.arrFirstChoiceProducts.removeAll()
            
            if let item = response["is_paid"]{
                if item is String{
                    self.is_paid = (item as? String)!
                }
                else if item is Int{
                    self.is_paid = String(item as! Int)
                }
            }
            if let item = response["plan_end_date"]{
                if item is String{
                    self.plan_end_date = (item as? String)!
                }
                else if item is Int{
                    self.plan_end_date = String(item as! Int)
                }
            }
            if let item = response["view_count"]{
                if item is String{
                    self.view_count = (item as? String)!
                }
                else if item is Int{
                    self.view_count = String(item as! Int)
                }
            }
            if let item = response["total_view_count"]{
                if item is String{
                    self.total_view_count = (item as? String)!
                }
                else if item is Int{
                    self.total_view_count = String(item as! Int)
                }
            }
            if let item = response["total_free_product"]{
                if item is String{
                    self.total_free_product = (item as? String)!
                }
                else if item is Int{
                    self.total_free_product = String(item as! Int)
                }
            }
            if let item = response["free_product"]{
                if item is String{
                    self.free_product = (item as? String)!
                }
                else if item is Int{
                    self.free_product = String(item as! Int)
                }
            }
            
            if let item = response["plan_days"]{
                if item is String{
                    self.plan_days = (item as? String)!
                }
                else if item is Int{
                    self.plan_days = String(item as! Int)
                }
            }
            if let item = response["plan_id"]{
                if item is String{
                    self.plan_id = (item as? String)!
                }
                else if item is Int{
                    self.plan_id = String(item as! Int)
                }
            }
            if let item = response["payment_plan_name"]{
                if item is String{
                    self.payment_plan_name = (item as? String)!
                }
                else if item is Int{
                    self.payment_plan_name = String(item as! Int)
                }
            }
            
            let arrSliders = response["newSliders"] as? [[String:Any]] ?? []
            if arrSliders.count > 0{
                for obj in arrSliders{
                    let obj = NewSlidersDataModel(dictinfo: obj)
                    self.arrNewSliders.append(obj)
                }
            }
            
            let arrFeatured = response["featured"] as? [[String:Any]] ?? []
            if arrFeatured.count > 0{
                for obj in arrFeatured{
                    let obj = GetDashboardProductsDataModel(dictinfo: obj)
                    self.arrFeaturedProducts.append(obj)
                }
            }
            let arrRecent = response["recently_added"] as? [[String:Any]] ?? []
            if arrRecent.count > 0{
                for obj in arrRecent{
                    let obj = GetDashboardProductsDataModel(dictinfo: obj)
                    self.arrRecentlyAddedProducts.append(obj)
                }
            }
            let arrFirstChoice = response["first_choice"] as? [[String:Any]] ?? []
            if arrFirstChoice.count > 0{
                for obj in arrFirstChoice{
                    let obj = GetDashboardProductsDataModel(dictinfo: obj)
                    self.arrFirstChoiceProducts.append(obj)
                }
            }
            self.support_number = response["support_number"] as? String ?? ""
            //self.arrSliders = response["sliders"] as? [String] ?? []
            self.pageControl.numberOfPages = self.arrNewSliders.count
            self.collectionViewBanner.reloadData()
            if self.arrNewSliders.count > 0{
                self.viewCollectionBannerContainer.isHidden = false
                
                if DeviceType.IS_IPAD{
                    self.viewCollectionBannerContainerHeight.constant = 500
                }
                else{
                    self.viewCollectionBannerContainerHeight.constant = 120
                }
            }
            else{
                self.viewCollectionBannerContainer.isHidden = true
                self.viewCollectionBannerContainerHeight.constant = 0
            }
            
            if self.arrRecentlyAddedProducts.count > 0 || self.arrFeaturedProducts.count > 0 || self.arrFirstChoiceProducts.count > 0{
                self.viewNoData.isHidden = true
            }
            else{
                self.viewNoData.isHidden = false
            }
            
            self.tblViewProducts.reloadData()
            self.tblViewProductsHeight.constant = self.tblViewProducts.contentSize.height
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
            self.hideSpinner()
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
    func wscallLogoutUser(){
        logoutFromDevice()
    }
    func logoutFromDevice(){
        if self.countOfLogoutErrorMsgs == 0{
            let alertController = UIAlertController(title: "", message: NSLocalizedString("We are signing you out as we found your account access from another device", comment: ""), preferredStyle: .alert)
            let ok = UIAlertAction(title: NSLocalizedString(NSLocalizedString("Ok", comment: ""), comment: ""), style: .default) { (action) in
                UserDefaults.standard.removeObject(forKey: "UserInformation")
                self.makeRootViewController()
            }
            alertController.addAction(ok)
            self.present(alertController, animated: true, completion: nil)
            self.countOfLogoutErrorMsgs = self.countOfLogoutErrorMsgs + 1
        }
    }
}
