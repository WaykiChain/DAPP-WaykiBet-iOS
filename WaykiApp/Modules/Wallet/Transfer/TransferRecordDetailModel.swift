//
//  TransferRecordDetailModel.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/29.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

class TransferRecordDetailModel: BaseModel {
    @objc var amount: Double = 0.0
    @objc var comments: String = ""
    @objc var txTime: String = ""
    @objc var txHash: String = ""
    @objc var minnerFee: Double = 0.0
    @objc var sendAddress: String = ""
    @objc var status: Int = 0
    @objc var coinSymbol: String = ""
    @objc var type: Int = 0
    @objc var receiveAddress: String = ""
    /*
     amount (number, optional): 交易金额 ,
     coinSymbol (string, optional): 货币符号 ,
     comments (string, optional): 备注 ,
     minnerFee (number, optional): 矿工费 ,
     receiveAddress (string, optional): 收款方钱包地址 ,
     sendAddress (string, optional): 付款方钱包地址 ,
     status (integer, optional): 交易状态：100，交易成功，200 交易失败 ,
     txHash (string, optional): 交易hash ,
     txTime (string, optional): 交易时间 ,
     type (integer, optional): 交易类型：100:转账+- | 120: 兑换+-| 130: 锁仓| 140:-激活 | 210:投注-| 220:开庄-
     */
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        super.setValue(value, forUndefinedKey: key)
    }
}
