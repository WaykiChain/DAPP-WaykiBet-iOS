//
//  EX_RecordModel.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/5.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

class EX_RecordModel: NSObject {
    //返回数据
    var direction:Int = 100 //兑换方向：100：wusd->wicc，200： wicc->wusd
    var ID:Int = 0
    var walletAddress:String = ""
    var wiccAmount: Double = 0//wicc金额 ,
    var wusdAmount: Double = 0//wust金额
    var status:Int = 100  //状态:100:已提交| 400:链上成功|800:汇兑成功|900:汇兑失败 ,
    var exchangeTime:String = ""
    var exchangeRate:Double = 0
    
    //使用数据
    var leftName:String = ""
    var leftImageName:String = ""
    var leftNum:String = ""
    
    var rightName:String = ""
    var rightImageName:String = ""
    var rightNum:String = ""
    
    var statusStr:String = ""
    var time:String = ""
    var rate:String = ""
    
    class func getModels(arr:[JSON])->[EX_RecordModel]{
        var models:[EX_RecordModel] = []
        for lo in arr {
            let model = EX_RecordModel()
            model.analysisData(json:lo)
            models.append(model)
        }
        return models
    }
    
    
    func analysisData(json:JSON){
        ID = json["id"].intValue
        direction = json["direction"].intValue
        walletAddress = json["walletAddress"].stringValue
        wiccAmount = json["wiccAmount"].doubleValue
        wusdAmount = json["wusdAmount"].doubleValue
        status = json["status"].intValue
        exchangeTime = json["exchangeTime"].stringValue
        exchangeRate = json["exchangeRate"].doubleValue

        if direction == 200{
            leftName = CoinType.wicc.rawValue
            leftNum = "\(wiccAmount)".removeEndZeros()
            leftImageName = "icon_"+CoinType.wicc.rawValue
            rightName = CoinType.token.rawValue
            rightNum = "\(wusdAmount)".removeEndZeros()
            rightImageName = "icon_"+CoinType.token.rawValue
            rate = "\(exchangeRate)".removeEndZeros()
        }else if direction == 100{
            leftName = CoinType.token.rawValue
            leftNum = "\(wusdAmount)".removeEndZeros()
            leftImageName = "icon_"+CoinType.token.rawValue

            rightName = CoinType.wicc.rawValue
            rightNum = "\(wiccAmount)".removeEndZeros()
            rightImageName = "icon_"+CoinType.wicc.rawValue
            if exchangeRate != 0{
                rate = "\(Double(Int(10000*(1.0/exchangeRate)))/10000)".removeEndZeros()
            }else{
                rate = "0"
            }
            
        }
        switch status {
        case 100:
            statusStr = "等待确认".local
            break
        case 400:
            statusStr = "等待确认".local
            break
        case 800:
            statusStr = "兑换成功".local
            break
        case 900:
            statusStr = "兑换失败".local
            break
        default:
            statusStr = "等待确认".local
            break
        }

        time = exchangeTime
    }
}
