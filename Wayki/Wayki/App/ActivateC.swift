//
//  ActivateC.swift
//  Wayki
//
//  Created by louis on 2018/6/26.
//  Copyright © 2018年 wk. All rights reserved.
//

import UIKit

class ActivateC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        buildV()
    }

}

extension ActivateC{
    func buildV(){
        view.backgroundColor = UIColor.white
        
        let btn = UIButton(frame: CGRect(x: 0, y: 350, width: ScreenWidth, height: 60))
        btn.backgroundColor = UIColor.blue
        btn.setTitle("激活账户", for: .normal)
        btn.addTarget(self, action: #selector(actrivateWallet), for: .touchUpInside)
        view.addSubview(btn)
    }
}

extension ActivateC{
    
    // 用户输入的密码 -> 激活
    @objc func actrivateWallet(){
        
        // 用户输入密码
        let pwd:String = ""
        
        // 取出助记词
        let helpStr = AccountManager.getAccount().getHelpString(password: pwd)
        
        // 获取区块高度
        JsonRpcManager.getBlockHeight(succeed: { (height) in
            
            // 生成交易签名
            let signHex = Bridge.getActrivateHex(withHelpStr: helpStr, withPassword: pwd, fees: 0.0001, validHeight: 100)
            
            // 生成JsonRPC请求格式数据
            let dic = Dictionary<String, Any>.register(signHex: signHex!)
            
            // 向节点提交数据
            LHRequest.postJsonRPC(url: nodeURL, parameters: dic, success: {  (json) in
                UILabel.showSucceedHUD(text: "已经申请激活,等待区块确认！")
            }) { s in
                UILabel.showFalureHUD(text: "激活失败")
            }
        }) { (str) in
            UILabel.showFalureHUD(text: str)
        }
    }
    
}
