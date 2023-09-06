//
//  webViewController.swift
//  Project
//
//  Created by Monica Girgis Kamel on 05/12/2021.
//

import UIKit
import WebKit

class webViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var articleURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        guard let articleURL = articleURL, let url = URL(string: articleURL) else {return}
        webView.load(URLRequest(url: url))
    }
}

//MARK:- WKUIDelegate, WKNavigationDelegate
extension webViewController: WKUIDelegate, WKNavigationDelegate{
//
//   func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//
//    }
}
