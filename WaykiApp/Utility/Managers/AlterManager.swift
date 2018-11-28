//
//  AlterManager.swift
//  WaykiApp
//
//  Created by louis on 2018/8/24.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

class AlterManager: NSObject {
    class func isFirstLaunch() -> Bool{
        if UserDefaults.standard.value(forKey: "firstlaunch") != nil{
            return false
        }else{
            UserDefaults.standard.set(true, forKey: "firstlaunch")
            return true
        }
        
    }
}
