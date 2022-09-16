//
//  TBParentVC.swift
//  Tile Bazar
//
//  Created by Apple on 8/13/22.
//

import UIKit
import Toast_Swift

class TBParentVC: UIViewController {

    var indicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator()
        // Do any additional setup after loading the view.
    }
    func activityIndicator(){
        indicator = UIActivityIndicatorView(frame: CGRect(origin: self.view.center, size: CGSize(width: 40, height: 40)))
        indicator.style = UIActivityIndicatorView.Style.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }
    func showToast(title : String){
        ToastManager.shared.position = .bottom
        self.view.makeToast(title)
    }
    func makeRootViewController(){
        let rootViewController = AppDelegate.mainStoryboard().instantiateViewController(withIdentifier: "RootViewController") as! RootViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootViewController
    }
    func showSpinner(){
        //UIApplication.shared.beginIgnoringInteractionEvents()
        indicator.startAnimating()
    }
    func hideSpinner(){
        //UIApplication.shared.endIgnoringInteractionEvents()
        indicator.stopAnimating()
        indicator.hidesWhenStopped = true
    }
    func showAlert(msg : String){
        let alert = UIAlertController(title:"", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:NSLocalizedString("Ok", comment: ""), style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func showAlertForPhotosPermission(){
        let alert = UIAlertController(title:NSLocalizedString("This app does not have access to your photos", comment:""), message:NSLocalizedString("You can enable this in privacy settings", comment: ""), preferredStyle:.alert)
        let ok = UIAlertAction(title:NSLocalizedString("Privacy Settings", comment: ""), style:.default) { _ in
            if let bundleId = Bundle.main.bundleIdentifier,
               let url = URL(string: "\(UIApplication.openSettingsURLString)&path=Photos/\(bundleId)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let no = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style:.default) { _ in
            
        }
        alert.addAction(ok)
        alert.addAction(no)
        present(alert, animated: true, completion: nil)
    }
}
