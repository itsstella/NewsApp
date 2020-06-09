//
//  NewsDetailWebView.swift
//  NewsApp
//
//  Created by Stella Patricia (ID) on 09/06/20.
//  Copyright © 2020 Stella. All rights reserved.
//

import Foundation
import WebKit

class NewsDetailWebView: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    var stringUrl: String?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1
        let url = URL(string: stringUrl ?? "")!
        webView.load(URLRequest(url: url))
          
        // 2
//        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
//        toolbarItems = [refresh]
//        navigationController?.isToolbarHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    title = webView.title
    }
}
