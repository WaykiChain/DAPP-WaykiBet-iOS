//
//  JSToAppGetManager.swift
//  WaykiApp
//
//  Created by sorath on 2018/10/26.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

//MARK: - 交互/ios端注册--获取信息
extension WebViewJavascriptBridge{
    //*********************************获取*******************************************//
    //获取地址
    func getAddress(){
        self.registerHandler("getAddress") { (data, callBlock) in
            var address:String = ""
            
            let account = AccountManager.getAccount()
            if account.address.count>10{
                address = account.address
                
            }
            
            let dic = ["address":address]
            self.returnCallBlock(callBlock: callBlock, dic: dic)
        }
        
    }
    
    //获取手机号
    func getPhoneNum(){
        self.registerHandler("getPhoneNum") { (data, callBlock) in
            var phoneNum:String = ""
            var areaCode:String = ""
            if AccountManager.getAccount().phoneNum.count>0{
                phoneNum = AccountManager.getAccount().phoneNum
            }
            areaCode = AccountManager.getAccount().areaCode
            let dic = ["phoneNum":phoneNum,"areaCode":areaCode]
            self.returnCallBlock(callBlock: callBlock, dic: dic)
        }
    }
    
    func getToken(){
        self.registerHandler("getToken") { (data, callBlock) in
            var token:String = ""
            let account = AccountManager.getAccount()
            if account.token.count>1{
                token = account.token
            }
            
            let dic = ["token":token]
            self.returnCallBlock(callBlock: callBlock, dic: dic)
        }
        
    }
    
    //获取app语言
    func getAppLanguage(){
        self.registerHandler("getAppLanguage") { (data, callBlock) in
            //            print(data)
            var systemLan:String = "1"
            if "localLanguage".local == "0"{
                systemLan = "0"
            }else if "localLanguage".local == "1"{
                systemLan = "1"
            }else if "localLanguage".local == "2"{
                systemLan = "2"
            }
            let dic = ["language":systemLan]
            self.returnCallBlock(callBlock: callBlock, dic: dic)
        }
    }
    
    //获取钱包渠道号
    func getAppChannelNo(){
        self.registerHandler("getAppChannelNo") { (data, callBlock) in
            
            self.returnCallBlock(callBlock: callBlock, dic: ["channelNo":channelCode])
            
        }
    }
    
    //获取钱包渠道号
    func getAppVersion(){
        self.registerHandler("getAppVersion") { (data, callBlock) in
            self.returnCallBlock(callBlock: callBlock, dic: ["version":appVersion])
        }
    }
    //获取app UUID
    func getUUID(){
        self.registerHandler("getUUID") { (data, callBlock) in
            let uuid = UUIDTool.getUUIDInKeychain()
            self.returnCallBlock(callBlock: callBlock, dic: ["UUID":uuid])
        }
    }
    
    func getFirst(){
        self.registerHandler("getFirst") { (data, callBlock) in
            let isfirst = AlterManager.isFirstLaunch()
            self.returnCallBlock(callBlock: callBlock, dic: ["isfirst":isfirst])
            
        }
    }
    
}


extension WebViewJavascriptBridge{
    func returnCallBlock(callBlock:WVJBResponseCallback?,dic:[String:Any]){
        if callBlock != nil {
            callBlock!(dic)
        }
    }
}
