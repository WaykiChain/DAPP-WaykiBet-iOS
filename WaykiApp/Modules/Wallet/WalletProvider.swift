//
//  WalletProvider.swift
//  WaykiApp
//
//  Created by louis on 2018/8/24.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

class WalletProvider: NSObject {

}


//MARK: - Networks
extension WalletProvider{
    //获取wicc和wusd之间的汇率
    class func requestRate(success:@escaping((Double,Double)->Void)){
        let path:String
        if isDomestic{
            path = httpPath(path: .获取wtest汇率_G)
        }else{
            path = httpPath(path: .获取wusd汇率_G)
        }
        RequestHandler.get(url: path, parameters: [:], success: { (json) in
            if let dic = json.dictionary{
                if let dataDic = dic["data"]?.dictionaryValue{
                    var u2WRate:Double = 0
                    var w2URate:Double = 0
            
                    if let rate = dataDic["wicc2TokenRateUp"]?.doubleValue{
                        u2WRate = 1.0/rate
                    }
                    if let rate = dataDic["wicc2TokenRateDown"]?.doubleValue{
                        w2URate = rate
                    }
                    
                    success(w2URate,u2WRate)
                }
            }
            
        }) { (error) in
            UILabel.showFalureHUD(text: error)
        }
    }
    
    //获取账户信息
    class func requestAccountInfo(success:@escaping((BalanceModel)->Void)){
        let path = httpPath(path: .获取账户信息_G)
        RequestHandler.get(url: path, parameters: [:], runHUD: HUDStyle.none, isNeedToken: true, success: { (json) in
            let model = BalanceModel()
            model.analysisData(json: json)
            success(model)
        }) { (error) in
            UILabel.showFalureHUD(text: error)
        }
        
    }
    
    //获取手续费范围信息
    class func requestFeeScope(success:@escaping((CoinScopeFeeModel)->Void)){
        
        let path = httpPath(path: .token兑换wicc手续费_G)
        RequestHandler.get(url: path, parameters: [:], success: { (json) in
            if let dic = json.dictionary{
                if let dataDic = dic["data"]?.dictionary{
                    let model = CoinScopeFeeModel()
                    if let min = dataDic["min"]?.doubleValue{
                        model.min = min
                    }
                    if let max = dataDic["max"]?.doubleValue{
                        model.max = max
                    }
                    success(model)
                }
            }
          
        }) { (error) in
            UILabel.showFalureHUD(text: error)
        }
    }
    
    //获取wicc链接
    class func getWiccLink(success:@escaping((String)->Void)){
        let path = httpPath(path: HTTPPath.获取wicc链接_G) + "/100"
        RequestHandler.get(url: path, parameters: [:], runHUD: HUDStyle.loading, isNeedToken: true, success: { (json) in
            if let dic = json.dictionary{
                if let dataDic = dic["data"]?.dictionary{
                    
                    if let v = dataDic["linkUrl"]?.stringValue{
                        success(v)
                    }
                    
                }
            }
        }) { (error) in
            UILabel.showFalureHUD(text: error)
        }

    }
    
}

class BalanceModel:NSObject{
    
    var customerAccountList:[CoinInfoModel] = []
    
    var wiccModel:CoinInfoModel = CoinInfoModel()
    var tokenModel:CoinInfoModel = CoinInfoModel()
    var wiccFrozenModel:CoinInfoModel = CoinInfoModel()
    
    func analysisData(json:JSON){
        if let dic = json.dictionary{
            if let dataDic = dic["data"]?.dictionary{
                if let arr = dataDic["customerAccountList"]?.array{
                    customerAccountList = CoinInfoModel.getModels(arr: arr)
                    for model in customerAccountList{
                        if model.coinSymbol == CoinType.wicc.rawValue{wiccModel = model}
                        if model.coinSymbol == CoinType.token.rawValue{tokenModel = model}
                        if model.coinSymbol == CoinType.wicc_F.rawValue{wiccFrozenModel = model}
                    }
                }
            }
        }
    }
    
}


//币种信息model
class CoinInfoModel:NSObject{
    var address: String = ""
    var status: Int = 0
    var balanceReserved: Double = 0
    var memo: String = ""
    var id: Int = 0
    var coinSymbol: String = ""
    var createdAt: String = ""
    var balanceAvailable: Double = 0
    var updatedAt: String = ""
    var priceCNY:Double = 0
    
    class func getModels(arr:[JSON])->[CoinInfoModel]{
        var models:[CoinInfoModel] = []
            for lo in arr {
                let model = CoinInfoModel()
                model.analysisData(json:lo)
                models.append(model)
            }
        return models
    }
    

    func analysisData(json:JSON){
        address = json["address"].stringValue
        status = json["status"].intValue
        balanceReserved = json["balanceReserved"].doubleValue
        balanceAvailable = json["balanceAvailable"].doubleValue
        memo = json["memo"].stringValue
        id = json["id"].intValue
        coinSymbol = json["coinSymbol"].stringValue
        createdAt = json["createdAt"].stringValue
        updatedAt = json["updatedAt"].stringValue
        priceCNY = json["priceCNY"].doubleValue
    }
}

//币种手续费范围
@objcMembers class CoinScopeFeeModel:NSObject,NSCoding{
    var min:Double = 0
    var max:Double = 0
    var reserved:Double = 0      //实际计算时、需要预留的fee
    override init() {
        super.init()
    }
    
    
    //赋值
    func giveDataToOtherModel(otherModel:CoinScopeFeeModel){
        for valueStr in self.getAllPropertys() {
            if let value = self.getValueOfProperty(property: valueStr){
                otherModel.setValueOfProperty(property: valueStr, value: value)
            }
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(min, forKey: "min")
        aCoder.encode(max, forKey: "max")
        aCoder.encode(reserved, forKey: "reserved")

    }
    
    required init?(coder aDecoder: NSCoder) {
        min =  aDecoder.decodeDouble(forKey: "min")
        max =  aDecoder.decodeDouble(forKey: "max")
        reserved =  aDecoder.decodeDouble(forKey: "reserved")

    }
    
}
