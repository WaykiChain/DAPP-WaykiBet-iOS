//
//  BaseProvider.swift
//  WaykiApp
//
//  Created by louis on 2018/8/24.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

protocol BaseProviderProtocol{
    static func empower(jsbridge:WebViewJavascriptBridge)
    static func bridgeRegister(bridge:WebViewJavascriptBridge)
}

class BaseProvider: NSObject,BaseProviderProtocol {
    //授权与js交互
    class func empower(jsbridge:WebViewJavascriptBridge){
        bridgeRegister(bridge: jsbridge)
    }

}

//MARK: - 基础交互/ios端注册
extension BaseProvider {
    @objc class func bridgeRegister(bridge:WebViewJavascriptBridge){
        //获取信息
        bridge.getAppLanguage()
        bridge.getToken()
        bridge.getAddress()
        bridge.getAppChannelNo()
        bridge.getUUID()
        bridge.getPhoneNum()
        bridge.getAppVersion()
        bridge.getFirst()

        //注册行为
        bridge.notifyAppLogined()
        bridge.notifyAppSignOut()
        bridge.notifyAppCreateWallet()
        bridge.notifyAppImportWallet()
        bridge.notifyAppPush()
        bridge.notifyAppPop()
        bridge.notifyAppSaveImage()
        bridge.notifyAppCheckAddress()
        bridge.notifyAppJumpWallet()
        bridge.notifyAppRegister()
        bridge.notifyAppjumpThirdUrl()
    }
    
    @objc class func bridgeRemove(bridge:WebViewJavascriptBridge){
        bridge.removeHandler("getAppLanguage")
        bridge.removeHandler("getToken")
        bridge.removeHandler("getAddress")
        bridge.removeHandler("getAppChannelNo")
        bridge.removeHandler("getUUID")
        bridge.removeHandler("getPhoneNum")
        bridge.removeHandler("getAppVersion")
        bridge.removeHandler("getFirst")
        
        bridge.removeHandler("notifyAppLogined")
        bridge.removeHandler("notifyAppSignOut")
        bridge.removeHandler("notifyAppCreateWallet")
        bridge.removeHandler("notifyAppImportWallet")
        bridge.removeHandler("notifyAppPush")
        bridge.removeHandler("notifyAppPop")
        bridge.removeHandler("notifyAppSaveImage")
        bridge.removeHandler("notifyAppCheckAddress")
        bridge.removeHandler("notifyAppJumpWallet")
        bridge.removeHandler("notifyAppRegister")
        bridge.removeHandler("notifyAppjumpThirdUrl")

    }
}

