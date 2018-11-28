//
//  JSToAppNotifyManager.swift
//  WaykiApp
//
//  Created by sorath on 2018/10/26.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit
import Photos

//MARK: - 交互/ios端注册--行为
extension WebViewJavascriptBridge{
    //*********************************行为*******************************************//
    //通知app发起登出
    func notifyAppSignOut(){
        self.registerHandler("notifyAppSignOut") { (data, callBlock) in
            var isSignOut = "0"
            //登出先清除token
            let account = AccountManager.getAccount()
            account.token = ""
            AccountManager.saveAccount(account: account)
            //更换根控制器到登陆页
            let c = LoginWebController()
            UIApplication.shared.keyWindow?.rootViewController = c
            
            if UIApplication.shared.keyWindow?.rootViewController is LoginWebController{
                isSignOut = "1"
            }
            let dic = ["isComplete":isSignOut]
            self.returnCallBlock(callBlock: callBlock, dic: dic)
        }
    }
    
    //通知app登陆完成（需传递参数）
    func notifyAppLogined(){
        self.registerHandler("notifyAppLogined") { (data, callBlock) in
            var isComplete = "0"
            var phone:String = ""
            var token:String = ""
            var areaCode:String = ""
            let responseDic = data as! Dictionary<String, Any>
            if let phoneNum = responseDic["phoneNum"] {
                if phoneNum is String{
                    phone = phoneNum as! String
                    isComplete = "1"
                }
            }
            if let tokenStr = responseDic["token"] {
                if tokenStr is String{
                    token = tokenStr as! String
                    isComplete = "1"
                }
            }
            if let v = responseDic["areaCode"] {
                if v is String{
                    areaCode = v as! String
                    isComplete = "1"
                }
            }
            
            
            //检测是否已绑定本地钱包,没有则清除并赋值token和手机号,有则更新token，如果帐号没有绑定过钱包，则弹出导入、创建钱包alert
            BindWalletManager.checkBindOrClear(phone: phone, token: token, areaCode: areaCode)
            
            //从本地或者后端获取tabbar的信息
            GetAppInfoManager.getTabbarDetail(success: { (tabbarItems) in
                UIApplication.shared.keyWindow?.rootViewController = BaseTabBarController().build(datas: tabbarItems)
            })
            
            let dic = ["isComplete":isComplete]
            self.returnCallBlock(callBlock: callBlock, dic: dic)
        }
    }
    
    //通知app注册完成（需传递参数）
    func notifyAppRegister(){
        self.registerHandler("notifyAppRegister") { (data, callBlock) in
            var isComplete = "0"
            var phone:String = ""
            var token:String = ""
            var areaCode:String = ""

            let responseDic = data as! Dictionary<String, Any>
            if let phoneNum = responseDic["phoneNum"] {
                if phoneNum is String{
                    phone = phoneNum as! String
                    isComplete = "1"
                }
            }
            if let tokenStr = responseDic["token"] {
                if tokenStr is String{
                    token = tokenStr as! String
                    isComplete = "1"
                }
            }
            
            if let v = responseDic["areaCode"] {
                if v is String{
                    areaCode = v as! String
                    isComplete = "1"
                }
            }
            //检测是否已绑定本地钱包,没有则清除并赋值token和手机号,有则更新token，如果帐号没有绑定过钱包，则弹出导入、创建钱包alert
            BindWalletManager.checkBindOrClear(phone: phone, token: token, areaCode: areaCode)
            
            //从本地或者后端获取tabbar的信息
            GetAppInfoManager.getTabbarDetail(success: { (tabbarItems) in
                UIApplication.shared.keyWindow?.rootViewController = BaseTabBarController().build(datas: tabbarItems)
                let c = CreateWalletVC()
                c.isFromRegister = true
                UIApplication.shared.keyWindow?.rootViewController?.present(c, animated: true, completion: nil)
            })
            
            let dic = ["isComplete":isComplete]
            self.returnCallBlock(callBlock: callBlock, dic: dic)
        }
    }
    
    //通知app 前往创建钱包
    func notifyAppCreateWallet(){
        self.registerHandler("notifyAppCreateWallet") { (data, callBlock) in
            var isComplete = "0"
            if Tools.getTabber() != nil{
                isComplete = "1"
                let c = CreateWalletVC()
                UIApplication.shared.keyWindow?.rootViewController?.present(c, animated: true, completion: nil)
            }
            
            let dic = ["isComplete":isComplete]
            self.returnCallBlock(callBlock: callBlock, dic: dic)
        }
    }
    
    //通知app 前往导入钱包
    func notifyAppImportWallet(){
        self.registerHandler("notifyAppImportWallet") { (data, callBlock) in
            var isComplete = "0"
            if Tools.getTabber() != nil{
                isComplete = "1"
                let c = ImportWalletVC()
                UIApplication.shared.keyWindow?.rootViewController?.present(c, animated: true, completion: nil)
            }
            
            let dic = ["isComplete":isComplete]
            self.returnCallBlock(callBlock: callBlock, dic: dic)
        }
    }
    
    //通知app push
    func notifyAppPush(){
        self.registerHandler("notifyAppPush") { (data, callBlock) in
            if Tools.getTabber() != nil{
                
                let responseDic = data as! Dictionary<String, Any>
                if let url:String = responseDic["url"] as? String{
                    let baseurl = netpro+hostName+port+"/"
                    let pathUrl = baseurl + url
                    let nav = Tools.getTabber()?.selectedNAV
                    let newClass:AnyClass = object_getClass(nav?.viewControllers.first)!
                    if newClass is BaseWebController.Type{
                        let nC = newClass as! BaseWebController.Type
                        let vc = nC.init()
                        vc.url = pathUrl
                        vc.hidesBottomBarWhenPushed = true
                        nav?.pushViewController(vc, animated: true)
                    }
                    
                }
            }
            
            let dic = ["isComplete":"1"]
            self.returnCallBlock(callBlock: callBlock, dic: dic)
        }
    }
    
