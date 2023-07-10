//
//  LoginAlertVC.swift
//  Tile Bazar
//
//  Created by Harvi Jivani on 07/07/23.
//

import UIKit

class LoginAlertVC: ParentVC {

    var showLoginDelegate:ShowLoginDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func toggleButtons(_ sender: UIButton) {
        if sender.tag == 1{
            //login
            dismiss(animated: false, completion: {
                self.showLoginDelegate?.showLogin()
            })
        }
        else{
            //close
            self.dismiss(animated: true, completion: nil)
        }
    }
}
