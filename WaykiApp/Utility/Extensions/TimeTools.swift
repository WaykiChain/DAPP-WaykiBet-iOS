//
//  TimeTools.swift
//  WaykiApp
//
//  Created by sorath on 2018/10/4.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

extension TimeZone{
    static func getOffset() ->String{
        return "\(TimeZone.current.secondsFromGMT()/3600)"
    }
}
