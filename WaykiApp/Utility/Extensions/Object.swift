//
//  Object.swift
//  WaykiApp
//
//  Created by louis on 2018/8/24.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import Foundation


extension NSObject {
    
    /* 获取对象对于的属性值，无对于的属性则返回NIL
     - parameter property: 要获取值的属性
     - returns: 属性的值
     */
    func getValueOfProperty(property:String)->AnyObject? {
        let allPropertys = self.getAllPropertys()
        if(allPropertys.contains(property)) {
            return self.value(forKey: property) as AnyObject
        }else{
            return nil
        }
    }
    
    /**
     设置对象属性的值
     - parameter property: 属性
     - parameter value:    值
     - returns: 是否设置成功
     */
    @discardableResult func setValueOfProperty(property:String,value:AnyObject)->Bool {
        let allPropertys = self.getAllPropertys()
        if (allPropertys.contains(property)) {
            self.setValue(value, forKey: property)
            return true
        } else {
            return false
        }
    }
    
    /**
     获取对象的所有属性名称
     - returns: 属性名称数组
     */
    func getAllPropertys()->[String] {
        
        var result = [String]()
        var count:UInt32 = 0
        //获取类属性列表
        
        let buff = class_copyPropertyList(object_getClass(self), &count)
        let countInt = Int(count)
        for i in 0..<countInt {
            //temp 获取属性
            let temp = buff![i]
            //获取属性名
            let tempPro = property_getName(temp)
            //转换为string
            let proper = String(utf8String: tempPro)
            result.append(proper!)
        }
        
        return result
    }
    
    
    
}
