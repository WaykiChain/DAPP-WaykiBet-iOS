//
//  RequestManager.swift
//  WaykiApp
//
//  Created by sorath on 2018/8/28.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

enum HTTPPath:String {
    case 获取资产汇总_G = " "
    case 版本检测升级_P = ""
    //
    case 查询底部菜单 = ""
    case 获取当前配置环境_G = ""
    case 获取wicc链接_G = ""
    
    case 获取汇率_G = ""
    case 获取wtest汇率_G = ""
    case 获取wusd汇率_G = ""
    
    case 获取账户信息_G = ""
    case token兑换wicc手续费_G = ""
    case wicc兑换token_P = ""
    case token兑换wicc_P = ""
    case 获取兑换记录_P = ""
    
    case 获取手机绑定钱包_P = ""
    case 绑定钱包_P = ""
    
    case 获取regid_G = ""
    case 获取最新区块高度_G = ""
    
    case 转账和激活_P = ""
    case 获取合约地址_G = ""
    
    case 获取交易记录_P = "s"
    case 获取交易详情_G = ""
    
    case 检查获取奖励_P = ""

}

class RequestManager: NSObject {
    //获取钱包网络配置
    class func getWalletConfigure(success: @escaping((String) ->Void)){
        let path:String = httpPath(path: .获取当前配置环境_G)
        RequestHandler.get(url: path, parameters: [:], runHUD:.none,isNeedToken:false,success: { (json) in
            if let dic = json.dictionary{
                if let data = dic["data"]?.stringValue{
                    if data == "test"{
                        walletNetConfirure = 1
                    }
                    success(data)
                }
            }
            
        }) { (error) in
            
        }
    }
    
}

