//
//  Label.swift
//  WaykiApp
//
//  Created by sorath on 2018/8/28.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit
import SVProgressHUD

extension UILabel{
    class func showSucceedHUD(text:String){
        SVProgressHUD.setMinimumDismissTimeInterval(0.5)
        SVProgressHUD.showSuccess(withStatus: text)
    }
    
    class func showFalureHUD(text:String){
        SVProgressHUD.setMinimumDismissTimeInterval(0.5)
        SVProgressHUD.showError(withStatus: text)
    }
    class func showTextHUD(text:String){
        SVProgressHUD.setMinimumDismissTimeInterval(0.5)
        SVProgressHUD.showInfo(withStatus: text)
    }
}
