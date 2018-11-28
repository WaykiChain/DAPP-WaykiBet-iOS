//
//  Color.swift
//  WaykiApp
//
//  Created by louis on 2018/8/24.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit


extension UIColor {
    
    class func RGBHex(_ rgbValue:Int,alpha:CGFloat=1.0) ->(UIColor) {
        return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0,alpha: alpha)
    }
    
    class func RGBDecColor(r:CGFloat,g:CGFloat,b:CGFloat,alpha:CGFloat=1.0) ->UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
    }
    
    class func grayColor(v:CGFloat,alpha:CGFloat=1.0)->UIColor {
        return UIColor(red: v/255.0, green: v/255.0, blue: v/255.0, alpha: alpha)
    }

    class func backColor() ->UIColor{
        return UIColor.RGBHex(0x1f3564)
    }
    
    class func fontWhite() ->UIColor{
        return UIColor.RGBHex(0xdee7ff)
    }
    
    class func titleColor() ->UIColor{
        return UIColor.RGBHex(0x727c8a)
    }
    
    class func bgColor() ->UIColor{
        return RGBHex(0x192545)
    }
    
    class func placeHolderColor() ->UIColor{
        return UIColor.RGBHex(0x4f6592)
    }
    
    class func lineColor() ->UIColor{
        return UIColor.RGBHex(0x6c7dab, alpha: 0.5)
    }
    
    class func amountColor() ->UIColor{
        return UIColor.RGBHex(0xb2c3f2)
    }
}

