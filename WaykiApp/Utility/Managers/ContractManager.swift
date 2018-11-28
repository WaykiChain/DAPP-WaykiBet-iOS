//
//  ContractManager.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/26.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit
//合约信息
class ContractManager: NSObject {
    static  let wusdC_path:String = NSHomeDirectory()+"/Documents/wusdContractModel.data"

    class func getWUSDContractModel() ->ContractModel{
        if let model = NSKeyedUnarchiver.unarchiveObject(withFile: wusdC_path) as? ContractModel{
            return model
        }
        return ContractModel()
    }
    
    
    class func saveWUSDContractModel(model:ContractModel){
        let newCModel = ContractModel()
        model.giveDataToOtherModel(newModel: newCModel)
        NSKeyedArchiver.archiveRootObject(model, toFile: wusdC_path)
    }
}


//合约信息模型
class ContractModel:NSObject,NSCoding{
    
    
    var active: Int = 0
    var id: Int = 0
    var contractAddressRegId: String = ""
    var adminAddress: String = ""
    var contractAddress: String = ""
    var coinSymbol: String = ""
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(active, forKey: "active")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(contractAddressRegId, forKey: "contractAddressRegId")
        aCoder.encode(adminAddress, forKey: "adminAddress")
        aCoder.encode(contractAddress, forKey: "contractAddress")
        aCoder.encode(coinSymbol, forKey: "coinSymbol")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        active = aDecoder.decodeInteger(forKey: "active")
        id = aDecoder.decodeInteger(forKey: "id")
        contractAddressRegId =  aDecoder.decodeObject(forKey: "contractAddressRegId") as! String
        adminAddress = aDecoder.decodeObject(forKey: "adminAddress") as! String
        contractAddress = aDecoder.decodeObject(forKey: "contractAddress") as! String
        coinSymbol = aDecoder.decodeObject(forKey: "coinSymbol") as! String
    }

}

extension ContractModel{
    //解析
    class func getModels(arr:[JSON])->[ContractModel]{
        var models:[ContractModel] = []
        for lo in arr {
            let model = ContractModel()
            model.analysisData(json:lo)
            models.append(model)
        }
        return models
    }
    
    
    func analysisData(json:JSON){
        active = json["active"].intValue
        id = json["id"].intValue
        contractAddressRegId = json["contractAddressRegId"].stringValue
        adminAddress = json["adminAddress"].stringValue
        contractAddress = json["contractAddress"].stringValue
        coinSymbol = json["coinSymbol"].stringValue
    }
}

extension ContractModel{
    //将一个model的值转到另一个model上（存储在本地的）
    func giveDataToOtherModel(newModel:ContractModel){
        for valueStr in self.getAllPropertys() {
            if let value = self.getValueOfProperty(property: valueStr){
                newModel.setValueOfProperty(property: valueStr, value: value)
            }
        }
        
    }
}
