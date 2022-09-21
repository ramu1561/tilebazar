//
//  CompareProductsVC.swift
//  Tile Bazar
//
//  Created by Apple on 9/6/22.
//

import UIKit

//MARK:- CompareProductsDataModel
class CompareProductsDataModel {
    var id : String?
    var category_name : String?
    var company_name : String?
    var coverage : String?
    var grade_name : String?
    var price : String?
    var price_category_name : String?
    var price_type_name : String?
    var quantity : String?
    var thickness : String?
    var tile_size_name : String?
    var weight : String?
    
    init(dictinfo : [String : Any]) {
        if let item = dictinfo["id"]{
            if item is String{
                id = item as? String
            }
            else if item is Int{
                id = String(item as! Int)
            }
        }
        category_name = dictinfo["category_name"] as? String ?? ""
        company_name = dictinfo["company_name"] as? String ?? ""
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
        grade_name = dictinfo["grade_name"] as? String ?? ""
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
        price_category_name = dictinfo["price_category_name"] as? String ?? ""
        price_type_name = dictinfo["price_type_name"] as? String ?? ""
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
        if let item = dictinfo["tile_size_name"]{
            if item is String{
                tile_size_name = item as? String
            }
            else if item is Int{
                tile_size_name = String(item as! Int)
            }
            else if item is Double{
                tile_size_name = String(item as! Double)
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
    }
}

class CellCompareHeaderCollection:UICollectionViewCell{
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblPriceNType: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
}
class CollectionCellCompareProducts:UICollectionViewCell{
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblGrade: UILabel!
    @IBOutlet weak var lblTileSize: UILabel!
    @IBOutlet weak var lblPriceCategory: UILabel!
    @IBOutlet weak var lblPriceType: UILabel!
    @IBOutlet weak var lblNoOfPcs: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblThickness: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblCoverage: UILabel!
}
class CompareProductsVC: ParentVC,UIScrollViewDelegate{
    
    var arrayCompareProductIDs = UserDefaults.standard.stringArray(forKey: "arrayCompareProductIDs") ?? [String]()
    var arrOptions:[String] = []
    @IBOutlet weak var tblViewOptions: UITableView!
    @IBOutlet weak var collectionViewHeader: UICollectionView!
    var arrProducts:[CompareProductsDataModel] = []
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionViewProducts: UICollectionView!
    @IBOutlet weak var contentView: UIView!
    var lastContentOffset = 0.0
    var hasLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        wsCallGetCompareProducts(product_ids: arrayCompareProductIDs.joined(separator: ","))
        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width:contentView.frame.width, height: collectionViewProducts.frame.height)
    }
    @IBAction func toggleBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    @IBAction func toggleDeleteProduct(_ sender: UIButton) {
        if arrayCompareProductIDs.contains(self.arrProducts[sender.tag].id ?? ""){
            arrayCompareProductIDs.removeElement(element:self.arrProducts[sender.tag].id ?? "")
        }
        UserDefaults.standard.set(self.arrayCompareProductIDs, forKey: "arrayCompareProductIDs")
        if self.arrayCompareProductIDs.count >= 2{
            self.wsCallGetCompareProducts(product_ids: arrayCompareProductIDs.joined(separator: ","))
        }
        else{
            self.showToast(title: "Please select at least 2 products to compare")
            self.navigationController?.popViewController(animated: true)
        }
    }
}
extension CompareProductsVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOptions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellProductDetailsList") as! CellProductDetailsList
        cell.lblTitle.text = arrOptions[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tblViewOptions{
            self.scrollView.contentOffset = scrollView.contentOffset
        }
        else if scrollView == collectionViewHeader{
            collectionViewProducts.contentOffset = scrollView.contentOffset
        }
        else if scrollView == collectionViewProducts{
            collectionViewHeader.contentOffset = scrollView.contentOffset
        }
        else{
            tblViewOptions.contentOffset = scrollView.contentOffset
        }
    }
}
extension CompareProductsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrProducts.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewHeader{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellCompareHeaderCollection", for: indexPath) as? CellCompareHeaderCollection else{
                return UICollectionViewCell()
            }
             cell.btnDelete.tag = indexPath.item
             cell.lblCategoryName.text = self.arrProducts[indexPath.item].category_name ?? ""
             cell.lblCompanyName.text = self.arrProducts[indexPath.item].company_name ?? ""
             let priceTypeName = (self.arrProducts[indexPath.row].price_type_name ?? "").replacingOccurrences(of: "per ", with: "").firstCapitalized
             cell.lblPriceNType.text = "\(self.arrProducts[indexPath.row].price ?? "")/\(priceTypeName)"
            return cell
        }
        else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCellCompareProducts", for: indexPath) as? CollectionCellCompareProducts else{
                return UICollectionViewCell()
            }
            cell.lblCompanyName.text = self.arrProducts[indexPath.item].company_name ?? ""
            cell.lblCategory.text = self.arrProducts[indexPath.item].category_name ?? ""
            cell.lblGrade.text = self.arrProducts[indexPath.item].grade_name ?? ""
            cell.lblTileSize.text = self.arrProducts[indexPath.item].tile_size_name ?? ""
            cell.lblPriceCategory.text = self.arrProducts[indexPath.item].price_category_name ?? ""
            cell.lblPriceType.text = self.arrProducts[indexPath.item].price_type_name ?? ""
            cell.lblNoOfPcs.text = self.arrProducts[indexPath.item].quantity ?? ""
            cell.lblPrice.text = self.arrProducts[indexPath.item].price ?? ""
            cell.lblThickness.text = self.arrProducts[indexPath.item].thickness ?? ""
            cell.lblWeight.text = self.arrProducts[indexPath.item].weight ?? ""
            cell.lblCoverage.text = self.arrProducts[indexPath.item].coverage ?? ""
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewHeader{
            let size = CGSize(width: 140, height: 100)
            return size
        }
        else{
            let size = CGSize(width: 140, height: 550)
            return size
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
extension CompareProductsVC{
    private func wsCallGetCompareProducts(product_ids:String){
        self.showSpinner()
        WSCalls.sharedInstance.apiCallWithHeader(url:WSRequest.compareProducts, method: .post, param: ["product_ids":product_ids], headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            self.hideSpinner()
            print(response)
            self.arrOptions = response["options"] as? [String] ?? []
            self.arrProducts.removeAll()
            let arrFeatured = response["products"] as? [[String:Any]] ?? []
            if arrFeatured.count > 0{
                for obj in arrFeatured{
                    let obj = CompareProductsDataModel(dictinfo: obj)
                    self.arrProducts.append(obj)
                }
            }
            self.collectionViewHeader.reloadData()
            self.collectionViewProducts.reloadData()
            self.tblViewOptions.reloadData()
            
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
                self.hideSpinner()
                HomeVC.sharedInstance?.wscallLogoutUser()
            }
            else{
                self.showAlert(msg: response["Message"] as? String ?? "")
            }
            
        }) { (error) in
            self.hideSpinner()
        }
    }
}
