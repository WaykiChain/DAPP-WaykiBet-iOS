//
//  TransferC.swift
//  Wayki
//
//  Created by louis on 2018/6/26.
//  Copyright © 2018年 wk. All rights reserved.
//

import UIKit

class TransferC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        buildV()
        
        JsonRpcManager.getBalance(succeed: { (s, o) in
            print(s,o)
        }) { (s) in
            print(s)
        }

    }

}

extension TransferC{
    func buildV(){
        view.backgroundColor = UIColor.white

        let btn = UIButton(frame: CGRect(x: 0, y: 350, width: ScreenWidth, height: 60))
        btn.backgroundColor = UIColor.blue
        btn.setTitle("转账", for: .normal)
        btn.addTarget(self, action: #selector(transfrom), for: .touchUpInside)
        view.addSubview(btn)
    }
}

extension TransferC{

    @objc func transfrom(){
        
        // 校验密码 -> 提取账户的助记词
        let password = "用户输入密码"
        let helpString = AccountManager.getAccount().getHelpString(password: password)
        
        // 设置的手续费(wicc) -> 值越大,确认速度越快
        let fees = 0.001
        
        // 转账的目的地址
        let destAddr = ""
        
         // 转账的金额
        let count:Double = 0.1
        
        // 获取区块高度
        JsonRpcManager.getBlockHeight(succeed: { (vaildHeight) in
            // 获取交易的签名
            JsonRpcManager.getBalance(succeed: { (balance, regID) in
                let hex:String = Bridge.getTransfetWICCHex(withHelpStr: helpString,fees:fees , validHeight: vaildHeight, srcRegId: regID, destAddr: destAddr, transferValue: count)
                self.transfer(hex: hex, remark: "转账备注")
                
            }, failed: { (str) in print(str)})
        }) { (s) in UILabel.showFalureHUD(text: s) }
    }
    
    // 转账 -> 直接发送消息到节点上
    func transfer(hex:String,remark:String){
        let dic = Dictionary<String, Any>.register(signHex: hex)
        LHRequest.postJsonRPC(url: nodeURL, parameters: dic, success: { (json) in
            print(json)
            UILabel.showSucceedHUD(text: "投注成功,等待区块确认！".local)
        }) {s in
            UILabel.showFalureHUD(text: "投注失败".local)
        }
    }

}

