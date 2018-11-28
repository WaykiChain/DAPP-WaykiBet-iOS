//
//  LoginProvider.swift
//  WaykiApp
//
//  Created by louis on 2018/8/24.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

@objcMembers class LoginWebProvider: BaseProvider{
    @objc override class  func bridgeRegister(bridge: WebViewJavascriptBridge) {
        super.bridgeRegister(bridge: bridge)
    }
    override class func empower(jsbridge:WebViewJavascriptBridge){
        bridgeRegister(bridge: jsbridge)
    }
}
