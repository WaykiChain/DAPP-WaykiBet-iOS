//
//  ImportAccountC.swift
//  Wayki
//
//  Created by louis on 2018/6/26.
//  Copyright © 2018年 wk. All rights reserved.
//

import UIKit

class ImportAccountC: UIViewController {
    var addressLabel:UILabel!
    var helpLabel:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        buildV()
    }
}

extension ImportAccountC{
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
        btn.setTitle("导入账户", for: .normal)
        btn.addTarget(self, action: #selector(createWallet), for: .touchUpInside)
        view.addSubview(btn)
    }
}


extension ImportAccountC{
    
    @objc func createWallet(){
        // 用户输入的助记词
        let helpstr = "situate awful light wise build coffee stable grit win swim rescue during"
        // 用户设置的密码
        let password = "用户输入的密码"
        
        // 校验助记词
        if Bridge.checkMnemonicCode(Bridge.getWalletHelpCodes(from: helpstr)) {
            let address = Bridge.getAddressAndPrivateKey(withHelp: helpstr)[0]
            self.importWallet(helpStr: helpstr, address: address as! String, password: password)
        }
    }
    
    func importWallet(helpStr:String,address:String,password:String){
        // 存储助记词
        let account = NewAccount()
        account.address = address
        account.mHash = Bridge.getWalletHash(from: helpStr)
        account.setEncyptHelpStringAndPassword(helpStr: helpStr, password: password)
        AccountManager.saveAccount(account: account)
        
        /** 展示 */
        addressLabel.text = "地址:\n\(account.address)"
        helpLabel.text = "助记词:\n\(helpStr)"
        
    }
}

