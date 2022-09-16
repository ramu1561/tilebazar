//
//  FiltersVC.swift
//  Tile Bazar
//
//  Created by Apple on 8/14/22.
//

import UIKit

public struct FilterSection{
    var name: String
    var key: String
    var items: [[String:Any]]
    var selectedValues:[String]
    
    public init(name: String,key: String, items: [[String:Any]], selectedValues:[String] = []) {
        self.name = name
        self.key = key
        self.items = items
        self.selectedValues = selectedValues
    }
}
class CellFilterTitles: UITableViewCell {
    @IBOutlet weak var lblFiltersCount: UILabel!
    @IBOutlet weak var lblFilterTitle: UILabel!
    @IBOutlet weak var lblSeparator: UILabel!
}
class CellFilterOptions: UITableViewCell {
    @IBOutlet weak var lblOptionsTitle: UILabel!
    @IBOutlet weak var imgFilterSelect: UIImageView!
    @IBOutlet weak var lblSeparator: UILabel!
}
class FiltersVC: ParentVC {

    @IBOutlet weak var tblFilterTitles: UITableView!
    @IBOutlet weak var tblFilterOptions: UITableView!
    var arrFilterOptions : [[String:Any]] = []
    var sections = [FilterSection]()
    var currentSection = 0
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var viewSearchbar: UIView!
    var filteredData : [[String:Any]] = []
    var inSearchMode = false
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnApply: UIButton!
    var infoArray : [[String:Any]] = []
    var filterArray : [[String:Any]] = []
    var filterArrayForReset : [[String:Any]] = []
    var isComingFrom = ""
    @IBOutlet weak var btnBackIcon: UIButton!
    @IBOutlet weak var lblSeparator: UILabel!
    @IBOutlet weak var viewBottomBtns: UIView!
    var filter_params : [String:Any] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        lblHeaderTitle.text = NSLocalizedString("Filters", comment: "")
        searchBar.placeholder = NSLocalizedString("Search", comment: "")
        btnClear.setTitle(NSLocalizedString("Clear All", comment: ""), for: .normal)
        btnClose.setTitle(NSLocalizedString("Close", comment: ""), for: .normal)
        btnApply.setTitle(NSLocalizedString("Apply", comment: ""), for: .normal)
        self.searchBar.addRobotoFontToSearchBar(targetSearchBar: searchBar)
        self.wsCallGetProductFilters()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    @IBAction func toggleBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func toggleCloseApplyClearAll(_ sender: UIButton) {
        if sender.tag == 0{
            //close
            self.navigationController?.popViewController(animated: true)
        }
        else if sender.tag == 1{
            //Apply
            self.filterArray.removeAll()
            self.filterArrayForReset.removeAll()
            for i in 0..<sections.count{
                if self.sections[i].selectedValues.count > 0{
                    let filterDetails = [self.sections[i].key:self.sections[i].selectedValues.joined(separator: ",")]
                    self.filterArrayForReset.append(filterDetails)
                }
                let contactDetails = [self.sections[i].key:self.sections[i].selectedValues.joined(separator: ",")]
                self.filterArray.append(contactDetails)
            }
            
            if self.filterArray.count > 0{
                for i in 0..<self.filterArray.count{
                    for (key, value) in self.filterArray[i]{
                        filter_params[key] = value
                    }
                }
            }
            else{
                filter_params.removeAll()
            }
            MarketVC.sharedInstance?.filterArray = self.filterArray
            MarketVC.sharedInstance?.filter_params = filter_params
            MarketVC.sharedInstance?.filterArrayForReset = self.filterArrayForReset
            self.navigationController?.popViewController(animated: true)
        }
        else{
            //clear
            for i in 0..<self.sections.count{
                self.sections[i].selectedValues.removeAll()
                self.filterArray.removeAll()
                self.searchBar.text = ""
                self.inSearchMode = false
                self.view.endEditing(true)
                self.tblFilterTitles.reloadData()
                self.tblFilterOptions.reloadData()
            }
        }
    }
}
extension FiltersVC : UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UISearchBarDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblFilterTitles{
            return sections.count
        }
        else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblFilterTitles{
            return 1
        }
        else{
            if (inSearchMode){
                return filteredData.count
            }
            else{
                return arrFilterOptions.count
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblFilterTitles{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellFilterTitles") as! CellFilterTitles
            cell.lblFilterTitle.text = self.sections[indexPath.section].name.firstUppercased
            
            if self.sections[indexPath.section].selectedValues.count > 0{
                cell.lblFiltersCount.text = "\(self.sections[indexPath.section].selectedValues.count)"
            }
            else{
                cell.lblFiltersCount.text = ""
            }
            if currentSection == indexPath.section{
                cell.contentView.backgroundColor = .white
            }
            else{
                cell.contentView.backgroundColor = #colorLiteral(red: 0.9211239219, green: 0.9343332648, blue: 0.9468662143, alpha: 1)
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellFilterOptions") as! CellFilterOptions
            if (inSearchMode){
                cell.lblOptionsTitle.text = "\(filteredData[indexPath.row]["name"] as? String ?? "")"
                if let item = filteredData[indexPath.row]["id"]{
                    if item is String{
                        if self.sections[currentSection].selectedValues.contains((item as? String)!){
                            cell.imgFilterSelect.image = UIImage(named: "filter_select")
                        }
                        else{
                            cell.imgFilterSelect.image = UIImage(named: "filter_unselect")
                        }
                    }
                    else if item is Int{
                        if self.sections[currentSection].selectedValues.contains(String(item as! Int)){
                            cell.imgFilterSelect.image = UIImage(named: "filter_select")
                        }
                        else{
                            cell.imgFilterSelect.image = UIImage(named: "filter_unselect")
                        }
                    }
                }
            }
            else{
                cell.lblOptionsTitle.text = "\(arrFilterOptions[indexPath.row]["name"] as? String ?? "")"
                if let item = arrFilterOptions[indexPath.row]["id"]{
                    if item is String{
                        if self.sections[currentSection].selectedValues.contains((item as? String)!){
                            cell.imgFilterSelect.image = UIImage(named: "filter_select")
                        }
                        else{
                            cell.imgFilterSelect.image = UIImage(named: "filter_unselect")
                        }
                    }
                    else if item is Int{
                        if self.sections[currentSection].selectedValues.contains(String(item as! Int)){
                            cell.imgFilterSelect.image = UIImage(named: "filter_select")
                        }
                        else{
                            cell.imgFilterSelect.image = UIImage(named: "filter_unselect")
                        }
                    }
                }
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblFilterTitles{
            searchBar.text = ""
            inSearchMode = false
            view.endEditing(true)
            currentSection = indexPath.section
            arrFilterOptions = self.sections[indexPath.section].items
            self.tblFilterTitles.reloadData()
            self.tblFilterOptions.reloadData()
        }
        else{
            if (inSearchMode){
                if let item = filteredData[indexPath.row]["id"]{
                    if item is String{
                        if self.sections[currentSection].selectedValues.contains((item as? String)!){
                            self.sections[currentSection].selectedValues.removeElement(element:(item as? String)!)
                        }
                        else{
                            self.sections[currentSection].selectedValues.append((item as? String)!)
                        }
                    }
                    else if item is Int{
                        if self.sections[currentSection].selectedValues.contains(String(item as! Int)){
                            self.sections[currentSection].selectedValues.removeElement(element:String(item as! Int))
                        }
                        else{
                            self.sections[currentSection].selectedValues.append(String(item as! Int))
                        }
                    }
                }
            }
            else{
                if let item = arrFilterOptions[indexPath.row]["id"]{
                    if item is String{
                        if self.sections[currentSection].selectedValues.contains((item as? String)!){
                            self.sections[currentSection].selectedValues.removeElement(element:(item as? String)!)
                        }
                        else{
                            self.sections[currentSection].selectedValues.append((item as? String)!)
                        }
                    }
                    else if item is Int{
                        if self.sections[currentSection].selectedValues.contains(String(item as! Int)){
                            self.sections[currentSection].selectedValues.removeElement(element:String(item as! Int))
                        }
                        else{
                            self.sections[currentSection].selectedValues.append(String(item as! Int))
                        }
                    }
                }
            }
            self.tblFilterOptions.reloadData()
            self.tblFilterTitles.reloadData()
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            inSearchMode = false
            view.endEditing(true)
            tblFilterOptions.reloadData()
        } else {
            inSearchMode = true
            let results = arrFilterOptions.filter({ person in
                if let firstname = person["name"] as? String, let query = searchBar.text{
//                    return firstname.range(of: query, options: [.caseInsensitive, .diacriticInsensitive]) != nil
                    return firstname.contains(query)
                }
                return false
            })
            filteredData = NSMutableArray(array: results) as! [[String:Any]]
            tblFilterOptions.reloadData()
        }
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
extension UISearchBar {
    func addRobotoFontToSearchBar(targetSearchBar:UISearchBar?)
    {
        let textFieldInsideSearchBar = targetSearchBar!.value(forKey: "searchField") as! UITextField
        textFieldInsideSearchBar.font = UIFont(name: "Roboto-Regular", size: 13.0)
    }
}
extension StringProtocol {
    var firstUppercased: String {
        return prefix(1).uppercased() + dropFirst()
    }
    var firstCapitalized: String {
        return String(prefix(1)).capitalized + dropFirst()
    }
}
extension FiltersVC{
    func wsCallGetProductFilters(){
        self.showSpinner()
        WSCalls.sharedInstance.apiCallWithHeader(url:WSRequest.getProductFilters, method: .get, param:[:], headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (repsonse, statuscode) in
            self.hideSpinner()
            self.sections.removeAll()
            self.infoArray.removeAll()
            print(repsonse)
            if let arrSectionTemp = repsonse["Data"]{
                for obj in arrSectionTemp as! [[String:Any]]{
                    self.infoArray.append(obj)
                }
            }
            
            if self.infoArray.count > 0{
                for i in 0..<self.infoArray.count{
                    self.sections.append(FilterSection(name: self.infoArray[i]["name"] as? String ?? "", key: self.infoArray[i]["key"] as? String ?? "", items: self.infoArray[i]["data"] as! [[String:Any]], selectedValues: []))
                }
            }
            
            self.arrFilterOptions = self.sections[self.currentSection].items
            //companyUsers
            if self.sections.count == self.filterArray.count{
                for i in 0..<self.filterArray.count{
                    for (key, value) in self.filterArray[i]{
                        if key == self.sections[i].key{
                            let dataValues = value as? String ?? ""
                            let selectedValues = dataValues.components(separatedBy: ",")
                            print(key,selectedValues)
                            if dataValues == ""{
                                self.sections[i].selectedValues.append(contentsOf: [])
                            }
                            else{
                                self.sections[i].selectedValues.append(contentsOf: selectedValues)
                            }
                        }
                    }
                }
            }
            else{
                //first time, no filers applied
            }
            self.tblFilterTitles.reloadData()
            self.tblFilterOptions.reloadData()
            
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
                self.hideSpinner()
                self.showToast(title:response["Message"] as? String ?? "")
                
            }
            
        }) { (error) in
            self.hideSpinner()
        }
    }
}
