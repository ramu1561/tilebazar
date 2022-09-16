//
//  TBWebVC.swift
//  Tile Bazar
//
//  Created by Apple on 8/30/22.
//

import UIKit
import WebKit

class TBWebVC: ParentVC,WKNavigationDelegate{

    @IBOutlet weak var lblTitle: UILabel!
    var isComingFrom = ""
    var urlToOpen = ""
    var webView : WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isComingFrom == "about"{
            lblTitle.text = "About Us"
            urlToOpen = "https://tiles.tempoapp.in/about-us"
        }
        else{
            lblTitle.text = "FAQs"
            urlToOpen = "https://tiles.tempoapp.in/faq"
        }
        let url = NSURL(string: self.urlToOpen)
        let request = NSURLRequest(url: url! as URL)
        // init and load request in webview.
        webView = WKWebView(frame: CGRect(x: 0, y: 71, width: self.view.frame.size.width, height: self.view.frame.size.height-71))
        webView.navigationDelegate = self
        webView.load(request as URLRequest)
        self.view.addSubview(webView)
        self.view.sendSubviewToBack(webView)
        // Do any additional setup after loading the view.
    }
    @IBAction func toggleBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.showSpinner()
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    //MARK:- WKNavigationDelegate
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        self.hideSpinner()
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
        self.hideSpinner()
    }
}
