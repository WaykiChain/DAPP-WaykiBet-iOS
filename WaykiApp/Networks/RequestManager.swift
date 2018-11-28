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
    case 版本检测升级_P = "/app/upgrade"
    //
    case 查询底部菜单 = "/sys/tab/menu/list/2"
    case 获取当前配置环境_G = "/sys/getEnvironmentType"
    case 获取wicc链接_G = "/sys/link"
    
    case 获取汇率_G = "/sys/exchange/rate"
    case 获取wtest汇率_G = "sys/exchange/WTEST/rate"
    case 获取wusd汇率_G = "sys/exchange/WUSD/rate"
    
    case 获取账户信息_G = "/customer/account/getinfo"
    case token兑换wicc手续费_G = "/sys/miner/fee"
    case wicc兑换token_P = "/exchange/trans/wicc/token"
    case token兑换wicc_P = "/exchange/trans/token/wicc"
    case 获取兑换记录_P = "/exchange/exchangeOrders"
    
    case 获取手机绑定钱包_P = "/customer/ref/wallet/info"
    case 绑定钱包_P = "/customer/bind/wallet"
    
    case 获取regid_G = "/address/isActive"
    case 获取最新区块高度_G = "/chain/height"
    
    case 转账和激活_P = "/exchange/trans/wicc"
    case 获取合约地址_G = "/exchange/contract"
    
    case 获取交易记录_P = "/customer/account/log/logs"
    case 获取交易详情_G = "/customer/account/log/detail"
    
    case 检查获取奖励_P = "/walletaddress/sys/reward/list"

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

