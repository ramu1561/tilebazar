//
//  CategoriesVC.swift
//  Tile Bazar
//
//  Created by Apple on 8/15/22.
//

import UIKit

class CellCategories:UITableViewCell{
    @IBOutlet weak var lblName: UILabel!
}
//MARK:- GetCommonIdAndNameDataModel
class GetCommonIdAndNameDataModel {
    var id : String?
    var name : String?
    
    init(dictinfo : [String : Any]) {
        if let item = dictinfo["id"]{
            if item is String{
                id = item as? String
            }
            else if item is Int{
                id = String(item as! Int)
            }
        }
        if let item = dictinfo["name"]{
            if item is String{
                name = item as? String
            }
            else if item is Int{
                name = String(item as! Int)
            }
        }
    }
}
class CategoriesVC: ParentVC {

    @IBOutlet weak var tblView: UITableView!
    var arrCategories:[GetCommonIdAndNameDataModel] = []
    @IBOutlet weak var viewNoData: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wsCallGetProductConfiguration()
        // Do any additional setup after loading the view.
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
    @IBAction func toggleButtons(_ sender: UIButton) {
        let seeAllProductsVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: SeeAllProductsVC.self)) as! SeeAllProductsVC
        seeAllProductsVC.isComingFrom = "categories"
        if sender.tag == 0{
            //under 15
            seeAllProductsVC.sq_ft_price = "1"
            seeAllProductsVC.titleName = "₹ 15/ SQ.FT."
        }
        else if sender.tag == 1{
            //20
            seeAllProductsVC.sq_ft_price = "2"
            seeAllProductsVC.titleName = "₹ 20/ SQ.FT."
        }
        else{
            //30
            seeAllProductsVC.sq_ft_price = "3"
            seeAllProductsVC.titleName = "₹ 30/ SQ.FT."
        }
        self.navigationController?.pushViewController(seeAllProductsVC, animated: true)
    }
}
extension CategoriesVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCategories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellCategories") as! CellCategories
        cell.lblName.text = self.arrCategories[indexPath.row].name ?? ""
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let seeAllProductsVC = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: String(describing: SeeAllProductsVC.self)) as! SeeAllProductsVC
        seeAllProductsVC.isComingFrom = "categories"
        seeAllProductsVC.category_id = self.arrCategories[indexPath.row].id ?? ""
        seeAllProductsVC.titleName = self.arrCategories[indexPath.row].name ?? ""
        self.navigationController?.pushViewController(seeAllProductsVC, animated: true)
    }
}
extension CategoriesVC{
    private func wsCallGetProductConfiguration(){
        WSCalls.sharedInstance.apiCallWithHeader(url: WSRequest.getProductConfiguration, method: .get, param: [:], headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            print(response)
            self.arrCategories.removeAll()
            let arrTemp = response["categories"] as? [[String:Any]] ?? []
            if arrTemp.count > 0{
                for obj in arrTemp{
                    let obj = GetCommonIdAndNameDataModel(dictinfo: obj)
                    self.arrCategories.append(obj)
                }
            }
            if self.arrCategories.count > 0{
                self.viewNoData.isHidden = true
            }
            else{
                self.viewNoData.isHidden = false
            }
            self.tblView.reloadData()
            
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
                self.hideSpinner()
                HomeVC.sharedInstance?.wscallLogoutUser()
            }
            else{
                self.showAlert(msg: response["Message"] as? String ?? "")
            }
        }) { (error) in
        }
    }
}
