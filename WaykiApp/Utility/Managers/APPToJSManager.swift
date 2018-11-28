//
//  APPToJSManager.swift
//  WaykiApp
//
//  Created by sorath on 2018/8/28.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

//MARK: - 交互/ios端调用
extension WebViewJavascriptBridge{
  
    func notifyJSViewWillAppear(){
        self.callHandler("notifyJSViewWillAppear")
    }
}
