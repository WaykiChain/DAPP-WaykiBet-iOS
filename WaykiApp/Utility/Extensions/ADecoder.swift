//
//  ADecoder.swift
//  WaykiApp
//
//  Created by sorath on 2018/10/16.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

extension NSCoder{
    func decodeString(forKey:String) ->String{
        if self.decodeObject(forKey: forKey) != nil{
            let v = self.decodeObject(forKey: forKey)
            if v is String{
                return v as! String
            }
        }
        return ""
    }
}
