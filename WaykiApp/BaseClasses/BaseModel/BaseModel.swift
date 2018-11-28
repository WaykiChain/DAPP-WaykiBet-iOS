//
//  BaseModel.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/29.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

class BaseModel: NSObject {
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
}

