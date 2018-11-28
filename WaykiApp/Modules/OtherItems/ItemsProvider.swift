//
//  ItemsProvider.swift
//  WaykiApp
//
//  Created by sorath on 2018/10/15.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

@objcMembers class ItemsProvider: BaseProvider{
    @objc override class  func bridgeRegister(bridge: WebViewJavascriptBridge) {
        super.bridgeRegister(bridge: bridge)
    }
    override class func empower(jsbridge:WebViewJavascriptBridge){
        bridgeRegister(bridge: jsbridge)
    }
}
