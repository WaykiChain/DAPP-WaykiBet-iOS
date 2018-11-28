//
//  WalletRequestManager.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/21.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

//MARK: - getInfo
class WalletCommonRequestManager: NSObject {
    //获取regid
    @objc class func getRegIdAndBlock(_ isActivate:@escaping((Bool)->Void)){
        let path:String = httpPath(path: HTTPPath.获取regid_G) + "/" + AccountManager.getAccount().address
        //utf8编码
        RequestHandler.get(url: path,parameters: [:],runHUD: .none, success: { (json) in
            if let dic = json.dictionary{
                if let dataDic = dic["data"]?.dictionaryValue{
                    var isActive = false
                    var regId = ""
                    if let val = dataDic["active"]?.boolValue{
                        isActive = val
                    }
                    if let val = dataDic["regId"]?.stringValue{
                        regId = val
                    }

                    if isActive&&regId.count>2{
                        let account:NewAccount = AccountManager.getAccount()
                        account.regId = regId
                        AccountManager.saveAccount(account: account)
                    }
                    isActivate(isActive)
                }
                
            }
        }) { (error) in
            UILabel.showFalureHUD(text: error)
        }
    }
    //获取regid
    @objc class func getRegId(){
        getRegIdAndBlock { (isActivate) in
            
        }
    }
    
    //获取最新区块高度
    class func getVaildHeight(success: @escaping ((_ vaildHeight:Double)->Void)){
        
        let path:String = httpPath(path: HTTPPath.获取最新区块高度_G)
        RequestHandler.get(url: path,parameters: [:],runHUD: .loading, success: { (json) in
            if let dic = json.dictionary{
                if let height = dic["data"]?.intValue{
                    let blockHeight = Double(height)
                    let account:NewAccount = AccountManager.getAccount()
                    account.validHeight = blockHeight
                    AccountManager.saveAccount(account: account)
                    success(blockHeight)
                }
                
            }
            
        }) { (error) in
            UILabel.showFalureHUD(text: error)
        }
    }
    
    
    //获取合约信息
    class func getContractInfo(success:@escaping((ContractModel)->Void)){
        let path:String = httpPath(path: HTTPPath.获取合约地址_G)
        
        RequestHandler.get(url: path,parameters: [:],runHUD: .loading, success: { (json) in
            if let dic = json.dictionary{
                if let dataArr = dic["data"]?.arrayValue{
                    let models = ContractModel.getModels(arr: dataArr)
                    for model in models{
                        if model.coinSymbol == CoinType.token.rawValue{
                          ContractManager.saveWUSDContractModel(model: model)
                            success(model)
                            break
                        }
                    }
                }
                
            }
            
        }) { (error) in
            UILabel.showFalureHUD(text: error)
        }
    }

}


