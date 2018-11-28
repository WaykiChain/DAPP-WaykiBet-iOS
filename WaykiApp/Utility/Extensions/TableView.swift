//
//  TableView.swift
//  WaykiApp
//
//  Created by louis on 2018/8/24.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit


extension UITableView{
    func adaptiOS11(table:UITableView){
        if #available(iOS 11.0, *) {
            table.contentInsetAdjustmentBehavior = .never
            table.contentInset = UIEdgeInsetsMake(0, 0, 49, 0)//导航栏如果使用系统原生半透明的，top设置为64
            table.scrollIndicatorInsets = table.contentInset
            table.estimatedRowHeight = 0;
            table.estimatedSectionHeaderHeight = 0;
            table.estimatedSectionFooterHeight = 0;
        }
    }
}
