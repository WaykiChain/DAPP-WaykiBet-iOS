//
//  Window.swift
//  WaykiApp
//
//  Created by louis on 2018/8/24.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit


extension UIWindow {
    
    var keyWindow: UIWindow {
        return (self.window?.keyWindow)!
    }
    
    var keyWindowController: UIViewController {
        return (self.window?.rootViewController)!
    }
    
    var keyWindowView: UIView {
        return (self.window?.rootViewController?.view)!
    }
    
}
