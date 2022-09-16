//
//  ViewContactAlertVC.swift
//  Tile Bazar
//
//  Created by Apple on 8/29/22.
//

import UIKit

class ViewContactAlertVC: ParentVC {

    var isComingFromAddProduct = false
    var phone_number = ""
    var isCallSelected = false
    var whichScreen = ""
    
    @IBOutlet weak var lblCountLeft: UILabel!
    @IBOutlet weak var lblTotalCount: UILabel!
    @IBOutlet weak var lblAreYouSure: UILabel!
    @IBOutlet weak var btnViewOrAdd: UIButton!
    @IBOutlet weak var lblUnlimited: UILabel!
    
    let view_count = Int(HomeVC.sharedInstance?.view_count ?? "") ?? 0
    let total_view_count = Int(HomeVC.sharedInstance?.total_view_count ?? "") ?? 0
    
    let free_product = Int(HomeVC.sharedInstance?.free_product ?? "") ?? 0
    let total_free_product = Int(HomeVC.sharedInstance?.total_free_product ?? "") ?? 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //free user. So check conditions here
        if isComingFromAddProduct{
            self.btnViewOrAdd.setTitle("Add Product", for: .normal)
            self.lblAreYouSure.text = "Are you sure you want to post this free product?"
            self.lblCountLeft.text = "You have \(free_product) free post product left for this month"
            self.lblTotalCount.text = "(total \(total_free_product) free post product left)"
            lblUnlimited.text = "For unlimited free post subscribe our premium membership plan"
        }
        else{
            self.btnViewOrAdd.setTitle("View Contact", for: .normal)
            self.lblAreYouSure.text = "Are you sure you want to view this free contact?"
            self.lblCountLeft.text = "You have \(view_count) free contact left for this month"
            self.lblTotalCount.text = "(total \(total_view_count) free contact left)"
            lblUnlimited.text = "For unlimited free contact subscribe our premium membership plan"
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        print("calls viewWillDisappear")
    }
    @IBAction func toggleButtons(_ sender: UIButton) {
        if sender.tag == 0{
            //close
            self.dismiss(animated: true, completion: nil)
        }
        else if sender.tag == 1{
            self.dismiss(animated: true, completion: nil)
            //api call and dismiss, in this success response check call or whatsapp and open that
            if isComingFromAddProduct{
                //add product api
                AddProductVC.sharedInstance?.callAddProductApi()
            }
            else{
                //view count api call and in this success response check call or whatsapp and open that
                wsCallUserViewCount(user_id: userInfo?.id ?? "")
            }
        }
        else{
            //subscribe
            dismiss(animated: true, completion: {
                if self.whichScreen == "ProductDetailsVC"{
                    ProductDetailsVC.sharedInstance?.showMembership()
                }
                else if self.whichScreen == "SellerDetailsVC"{
                    SellerDetailsVC.sharedInstance?.showMembership()
                }
                else{
                    //add product
                    AddProductVC.sharedInstance?.showMembership()
                }
            })
        }
    }
    func whichContactSelected(){
        if isCallSelected{
            self.makeAPhoneCall(phoneNumber: phone_number)
        }
        else{
            self.openWhatsapp(phoneNumber: phone_number)
        }
    }
}
extension ViewContactAlertVC{
    func wsCallUserViewCount(user_id:String){
        let param = ["user_id":user_id]
        WSCalls.sharedInstance.apiCallWithHeader(url: WSRequest.userViewCount, method: .post, param:param, headers:["Authorization":userInfo?.api_token ?? ""], successHandler: { (response, statuscode) in
            print(response)
            
            var view_count = ""
            var total_view_count = ""
        
            if let item = response["view_count"]{
                if item is String{
                    view_count = (item as? String)!
                }
                else if item is Int{
                    view_count = String(item as! Int)
                }
            }
            if let item = response["total_view_count"]{
                if item is String{
                    total_view_count = (item as? String)!
                }
                else if item is Int{
                    total_view_count = String(item as! Int)
                }
            }
            
            HomeVC.sharedInstance?.view_count = view_count
            HomeVC.sharedInstance?.total_view_count = total_view_count
            
            self.whichContactSelected()
            self.dismiss(animated: true, completion: nil)
            
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
