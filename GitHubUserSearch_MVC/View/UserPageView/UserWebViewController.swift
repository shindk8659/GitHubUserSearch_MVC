//
//  UserPageViewController.swift
//  githubExample
//
//  Created by 신동규 on 30/04/2019.
//  Copyright © 2019 신동규. All rights reserved.
//
import UIKit
import WebKit

class UserWebViewController: UIViewController{
    
    public var urlString:String?
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!

    @IBAction func backAction(_ sender: Any) {
        webView.goBack()

    }

    @IBAction func forwardAction(_ sender: Any) {
        webView.goForward()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: urlString ?? "") else {return}
        let request = URLRequest(url: url)
        webView.navigationDelegate = self
        webView.load(request)
    }
    
}

extension UserWebViewController: WKNavigationDelegate
{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward

    }
}
