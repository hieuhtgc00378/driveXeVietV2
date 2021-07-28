//
//  PWebViewController.swift
//  Supership
//
//  Created by Mac on 8/9/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import UIKit
import WebKit

class PWebViewController: UIViewController {
    
    var progressBar: UIProgressView?
    var webView: WKWebView!
    var urlString: String = "https://google.com"
    var localHTMLName: String = ""
    var htmlString: String = ""
    var activityIndicator = UIActivityIndicatorView()
    var addObserver = false
    var lastProgress: Double = 0
    
    var titleView: String = ""
    var isShowNavi = false
    
    //MARK: - Life cycle
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initComponent()
        if isShowNavi {
            navigationController?.isNavigationBarHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        progressBar = UIProgressView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 2))
        progressBar?.progress = 0.0
        progressBar?.isHidden = true
        progressBar?.progressTintColor = UIColor.blue
        self.view.addSubview(progressBar!)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            print("estimatedProgress: \(webView.estimatedProgress)")
            progressBar?.isHidden = webView.estimatedProgress == 1
            progressBar?.setProgress(Float(webView.estimatedProgress), animated: true)
            return
        }
    }
    
    deinit {
        guard webView != nil && addObserver == true else { return }
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    
    // MARK: - Init component
    
    func initComponent() {
        //set webview
        if localHTMLName.count > 0 {
            loadLocalHTML()
        } else if htmlString.count > 0 {
            webView.loadHTMLString(htmlString.replacingOccurrences(of: "\n", with: "<br/>"), baseURL: nil)
        } else {
            if let url = URL(string: urlString) {
                webView.load(URLRequest(url: url))
                webView.allowsBackForwardNavigationGestures = true
                addObserver = true
                webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
            }
        }
        let screenSize = UIScreen.main.bounds.size
        webView.frame = CGRect(x: 10, y: 0, width: screenSize.width - 20, height: screenSize.height)
    }
    
    private func loadLocalHTML() {
        let localfilePath = Bundle.main.url(forResource: localHTMLName, withExtension: "html");
        let myRequest = NSURLRequest(url: localfilePath!);
        webView.frame = self.view.bounds
        webView.load(myRequest as URLRequest);
    }
    
    // MARK: - Action methods
    
    @IBAction func backDidClicked(_ sender: Any) {
        if let navi = self.navigationController {
            if navi.viewControllers.count > 1 {
                navi.popViewController(animated: true)
            } else {
                navi.dismiss(animated: true, completion: nil)
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}


// MARK: - WKWebview delegate

extension PWebViewController: WKUIDelegate, WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
}








