//
//  BaseWebController.swift
//  WaykiApp
//
//  Created by louis on 2018/8/24.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

protocol BaseWebViewProtocol {
    
}

@objc class BaseWebController: UIViewController {
    var wkWebView: WKWebView = WKWebView.init()
    private let reachability = Reachability()!
    var networkStatus:Bool = false
    var networkConnectNum = 0
    
    var bridge:WebViewJavascriptBridge?
    var provider:String = NSStringFromClass(BaseProvider.self)    //对应界面的提供者classname
    var url:String = ""
    
    fileprivate var isFirst:Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.bgColor();
        createWKWebView()
        view.addSubview(wkWebView)
        //设置bridge
        setupBridge()
        //网络检测
        networkStatusListener()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //如果不是第一次进入，则每次调用js
        if isFirst{
            isFirst = false
        }else{
            if url.count>0 {
                bridge?.notifyJSViewWillAppear()
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var headHeight:CGFloat = 20
        if UIDevice.isX(){
            headHeight = 44
        }
        wkWebView.frame = CGRect(x: 0, y: headHeight, width: UIScreen.width(), height: view.height() - headHeight)

    }
    
    // 移除消息通知
    deinit {
        // 关闭网络状态消息监听
        reachability.stopNotifier()
        // 移除网络状态消息通知
        NotificationCenter.default.removeObserver(self)
        if bridge != nil{
            if let proClass =  NSClassFromString(provider).self{
                if proClass is BaseProvider.Type{
                    let pC = proClass as! BaseProvider.Type
                    pC.bridgeRemove(bridge: bridge!)
                    return
                }
            }
            BaseProvider.bridgeRemove(bridge: bridge!)
        }
    }
}

//MARK: - WKNavigationDelegate
extension BaseWebController:WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
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

    
    func createWKWebView(){
        var headHeight:CGFloat = 20
        if UIDevice.isX(){
            headHeight = 44
        }
        //2.使用创建的单例WKProcessPool
        let configuration = WKWebViewConfiguration.init()
        
        let userController = WKUserContentController.init()
        configuration.userContentController = userController
        
        //使用单例 解决locastorge 储存问题
        configuration.processPool = EKWWKProcessPool.sharedProcessPool
        
        let preferences = WKPreferences.init()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.preferences = preferences
        
        wkWebView = WKWebView.init(frame: CGRect.zero, configuration: configuration)
        
        wkWebView.frame = CGRect(x: 0, y: headHeight, width: UIScreen.width(), height: view.height() - headHeight)
        wkWebView.scrollView.bounces = false
        wkWebView.backgroundColor = UIColor.bgColor()
        wkWebView.scrollView.backgroundColor = UIColor.bgColor()
        wkWebView.isOpaque = false
        wkWebView.scrollView.showsVerticalScrollIndicator = false
        wkWebView.scrollView.showsHorizontalScrollIndicator = false
        wkWebView.allowsBackForwardNavigationGestures = true

    }
}


//MARK: - WKWebViewConfiger
extension BaseWebController{
    //设置与js交互的bridge和处理事件
    func setupBridge(){
        bridge = bridgeForWebView(wkWebView)
        //设置delegate
        bridge?.setWebViewDelegate(self)
        //将与h5交互的 事件交给Provider处理
        //判断是否有指定处理类
        if let proClass =  NSClassFromString(provider).self{
            if proClass is BaseProvider.Type{
                let pC = proClass as! BaseProvider.Type
                pC.empower(jsbridge: bridge!)
                return
            }
        }
        BaseProvider.empower(jsbridge: bridge!)


    }
    
    func bridgeForWebView(_ webView: Any) -> WebViewJavascriptBridge {
        let bridge = WebViewJavascriptBridge.init(webView)!
        bridge.setWebViewDelegate(webView)
        return bridge
    }
    
    func reloadURL(url:String){
        wkWebView.load(URLRequest(url: URL(string: url)!))
    }
}

//MARK： - Reachability
//Reachability
extension BaseWebController{
    //开始监听
    private func networkStatusListener() {
        // 1、设置网络状态消息监听 2、获得网络Reachability对象
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: Notification.Name.reachabilityChanged,object: reachability)
        do{
            // 3、开启网络状态消息监听
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
    }
    
    // 主动检测网络状态
    @objc func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability // 准备获取网络连接信息
        
        if reachability.connection != .none { // 判断网络连接状态
            if networkStatus == false&&networkConnectNum != 0{
                //从无网环境切换回来时，刷新webview
                networkStatus = true
                //如果wkwebview没有加载出来（url为空），那么重新加载url
                if wkWebView.url == nil{
                    reloadURL(url: url)
                }else{
                    wkWebView.reload()
                }
            }
            
        } else {
            networkStatus = false
            DispatchQueue.main.async { // 不加这句导致界面还没初始化完成就打开警告框，这样不行
                UILabel.showFalureHUD(text: "网络连接失败，请稍后再试")
            }
        }
        networkConnectNum = networkConnectNum + 1
    }
    
}


//MARK: - ProcessPool
//1. 创建单利WKProcessPool
class EKWWKProcessPool: WKProcessPool {
    class var sharedProcessPool: EKWWKProcessPool {
        struct Static {
            static let instance: EKWWKProcessPool = EKWWKProcessPool()
        }
        
        return Static.instance
    }
}