    //通知app pop
    func notifyAppPop(){
        self.registerHandler("notifyAppPop") { (data, callBlock) in
            var isReload = false
            var isPopToNum = false
            var popNum = 0
            if let responseDic:Dictionary<String,String> = data as? Dictionary<String, String>{
                var isRefresh:String = ""
                if let v = responseDic["isRefresh"]{
                    isRefresh = v
                }
                if isRefresh == "1"{
                    isReload = true
                }
                
                if let v = responseDic["popNum"]{
                    isPopToNum = true
                    popNum = v.toInt()
                }
                
            }
            if Tools.getTabber() != nil{
                let nav = Tools.getTabber()?.selectedNAV
                var popVC:UIViewController?
                if isPopToNum{
                    //存在选定pop数,则跳转
                    if (nav?.viewControllers.count)! > popNum{
                        popVC = nav?.viewControllers[popNum]
                    }
                } else if (nav?.viewControllers.count)!>1{
                    popVC = nav?.viewControllers[(nav?.viewControllers.count)!-2]
                }
                
                if isReload == true{
                    if popVC != nil{
                        if popVC is BaseWebController{
                            let c = popVC as! BaseWebController
                            c.wkWebView.reload()
                        }
                    }
                }
                
                if popVC != nil{
                    nav?.popToViewController(popVC!, animated: true)
                }
                
            }
            let dic = ["isComplete":"1"]
            self.returnCallBlock(callBlock: callBlock, dic: dic)
        }
    }
    
    //通知app 保存图片
    func notifyAppSaveImage(){
        self.registerHandler("notifyAppSaveImage") { (data, callBlock) in
            let requestDic = data as! Dictionary<String,Any>
            var imageBase64 = requestDic["image"] as! String
            //去除base64 编码的前缀
            if imageBase64.contains("data:image/png;base64,"){
                imageBase64 = imageBase64.subString(from: "data:image/png;base64,".length)
                
            }
            
            let imageData = Data(base64Encoded: imageBase64, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
            if let image = UIImage(data: imageData!){
                PHPhotoLibrary.shared().performChanges({
                    _ = PHAssetChangeRequest.creationRequestForAsset(from: image)
                    
                }, completionHandler: { (isSuccess, error) in
                    if isSuccess{
                        UILabel.showSucceedHUD(text: "保存成功".local)
                        let dic = ["isComplete":"1"]
                        self.returnCallBlock(callBlock: callBlock, dic: dic)
                    }else{
                        UILabel.showFalureHUD(text: "保存失败".local)
                        let dic = ["isComplete":"0"]
                        self.returnCallBlock(callBlock: callBlock, dic: dic)
                    }
                    
                })
            }
            
        }
    }
    
    //通知app 检测钱包是否绑定(如果不存在，弹出框导入或者创建)
    func notifyAppCheckAddress(){
        self.registerHandler("notifyAppCheckAddress") { (data, callBlock) in
            var isExist = "0"
            
            BindWalletManager.checkAccountIsBind(complete: { (isExisted) in
                isExist = "1"
                let dic = ["isExist":isExist]
                self.returnCallBlock(callBlock: callBlock, dic: dic)
            })
            
        }
    }
    
    
    //通知APP（从竞猜页） 跳转至钱包页面
    func notifyAppJumpWallet(){
        self.registerHandler("notifyAppJumpWallet") { (data, callBlock) in
            var isComplete = "0"
            if Tools.getTabber() != nil{
                let nav = Tools.getTabber()?.selectedNAV
                nav?.viewControllers = [nav?.viewControllers.first] as! [UIViewController]
                
                for i in  0..<(Tools.getTabber()?.viewControllers?.count)!{
                    let vc = Tools.getTabber()?.viewControllers![i]
                    if vc is UINavigationController{
                        let nav:UINavigationController = vc as! UINavigationController
                        if nav.viewControllers.first is WalletVC{
                            Tools.getTabber()?.selectedIndex = i
                            nav.popToRootViewController(animated: true)
                            isComplete = "1"
                            break
                        }
                    }
                }
                
            }
            let dic = ["isComplete":isComplete]
            self.returnCallBlock(callBlock: callBlock, dic: dic)
        }
    }
    
    //通知app加载第三方url的页面
    func notifyAppjumpThirdUrl(){
        self.registerHandler("notifyAppjumpThirdUrl") { (data, callBlock) in
            if Tools.getTabber() != nil{
                
                let responseDic = data as! Dictionary<String, Any>
                if let url:String = responseDic["url"] as? String{
                    let nav = Tools.getTabber()?.selectedNAV
                    if nav?.presentedViewController == nil{
                        let vc = ShowThirdUrlController()
                        vc.url = url
                        vc.hidesBottomBarWhenPushed = true
                        nav?.pushViewController(vc, animated: true)
                    }else if nav?.presentedViewController is UINavigationController{
                        let showNav = nav?.presentedViewController as! UINavigationController
                        let vc = ShowThirdUrlController()
                        vc.url = url
                        vc.hidesBottomBarWhenPushed = true
                        showNav.pushViewController(vc, animated: true)
                    }
                    
                }
            }
            let dic = ["isComplete":"1"]
            self.returnCallBlock(callBlock: callBlock, dic: dic)
        }
    }
}
