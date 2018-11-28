 //
//  ExchangeManager.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/19.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

class ExchangeManager: NSObject {
    //wusd买卖
    enum direction: Int {
        case buy = 100  //买wicc
        case sell = 200 //卖wicc
    }
    
    //开始wicc兑换wusd的逻辑
    class func startWICCToWUSD(exDetailModel:EXDetailModel,complete:@escaping((Bool)->Void)){
        if ContractManager.getWUSDContractModel().contractAddressRegId == ""{
            UILabel.showFalureHUD(text: "合约地址为空".local)
            return
        }
        let helpStr = AccountManager.getAccount().getHelpString(password: exDetailModel.pwd)
        WalletCommonRequestManager.getVaildHeight { (height) in
//            print("rate is",exDetailModel.rate,"wicc is ",exDetailModel.leftN,"token is ",exDetailModel.rightN)
            let arr = Bridge.getExchangeHex(withHelpStr: helpStr, blockHeight: height, regessID: AccountManager.getAccount().regId, destAddr: ContractManager.getWUSDContractModel().contractAddressRegId, exchangeValue: exDetailModel.leftN, fee: exDetailModel.fee, rate: exDetailModel.rate, exchangeToken: exDetailModel.rightN)
            let hex = arr?.first as! String
            let contract = arr?.last as! String
            requestWICCExchangeWUSD(signHex: hex,contract: contract, remark: "", wiccAddress: AccountManager.getAccount().address, contractAddress:ContractManager.getWUSDContractModel().contractAddress,fee:exDetailModel.fee ,wiccCount:exDetailModel.leftN,exchangeRate:exDetailModel.rate,tokenCount:exDetailModel.rightN,complete: { (isSuccess) in
                complete(isSuccess)
            })
        }
        
    }
    
    //开始wusd兑换wicc的逻辑
    class func startWUSDToWICC(exDetailModel:EXDetailModel,complete:@escaping((Bool)->Void)){
        if ContractManager.getWUSDContractModel().contractAddressRegId == ""{
            UILabel.showFalureHUD(text: "合约地址为空".local)
            return
        }
        requestWUSDExchangeWICC(address: AccountManager.getAccount().address, price: exDetailModel.rate, tokenAmount: exDetailModel.leftN, tokenFee: exDetailModel.fee, wiccAmount: exDetailModel.rightN,contractAddress:ContractManager.getWUSDContractModel().contractAddress) { (isSuccess) in
            complete(isSuccess)
        }
    }
    
    
}


//MARK: - networks
extension ExchangeManager{
    //发起wicc兑换wusd的接口
    class func requestWICCExchangeWUSD(signHex:String,contract:String,remark:String,wiccAddress:String,contractAddress:String,fee:Double,wiccCount:Double,exchangeRate:Double,tokenCount:Double,complete:@escaping((Bool)->Void)){
        let path = httpPath(path: .wicc兑换token_P)
        let requestDic = [
            "coinSymbol": CoinType.token.rawValue,
            "contractAddress": contractAddress,
            "rawtx": signHex,
            "txRemark": remark,
            "wiccAddress": wiccAddress,
            "requestContract":contract,
            "fee":fee,
            "wiccCount":wiccCount,
            "exchangeRate":exchangeRate,
            "tokenCount":tokenCount
            ] as [String : Any]
        
        let jsonS = String.getJSONStringFromDictionary(dictionary:requestDic as NSDictionary)
        print("jsonS is ",jsonS)
        RequestHandler.post(url: path, parameters: requestDic, runHUD: .loading, isNeedToken: true, success: { (json) in
            complete(true)

        }) { (error) in
            complete(false)
            UILabel.showFalureHUD(text: error)
            
        }
    }
       
    
    //发起wusd兑换wicc的接口
    class func requestWUSDExchangeWICC(address:String,price:Double,tokenAmount:Double,tokenFee:Double,wiccAmount:Double,contractAddress:String,complete:@escaping((Bool)->Void)){
        let path = httpPath(path: .token兑换wicc_P)
        let wiccTowusdRate = 1.0/price
        let requestDic = [
            "contractAddress": contractAddress,
            "direction": direction.buy.rawValue,
            "price": wiccTowusdRate,
            "token": CoinType.token.rawValue,
            "tokenAmount": tokenAmount,
            "txTokenFee": tokenFee,
            "wiccCount": wiccAmount,
            "wiccAddress":address
            ] as [String : Any]
        
        let jsonS = String.getJSONStringFromDictionary(dictionary:requestDic as NSDictionary)
        print("jsonS is ",jsonS)
        RequestHandler.post(url: path, parameters: requestDic,runHUD: .loading, isNeedToken: true, success: { (json) in
            complete(true)
        }) { (error) in
            complete(false)
            UILabel.showFalureHUD(text: error)
        }
        

    }
    
    

    

}
