//
//  Screen.swift
//  WaykiApp
//
//  Created by louis on 2018/8/24.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

extension UIScreen {
    
    static func height() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static func width() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static func tabBarHeight()-> CGFloat {
        return UIDevice.isX() ? 80 : 49
    }
    
    static func naviBarHeight()-> CGFloat {
        return UIDevice.isX() ? 88 : 64
    }
    
    //判断是否使用@3图
    static func phoneIs3x() ->Bool{
        let scale = UIScreen.main.scale
        if scale == 3{
            return true
        }
        return false
    }
}



