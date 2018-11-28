//
//  ItemsWebController.swift
//  WaykiApp
//
//  Created by sorath on 2018/10/15.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit
//其他tabbar items
class ItemsWebController: BaseWebController {
    override var preferredStatusBarStyle: UIStatusBarStyle{get { return.lightContent}}
    var isNotBGColor = true
    override func viewDidLoad() {
        provider = NSStringFromClass(ItemsProvider.self)
        super.viewDidLoad()
        reloadURL(url: url)
        if isNotBGColor==false{
            view.backgroundColor = UIColor.bgColor()
            wkWebView.backgroundColor = UIColor.bgColor()
            wkWebView.scrollView.backgroundColor = UIColor.bgColor()
        }else{
            view.backgroundColor = UIColor.RGBHex(0x232f4f)
            wkWebView.backgroundColor = UIColor.RGBHex(0x232f4f)
            wkWebView.scrollView.backgroundColor = UIColor.RGBHex(0x232f4f)
        }
    }

    
    
}
