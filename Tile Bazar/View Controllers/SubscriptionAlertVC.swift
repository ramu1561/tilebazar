//
//  SubscriptionAlertVC.swift
//  Tile Bazar
//
//  Created by Apple on 8/28/22.
//

import UIKit

class SubscriptionAlertVC: ParentVC {

    @IBOutlet weak var lblMonthlyViewCount: UILabel!
    @IBOutlet weak var lblUnlimited: UILabel!
    var isComingFromAddProduct = false
    let total_view_count = Int(HomeVC.sharedInstance?.total_view_count ?? "") ?? 0
    let total_free_product = Int(HomeVC.sharedInstance?.total_free_product ?? "") ?? 0
    var whichScreen = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        if isComingFromAddProduct{
            lblUnlimited.text = "For unlimited free post subscribe our premium membership plan"
            if total_free_product > 0{
                lblMonthlyViewCount.text = "Your monthly free post product limit has been reached"
                lblTotalFreeCount.text = "(total \(total_free_product) free post product left)"
            }
            else{
                lblMonthlyViewCount.text = "Your free post product limit has been reached"
                lblTotalFreeCount.text = ""
            }
        }
        else{
            lblUnlimited.text = "For unlimited free contact subscribe our premium membership plan"
            if total_view_count > 0{
                lblMonthlyViewCount.text = "Your monthly free contact limit has been reached"
                lblTotalFreeCount.text = "(total \(total_view_count) free contact left)"
            }
            else{
                lblMonthlyViewCount.text = "Your free contact limit has been reached"
                lblTotalFreeCount.text = ""
            }
        }
        */
        // Do any additional setup after loading the view.
    }
    @IBAction func toggleButtons(_ sender: UIButton) {
        if sender.tag == 1{
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
        else{
            self.dismiss(animated: true, completion: nil)
        }
    }
}
