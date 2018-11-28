//
//  TransferRecordModel.swift
//  WaykiApp
//
//  Created by lcl on 2018/9/7.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

class TransferRecordModel: NSObject {
    @objc var amount:Double = 0
    @objc var status:Int = 0
    @objc var refOrderId:Int = 0
    @objc var confirmTime:String = ""
    @objc var coinSymbol:String = ""
    @objc var type:Int = 0
    @objc var id:Int = 0

    /*
     amount (number, optional): 交易金额，小数 ,
     coinSymbol (string, optional): 货币符号：WICC,WUSD ,
     confirmTime (string, optional): 确认时间 ,
     refOrderId (integer, optional): 业务id ,
     status (integer, optional): 交易状态 ,
     //type (integer, optional): 交易类型：110:转账+- | 120: 兑换+-| 130: 锁仓| 140:-激活 | 180:合约修改汇率(修改汇率)| 210:投注-| 220:开庄-/ 300:投注派奖-/ 310:开庄派奖
     */
    
    init(_ dic : [String:Any]){
        super.init()
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {

    }

    override func setValue(_ value: Any?, forKey key: String) {
        if value == nil{
            return
        }

        super.setValue(value, forKey: key)
    }
    
    //获取中文交易类型
    class func getChineseType(type:Int) ->String{
        var chineseType = ""
        switch type {
        case 110:
            chineseType = "转账".local
            break
        case 120:
            chineseType = "兑换".local
            break
        case 130:
            chineseType = "锁仓".local
            break
        case 140:
            chineseType = "激活".local
            break
        case 210,300:
            chineseType = "投注".local
            break
        case 220,310:
            chineseType = "开庄".local
            break
        case 600:
            chineseType = "系统奖励".local
            break
        default:
            break
        }
        return chineseType
    }
    
    
}
