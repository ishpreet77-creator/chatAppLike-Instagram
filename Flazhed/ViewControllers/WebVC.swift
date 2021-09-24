//
//  WebVC.swift
//  Flazhed
//
//  Created by IOS22 on 11/01/21.
//


import UIKit
import WebKit

class WebVC: BaseVC {
    
    //MARK:- Variables
 
    
    @IBOutlet weak var webViewUrl: WKWebView!
    @IBOutlet weak var lblTitle: UILabel!
    var pageTitle = ""
    var pageUrl = ""
    
    
    //MARK:- Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webViewUrl.uiDelegate=self
        self.webViewUrl.navigationDelegate = self
        self.lblTitle.text = pageTitle
        
        if pageUrl != ""
        {
            Indicator.sharedInstance.showIndicator()
        let request = URLRequest(url: URL(string: pageUrl)!)
        
        self.webViewUrl.load(request)
        }
        else
        {
            
        }
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
      
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
  
        
    }
    
    //MARK:-IBActions
    @IBAction func backBtnAction(_ sender: UIButton) {
        DataManager.comeFrom = kViewProfile
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension WebVC:UIWebViewDelegate,WKUIDelegate,WKNavigationDelegate
{
   
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Indicator.sharedInstance.hideIndicator()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Indicator.sharedInstance.hideIndicator()
    }
    
}
