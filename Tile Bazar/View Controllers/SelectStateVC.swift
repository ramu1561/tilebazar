//
//  SelectStateVC.swift
//  Tile Bazar
//
//  Created by Apple on 8/20/22.
//

import UIKit

class SelectStateVC: TBParentVC {
    
    @IBOutlet weak var tblView: UITableView!
    var arrStates:[GetCommonIdAndNameDataModel] = []
    var isComingFrom = ""
    @IBOutlet weak var lblTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isComingFrom == "addProduct_category"{
            lblTitle.text = "Select Category"
        }
        else if isComingFrom == "addProduct_grade"{
            lblTitle.text = "Select Grade"
        }
        else if isComingFrom == "addProduct_size"{
            lblTitle.text = "Select Size"
        }
        else{
            lblTitle.text = "Select State"
        }
        self.tblView.reloadData()
        // Do any additional setup after loading the view.
    }
    @IBAction func toggleClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension SelectStateVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrStates.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellCategories") as! CellCategories
        cell.lblName.text = self.arrStates[indexPath.row].name ?? ""
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isComingFrom == "editProfile"{
            EditProfileVC.sharedInstance?.selectedStateID = self.arrStates[indexPath.row].id ?? ""
            EditProfileVC.sharedInstance?.tfState.text = self.arrStates[indexPath.row].name ?? ""
            EditProfileVC.sharedInstance?.tfState.errorMessage = ""
        }
        else if isComingFrom == "addProduct_category"{
            AddProductVC.sharedInstance?.category_id = self.arrStates[indexPath.row].id ?? ""
            AddProductVC.sharedInstance?.tfCategory.text = self.arrStates[indexPath.row].name ?? ""
            AddProductVC.sharedInstance?.tfCategory.errorMessage = ""
        }
        else if isComingFrom == "addProduct_grade"{
            AddProductVC.sharedInstance?.grade_id = self.arrStates[indexPath.row].id ?? ""
            AddProductVC.sharedInstance?.tfGrade.text = self.arrStates[indexPath.row].name ?? ""
            AddProductVC.sharedInstance?.tfGrade.errorMessage = ""
        }
        else if isComingFrom == "addProduct_size"{
            AddProductVC.sharedInstance?.tile_size_id = self.arrStates[indexPath.row].id ?? ""
            AddProductVC.sharedInstance?.tfSize.text = self.arrStates[indexPath.row].name ?? ""
            AddProductVC.sharedInstance?.tfSize.errorMessage = ""
        }
        else{
            SignUpVC.sharedInstance?.selectedStateID = self.arrStates[indexPath.row].id ?? ""
            SignUpVC.sharedInstance?.tfState.text = self.arrStates[indexPath.row].name ?? ""
            SignUpVC.sharedInstance?.tfState.errorMessage = ""
        }
        self.dismiss(animated: true, completion: nil)
    }
}
