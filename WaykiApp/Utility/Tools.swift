//
//  Tools.swift
//  WaykiApp
//
//  Created by sorath on 2018/8/28.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit



let scale:CGFloat = UIScreen.width()/375
/// 缩放比例


class Tools: NSObject {
    class func getTabber() ->BaseTabBarController?{
    
        if UIApplication.shared.keyWindow?.rootViewController is BaseTabBarController {
            return UIApplication.shared.keyWindow?.rootViewController as? BaseTabBarController
        }
        return nil
    }
    
    //获取钱包网络配置
    @objc class func getWalletConfigure() ->Int{
        return walletNetConfirure
    }
    
    
    
}
