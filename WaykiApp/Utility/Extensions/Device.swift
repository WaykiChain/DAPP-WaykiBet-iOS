//
//  Device.swift
//  WaykiApp
//
//  Created by louis on 2018/8/24.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit


/** 设置类型 */
extension UIDevice {
    
    class func isX() -> Bool {
        if UIScreen.main.bounds.height == 812 {return true}
        return false
    }
    
    /** 返回：5，6，p,x */
    class func model() -> String {
        switch UIScreen.main.bounds.size.width {
        case 320:
            return "5"
        case 375:
            if UIScreen.main.bounds.height == 812 { return "x" }
            return "6"
        case 414:
            return "p"
        default:
            return "x"
        }
    }
}
