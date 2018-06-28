//
//  CreateAccountC.swift
//  Wayki
//
//  Created by louis on 2018/6/26.
//  Copyright © 2018年 wk. All rights reserved.
//

import UIKit

class CreateAccountC: UIViewController {
    var addressLabel:UILabel!
    var helpLabel:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        buildV()
    }


}

extension CreateAccountC{
    func buildV(){
        view.backgroundColor = UIColor.white
        addressLabel = UILabel(frame: CGRect(x: 0, y: 150, width: ScreenWidth, height: 50))
        addressLabel.numberOfLines = 0
        addressLabel.font = UIFont.systemFont(ofSize: 13)
        addressLabel.textAlignment = .center
        view.addSubview(addressLabel)
        
        helpLabel = UILabel(frame: CGRect(x: 0, y: 250, width: ScreenWidth, height: 50))
        helpLabel.numberOfLines = 0
        helpLabel.font = UIFont.systemFont(ofSize: 13)
        helpLabel.textAlignment = .center
        view.addSubview(helpLabel)
        
        
        let btn = UIButton(frame: CGRect(x: 0, y: 350, width: ScreenWidth, height: 60))
        btn.backgroundColor = UIColor.blue
        btn.setTitle("创建账户", for: .normal)
        btn.addTarget(self, action: #selector(startCreate), for: .touchUpInside)
        view.addSubview(btn)
    }
}

extension CreateAccountC{
    
    
    // 创建完账户 -> AES加密 -> 序列化到本地存储
    @objc func startCreate(){
        
        // 设置密码
        let password = "#用户设置的密码"
        
        // 创建助记词数组
        let helpStrArray = Bridge.getWalletHelpCodes()
        // 助记词
        let helpStr = Bridge.getWaletHelpString(withCodes: helpStrArray)
        // 保存账号
        let account = NewAccount()
        account.address = Bridge.getAddressAndPrivateKey(withHelp: helpStr)[0] as! String
        account.mHash = Bridge.getWalletHash(from: helpStr!)
        // 加密
        account.setEncyptHelpStringAndPassword(helpStr: helpStr!, password: password)
        AccountManager.saveAccount(account: account)
        
        /** 展示 */
        addressLabel.text = "地址:\n\(account.address)"
        helpLabel.text = "助记词:\n\(helpStr!)"
    }
}
