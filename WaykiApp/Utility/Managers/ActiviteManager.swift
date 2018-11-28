//
//  ActiviteManager.swift
//  WaykiApp
//
//  Created by sorath on 2018/8/28.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

class ActiviteManager: NSObject {
    //注意：此类应仅在本地钱包判断，如果没有导入、创建钱包，则不应有激活功能
    
    //仅判断是否激活,并给予提示
    class func checkIsActivityAndShowPrompt() ->Bool{
        let account = AccountManager.getAccount()
        if account.regId.count>2{
            return true
        }else{
            
            if account.regId == " "{
                UILabel.showFalureHUD(text: "激活中，请等待区块确认".local)
                WalletCommonRequestManager.getRegId()
                return false
            }else{
                UILabel.showFalureHUD(text: "请先激活钱包".local)
                return false
            }
        }
    }
    
    //检验是否激活,如果未激活，则执行激活程序
    @discardableResult
    class func checkIsActivityAndActivity(vc:UIViewController,isNeedPromptAlert:Bool = true)  ->Bool{
        let account = AccountManager.getAccount()
        if account.regId.count>2{
            return true
        }else{
            
            if account.regId == " "{
                UILabel.showFalureHUD(text: "激活中，请等待区块确认".local)
                WalletCommonRequestManager.getRegId()
                return false
            }else{
                if isNeedPromptAlert{
                    let alertView = UIAlertController.init(title: "提示".local, message: "系统检测到您尚未激活钱包，请先激活".local, preferredStyle: UIAlertControllerStyle.alert)
                    let ok = UIAlertAction.init(title: "激活".local, style: .default, handler: { (action) in
                        self.activiteWallet(vc: vc)
                    })
                    alertView.addAction(ok)
                    vc.present(alertView, animated: true, completion: nil)
                    return false
                }else{
                    self.activiteWallet(vc: vc)
                    return false
                }

            }
        }
    }
    
    
}

//MARK: - private
extension ActiviteManager{
    //弹出输入密码框
    private class func activiteWallet(vc:UIViewController){
        //UmengEvent.eventWithDic(name: "activate_wallet")
        let a = AccountManager.getAccount()
        if a.regId.count>2 {
            
        }else{
            let v = InputPWDAlertView(checkPWDType: .active, frame: CGRect(x: 0, y: 0, width: UIScreen.width(), height: UIScreen.height()),btnTitles:["取消".local,"立即激活".local])
            v.showAlert()
            v.confirmBlock = { (pwd) in
                WalletCommonRequestManager.getVaildHeight { (height) in
                    print("height is ",height)
                    activiteRequest(height: height, pwd: pwd)
                }
            }
        }
    }
    
    //激活接口
    private class func activiteRequest(height:Double,pwd:String){
        
        let amount = AccountManager.getAccount().wiccSumAmount
        
        if amount<0.00011{
            UILabel.showFalureHUD(text: "账户余额不足，无法激活".local)
            return
        }
        let acccount = AccountManager.getAccount()
        let path:String = httpPath(path: HTTPPath.转账和激活_P)
        let helpStr = acccount.getHelpString(password: pwd)
        let signHex:String = Bridge.getActrivateHex(withHelpStr: helpStr, withPassword: pwd, fees: 0.0001, validHeight: height)
        let pa:[String:Any] = ["txRemark": "",
                               "rawtx": signHex,
                               "type": 100, //100表示激活
                               "wiccAddress": acccount.address]
        let jsonS = String.getJSONStringFromDictionary(dictionary:pa as NSDictionary)
        print("jsonS is ",jsonS)
        
        RequestHandler.post(url: path, parameters: pa,runHUD:.loading, success: { (json) in
            RequestHandler.dismissHUD()
            acccount.regId = " "
            AccountManager.saveAccount(account: acccount)
            //UmengEvent.eventWithDic(name: "activate_readyForSure")

            UILabel.showSucceedHUD(text: "激活中，请等待区块确认".local)
            NotificationCenter.default.post(name: NSNotification.Name.init("Noti_activiteSuccess"), object: nil)
            
        }) {(error) in
            UILabel.showFalureHUD(text: error)
        }
        
    }
}
