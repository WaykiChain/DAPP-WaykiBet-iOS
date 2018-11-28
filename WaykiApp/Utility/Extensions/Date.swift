//
//  Date.swift
//  WaykiApp
//
//  Created by louis on 2018/8/24.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit


extension Date{
    
    /** 获取日期 */
    private func calender()->DateComponents {
        let calendar = Calendar(identifier: .gregorian)
        var comps: DateComponents = DateComponents()
        comps = calendar.dateComponents([.year,.month,.day, .weekday, .hour, .minute,.second], from: Date())
        return comps
    }
    
    var year:String {
        return String(describing: self.calender().year!)
    }
    
    var month:String {
        return String(describing: self.calender().month!)
    }
    
    var day:String {
        return String(describing: self.calender().day!)
    }
    
    var hour:String {
        return String(describing: self.calender().hour!)
    }
    
    var min:String {
        return String(describing: self.calender().minute!)
    }
    
    
    func dateString(format: String="yyyy-MM-dd HH:mm")-> String  {
        let formater = DateFormatter()
        formater.dateFormat = format
        return formater.string(from: self)
    }
    
    /** 获取某一时间 */
    static func UTCDateString(date:Date) -> Date {
        let timeZ = TimeZone.init(abbreviation: "GMT+0800")
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZ
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: date)
        return dateFormatter.date(from: dateString)!
    }
    
}
