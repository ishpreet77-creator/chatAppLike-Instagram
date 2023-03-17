//
//  WebVC.swift
//  Flazhed
//
//  Created by IOS22 on 11/01/21.
//


import UIKit
import WebKit
import SkeletonView

class WebVC: BaseVC {
    
    //MARK: - Variables
 
    
    @IBOutlet weak var webViewUrl: WKWebView!
    @IBOutlet weak var lblTitle: UILabel!
    var pageTitle = ""
    var pageUrl = ""
    
    
    //MARK: - Class Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.webViewUrl.uiDelegate=self
        self.webViewUrl.navigationDelegate = self
        self.lblTitle.text = pageTitle
        
        if pageUrl != ""
        {
            self.showLoader()
           // Indicator.sharedInstance.showIndicator()
        let request = URLRequest(url: URL(string: pageUrl)!)
        
            self.webViewUrl.load(request)
        }
        else
        {
            self.hideLoader()
        }
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
      
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
  
        
    }
    
    //MARK: -IBActions
    @IBAction func backBtnAction(_ sender: UIButton) {
        DataManager.comeFrom = kViewProfile
        self.dismiss(animated: true) {
            self.navigationController?.popViewController(animated: true)
        }
      
    }
    
    func showLoader()
    {
        Indicator.sharedInstance.showIndicator3(views: [self.webViewUrl])
    }
    func hideLoader()
    {
        Indicator.sharedInstance.hideIndicator3(views: [self.webViewUrl])

    }
    
}

extension WebVC:UIWebViewDelegate,WKUIDelegate,WKNavigationDelegate
{
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Indicator.sharedInstance.hideIndicator()
        self.hideLoader()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Indicator.sharedInstance.hideIndicator()
        self.hideLoader()
        debugPrint(#function)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        debugPrint(#function)
        Indicator.sharedInstance.hideIndicator()
        self.hideLoader()
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        debugPrint(#function)
        Indicator.sharedInstance.hideIndicator()
        self.hideLoader()
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Swift.Void) {
        guard
            let response = navigationResponse.response as? HTTPURLResponse,
            let url = navigationResponse.response.url
        else {
            decisionHandler(.cancel)
            return
        }

        if let headerFields = response.allHeaderFields as? [String: String] {
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
            cookies.forEach { (cookie) in
                HTTPCookieStorage.shared.setCookie(cookie)
            }
        }

        decisionHandler(.allow)
    }
    
}
