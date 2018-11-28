//
//  ConfigureManager.swift
//  WaykiApp
//
//  Created by louis on 2018/8/24.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit


enum CoinType:String {
    case wicc = "WICC"
    case token = "WTEST"
    case wicc_F = "WICC_FROZEN" // 代币  代表着冻结（锁仓）的wicc数额
}

// MARK:- 配置主机信息
let netpro = "https://"
let hostName = "xxxxxxxxx"
let port = ""


let isDomestic = true   //是否是国内版
let isMainNet = true    //api连接域名还是ip
let givingWusd = 100     //赠送token数量

let isLimitExchange = true  //是否限制兑换
let limitEXMaxWiccAmount:Double = 1   //限制每次只能兑换1wicc
let limitEXMinWiccAmount:Double = 0.01   //限制兑换最小金额


let appVersion:String =  Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
let channelCode:String = "official"  //预留渠道号

var walletNetConfirure:Int = 0//0:main,1:test   钱包网络配置,主链or测试链//从接口获取


// 配置服务器
func httpPath(path:HTTPPath)->String{
    if isMainNet{
        return netpro+hostName+port+"/api"+path.rawValue
    }
    return  netpro+hostName+port+path.rawValue
    
}


class ConfigureManager: NSObject {
    //必要的配置信息
    class func configure(){
        HttpsManager.validateHTTPS()
        //必须要非强制更新状态下才能进入登陆/注册/主页
        UpdateManager.配置更新 { (isNotForced) in
            //从本地或者网络获取信息
            GetAppInfoManager.getTabbarDetail(success: { (tabbarItems) in
                //清除token
                AccountManager.getAccount().token = ""
                AccountManager.saveAccount(account:  AccountManager.getAccount())
                //获取钱包网络配置
                RequestManager.getWalletConfigure { (str) in

                }
                //进入登陆页
                UIApplication.shared.keyWindow?.rootViewController = LoginWebController()

            })

        }
    
        
    }
}


extension ConfigureManager{
    
    
}
