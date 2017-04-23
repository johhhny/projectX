//
//  WebViewController.swift
//  appX
//
//  Created by user on 21.04.17.
//  Copyright © 2017 Johhhny. All rights reserved.
//

import UIKit
import WebKit

class WebViewController1: UIViewController, UIWebViewDelegate {

    //@IBOutlet weak var webView: UIWebView!
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self as? WKUIDelegate
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: url1)
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
    
    
    var url1 = String()
    
    /*override func viewDidLoad() {
        super.viewDidLoad()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        let url = URL(string: url1)
        //webView.loadRequest(URLRequest(url: url!))
        
        //let url1 = NSURL(string: self.url)
        print(url1)
        var a = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 4.0)
        //let webView = UIWebView()
        a.httpShouldHandleCookies = false
        webView.loadRequest(a)
        
        if (webView.isLoading){
            webView.stopLoading()
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        webView.stopLoading()
        webView.removeFromSuperview()
    }
    @IBAction func clickExit(_ sender: UIButton) {
        URLCache.shared.removeAllCachedResponses()
        
        // Delete any associated cookies
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    /**/
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
