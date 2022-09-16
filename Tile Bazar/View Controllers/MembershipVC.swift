//
//  MembershipVC.swift
//  Tile Bazar
//
//  Created by Apple on 8/28/22.
//

import UIKit

//MARK:- GetPaymentPlansDataModel
class GetPaymentPlansDataModel {
    var id : String?
    var amount : String?
    var name : String?
    var number_of_days : String?
    
    init(dictinfo : [String : Any]) {
        if let item = dictinfo["id"]{
            if item is String{
                id = item as? String
            }
            else if item is Int{
                id = String(item as! Int)
            }
        }
        if let item = dictinfo["amount"]{
            if item is String{
                amount = item as? String
            }
            else if item is Int{
                amount = String(item as! Int)
            }
            else if item is Double{
                amount = String(item as! Double)
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
        if let item = dictinfo["number_of_days"]{
            if item is String{
                number_of_days = item as? String
            }
            else if item is Int{
                number_of_days = String(item as! Int)
            }
            else if item is Double{
                number_of_days = String(item as! Double)
            }
        }
        
    }
}

class CellMembershipPlans:UICollectionViewCell{
    @IBOutlet weak var viewMainContainer: UIView!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var imgTick: UIImageView!
    @IBOutlet weak var lblDays: UILabel!
}
class MembershipVC: ParentVC {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet var CellData: UITableViewCell!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewContainer: UIView!
    var arrPaymentPlans:[GetPaymentPlansDataModel] = []
    var plan_id = HomeVC.sharedInstance?.plan_id ?? ""
    
    @IBOutlet weak var lblParaOne: UILabel!
    @IBOutlet weak var lblParaTwo: UILabel!
    
    @IBOutlet weak var lblMembershipExpiry: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        viewContainer.clipsToBounds = true
        viewContainer.layer.cornerRadius = 15
        if #available(iOS 11.0, *) {
            viewContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
        
        if HomeVC.sharedInstance?.is_paid ?? "" == "2"{
            let strLen = "Your membership plan expires on: "
            let attributedStringSize = NSMutableAttributedString(string: strLen)
            let sizeAttrs = [NSAttributedString.Key.font : UIFont(name: "Roboto-Bold", size: 13) ?? UIFont.systemFont(ofSize: 13),NSAttributedString.Key.foregroundColor:UIColor.black]
            let sizeNameFont = NSMutableAttributedString(string:HomeVC.sharedInstance?.plan_end_date ?? "", attributes: sizeAttrs)
            attributedStringSize.insert(sizeNameFont, at: strLen.count)
            lblMembershipExpiry.attributedText = attributedStringSize
        }
        else{
            lblMembershipExpiry.text = ""
        }
        
        let paraOne = "• 18 times free contact to sellers (As a Buyer)"
        let string_to_colorOne = "(As a Buyer)"
        
        let rangeOne = (paraOne as NSString).range(of: string_to_colorOne)
        let attributeOne = NSMutableAttributedString.init(string: paraOne)
        attributeOne.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor.init(hexString: "#c0252b"), range: rangeOne)
        lblParaOne.attributedText = attributeOne
        
        let paraTwo = "• Post a product for free 12 times (As a Seller)"
        let string_to_colorTwo = "(As a Seller)"
        let rangeTwo = (paraTwo as NSString).range(of: string_to_colorTwo)
        let attributeTwo = NSMutableAttributedString.init(string: paraTwo)
        attributeTwo.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor.init(hexString: "#c0252b"), range: rangeTwo)
        lblParaTwo.attributedText = attributeTwo
        
        wsCallGetPaymentPlans()
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
    @IBAction func toggleContactButtons(_ sender: UIButton) {
        if sender.tag == 1{
            //whatsapp
            self.openWhatsapp(phoneNumber: self.contact_number)
        }
        else{
            //call
            self.makeAPhoneCall(phoneNumber: self.contact_number)
        }
    }
}
extension MembershipVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return CellData
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 700
    }
}
extension MembershipVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrPaymentPlans.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellMembershipPlans", for: indexPath) as? CellMembershipPlans else{
           return UICollectionViewCell()
       }
        cell.lblAmount.text = "₹ \(arrPaymentPlans[indexPath.item].amount ?? "")"
        cell.lblDays.text = arrPaymentPlans[indexPath.item].name ?? ""
        
        if (arrPaymentPlans[indexPath.item].id ?? "") == self.plan_id{
            cell.imgTick.isHidden = false
            cell.viewMainContainer.backgroundColor = .white
            cell.viewMainContainer.layer.borderColor = UIColor.init(hexString: "#a83034").cgColor
            cell.viewMainContainer.layer.borderWidth = 1.0
        }
        else{
            cell.imgTick.isHidden = true
            cell.viewMainContainer.backgroundColor = UIColor.init(hexString: "##fbfbfb")
            cell.viewMainContainer.layer.borderColor = UIColor.init(hexString: "#f2e5e6").cgColor
            cell.viewMainContainer.layer.borderWidth = 0.5
        }
        cell.viewMainContainer.layer.masksToBounds = true
        
       return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if self.arrPaymentPlans.count >= 4{
            let yourWidth = (collectionView.bounds.width-15)/4.0
            let size = CGSize(width: yourWidth, height: 60)
            return size
        }
        else{
            let yourWidth = (collectionView.bounds.width-15)/Double(self.arrPaymentPlans.count)
            let size = CGSize(width: yourWidth, height: 60)
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
        return 5
    }
}
extension MembershipVC{
    func wsCallGetPaymentPlans(){
        self.showSpinner()
        WSCalls.sharedInstance.apiCallWithHeader(url: WSRequest.paymentPlans, method: .get, param:[:], headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            self.hideSpinner()
            print(response)
            self.arrPaymentPlans.removeAll()
            let arrFeatured = response["Data"] as? [[String:Any]] ?? []
            if arrFeatured.count > 0{
                for obj in arrFeatured{
                    let obj = GetPaymentPlansDataModel(dictinfo: obj)
                    self.arrPaymentPlans.append(obj)
                }
            }
            self.collectionView.reloadData()
            self.collectionViewHeight.constant = self.collectionView.collectionViewLayout.collectionViewContentSize.height
            
            UIView.performWithoutAnimation {
                self.tblView.reloadData()
                self.tblView.layoutIfNeeded()
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
}
class CustomCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if !(__CGSizeEqualToSize(bounds.size,self.intrinsicContentSize)){
            self.invalidateIntrinsicContentSize()
        }
    }
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
