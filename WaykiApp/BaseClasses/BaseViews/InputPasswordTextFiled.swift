//
//  InputPasswordTextFiled.swift
//  WaykiChain
//
//  Created by sorath on 2018/6/6.
//  Copyright © 2018年 wk. All rights reserved.
//

import UIKit

class InputPasswordTextFiled: UITextField {

    /// 是否只是用于显示（禁用粘贴、选择和全选功能）
    var displayOnly = true
    /// 禁用粘贴
    var disablePaste = false
    /// 禁用选择
    var disableSelect = false
    /// 禁用全选
    var disableSelectAll = false
    
    /// 禁用复制
    var disableCopy = false
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if displayOnly {
            return false
        }
        if disablePaste && action == #selector(paste(_:)) {
            return false
        }
        if disableSelect && action == #selector(select(_:)) {
            return false
        }
        if disableSelectAll && action == #selector(selectAll(_:)) {
            return false
        }
        
        if disableCopy && action == #selector(copy(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
   
}


