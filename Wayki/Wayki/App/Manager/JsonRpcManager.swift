//
//  JsonRpcManager.swift
//  Wayki
//
//  Created by louis on 2018/6/23.
//  Copyright © 2018年 wk. All rights reserved.
//

import UIKit

extension Dictionary {
    
    static func wiccBalance(address:String)->[String:Any]{
        return ["jsonrpc":"2.0","id":"curltext","method":"getbalance","params":[address]] as [String:Any]
    }
    
    // MARK:- 区块链信息
    static func blockInformation()->[String:Any]{
        return ["jsonrpc":"2.0","id":"curltext","method":"getblockchaininfo"] as [String:Any]
    }
    
    // MARK:- 账户WICC信息
    static func accountInformation(address:String) ->[String:Any]{
        return ["jsonrpc":"2.0","id":"curltext","method":"getaccountinfo","params":[address]] as [String:Any]
    }
    
    // MARK:- 传输签名 - 激活、转账、投注通用
    static func register(signHex:String)->[String:Any] {
        return ["jsonrpc":"2.0","id":"curltext","method":"submittx","params":[signHex]] as [String:Any]
    }
    
    // MARK:- 账户SPC信息
    static func accountTokenInformation(address:String,contractAddress:String) ->[String:Any]{
        return ["jsonrpc":"2.0","id":"curltext","method":"getappaccinfo","params":[contractAddress,address]] as [String:Any]
    }
    
}

class JsonRpcManager: NSObject {
    
    // 获取WICC余额
    class func getBalance(succeed:@escaping ((Int64,String)->Void),failed:@escaping (String)->Void){
        let address = "Wd647XpXC5rMo6LyupQmXaMv1UTMSNPhtf" // AccountManager.getAccount().address
        let dic = Dictionary<String, Any>.accountInformation(address: address)
        LHRequest.postJsonRPC(url: nodeURL, parameters: dic, success: { (json) in
            print(json)
            if let dic = json.dictionary{
                if let result = dic["result"]?.dictionary{
                    var regessID = ""
                    var balanceC:Int64 = 0
                    if let regID = result["RegID"]?.string { regessID = regID }
                    if let balance = result["Balance"]?.int64 { balanceC = balance }
                    succeed(balanceC,regessID)
                }
            }
        }) { (str) in
            failed("获取账户信息失败".local)
        }
    }
    
    // 获取token余额
    class func getTokenBalance(succeed:@escaping ((Int64)->Void),failed:@escaping (String)->Void){
        
        let address = "Wd647XpXC5rMo6LyupQmXaMv1UTMSNPhtf"//AccountManager.getAccount().address
        
        // 在 http://47.106.77.165:8080/app_apppage.do 查询应用的ID -> 即智能合约的地址
        let dic = Dictionary<String, Any>.accountTokenInformation(address: "19229-1", contractAddress: address)
        LHRequest.postJsonRPC(url: nodeURL, parameters: dic, success: { (json) in
            print(json)
            if let dic = json.dictionary{
                if let result = dic["result"]?.dictionary{
                    var balanceC:Int64 = 0
                    if let balance = result["FreeValues"]?.int64 { balanceC = balance }
                    succeed(balanceC)
                }
            }
        }) { (str) in
            failed("获取账户信息失败".local)
        }
    }
    
    // 获取区块高度
    class func getBlockHeight(succeed:@escaping ((Double)->Void),failed:@escaping (String)->Void){
        let dic = Dictionary<String, Any>.blockInformation()
        LHRequest.postJsonRPC(url: nodeURL, parameters: dic, success: { (json) in
            print(json)
            if let dic = json.dictionary{
                if let result = dic["result"]?.dictionary{
                    var blocks:Double = 0
                    if let blockH = result["blocks"]?.double { blocks = blockH }
                    succeed(blocks)
                }
            }
        }) { (str) in
            failed("获取区块高度失败".local)
        }
    }
    
}
