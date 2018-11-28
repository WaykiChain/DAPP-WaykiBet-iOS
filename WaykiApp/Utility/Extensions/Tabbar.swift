//
//  Tabbar.swift
//  WaykiApp
//
//  Created by sorath on 2018/8/28.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

extension BaseTabBarController{
    //获取选择的nav
    var selectedNAV:UINavigationController?{
        let index = self.selectedIndex
        let vc = self.viewControllers![index]
        if vc is UINavigationController {
            return vc as? UINavigationController
        }
        return nil
    }
}
