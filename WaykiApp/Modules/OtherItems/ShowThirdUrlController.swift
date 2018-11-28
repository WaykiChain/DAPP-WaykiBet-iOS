//
//  ShowThirdUrlController.swift
//  CommApp
//
//  Created by sorath on 2018/10/29.
//  Copyright © 2018年 sorath. All rights reserved.
//

import UIKit

class ShowThirdUrlController: BaseViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle{get { return.lightContent}}
    var wkWebView: WKWebView = WKWebView.init()
    var url:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        addWKWebView()
        if url != ""{
            reloadURL(url: url)
        }
        wkWebView.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.new, context: nil)
    }

    override func viewWillDisappear(_ animated: Bool) { 
        super.viewWillDisappear(animated)
        RequestHandler.dismissHUD()
    }
    
    //监听webviewurl 的 title
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (object is WKWebView){
            let wk = object as! WKWebView
            if wk == wkWebView{
                self.titleLabel?.text = self.wkWebView.title;
            }
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    deinit {
        wkWebView.removeObserver(self, forKeyPath: "title")
    }
}

//MARK: - WKNavigationDelegate/Create
extension ShowThirdUrlController:WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        RequestHandler.dismissHUD()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        RequestHandler.dismissHUD()
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        RequestHandler.showHUD()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        RequestHandler.dismissHUD()
    }
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust{
            let card = URLCredential.init(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential,card)
        }
    }
    
    func reloadURL(url:String){
        if let uRL = URL(string: url) {
            wkWebView.load(URLRequest(url: uRL))
        }
    }
}

//MARK: - UI
extension ShowThirdUrlController{
    private func addWKWebView(){
        
        wkWebView.frame = CGRect(x: 0, y: UIScreen.naviBarHeight(), width: UIScreen.width(), height: view.height() - UIScreen.naviBarHeight())
        wkWebView.scrollView.bounces = false
        wkWebView.isOpaque = false
        wkWebView.scrollView.showsVerticalScrollIndicator = false
        wkWebView.scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(wkWebView)
        
    }
    
    private func setUI(){
        leftItem?.setImage(UIImage(named:"btn_close"), for: .normal)
        titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 16)
    }
    

    
    
}
