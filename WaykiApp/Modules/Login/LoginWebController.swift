//
//  LoginWebController.swift
//  WaykiApp
//
//  Created by louis on 2018/8/24.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

class LoginWebController: BaseWebController {
    override func viewDidLoad() {
        provider = NSStringFromClass(LoginWebProvider.self)
        super.viewDidLoad()

//        url = "http://localhost:9100/login"
        


        url = netpro+hostName+port+"/login"
        
        reloadURL(url: url)
    }
}
