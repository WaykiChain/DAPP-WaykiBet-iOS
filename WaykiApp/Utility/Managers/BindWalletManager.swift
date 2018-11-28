//
//  BindWalletManager.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/17.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit
//绑定和检测钱包
//两个入口方法
class BindWalletManager: NSObject {
    //绑定帐号和本地钱包，不需要判断是否绑定过
    //有结果后返回
    //这是入口方法
    //绑定钱包
    class func bindWallet(address:String,mHash:String, complete:@escaping(() ->Void)){
        let path = httpPath(path: .绑定钱包_P)
        let requestDic = ["walletMnecode": mHash,
                          "wiccAddress": address]
        
        RequestHandler.post(url: path, parameters: requestDic,runHUD : .loading, success: { (json) in
            
            complete()
        }) { (error) in
            //如果绑定不成功
            UILabel.showFalureHUD(text: error)
        }
    }
    
    //检测帐号是否绑定本地钱包，如果没有，则清除本地信息，如果帐号没有绑定过钱包，则弹出导入、创建钱包alert
    class func checkBindOrClear(phone:String,token:String,areaCode:String){
        if AccountManager.checkLocalWalletInfo(phone: phone, token: token, areaCode: areaCode) == false{
            return
        }
        //如果本地有钱包，且本地存储的手机号与登陆帐号相同，则去判断账户绑定的钱包是否和本地钱包相同
        checkBind(address: AccountManager.getAccount().address) { (isNeedUpdate,_) in
            //如果需要更新，则清除
            if isNeedUpdate{
                AccountManager.clearNewAccountWithPhoneAndToken(token: AccountManager.getAccount().token, phoneNum: AccountManager.getAccount().phoneNum, areaCode: areaCode)
            }
        }
    }
    
    //(必须登陆过后)检测帐号是否绑定过钱包，如果登陆帐号没有绑定过钱包，则弹框（导入、创建）
    class func checkAccountIsBind(complete:@escaping((Bool)->Void)){
        let account = AccountManager.getAccount()
        //先判断本地是否存在钱包，如果存在，则说明该账户已绑定过钱包
        if account.checkAccountIsExisted()&&account.phoneNum.count>3{
            complete(true)
            return
        }
        
        //如果本地没有钱包，则通过接口判断该登陆帐号是否绑定过,没绑定则弹框
        checkBind(address: account.address) { (_, isNeedAlert) in
            if isNeedAlert {
                _ = CommonAlertView.alertCreateOrImport()
            }else{
                complete(true)
            }
        }
    }

}

extension BindWalletManager{

    //检查是否绑定
    //1.是否不相同 2.是否没绑定
    private class func checkBind(address:String, complete:@escaping((Bool,Bool) ->Void)){
        
        getPhoneBindWallet { (wiccAddress) in
            
            //如果该（手机号）token绑定的 钱包地址和现有的不同,说明需要绑定，否则则不需要绑定
            if wiccAddress != address || wiccAddress.count == 0{
                
                if wiccAddress.count == 0{
                    //如果该帐号没有绑定过钱包，则需要弹框
                    complete(true,true)
                }else{
                    //需要绑定
                    complete(true,false)
                }

            }else{
                //不需要绑定
                complete(false,false)
            }
        }
    }
    
}

extension BindWalletManager{
    //获取手机号绑定钱包
    //不需要传递参数，在header里已处理
    class func getPhoneBindWallet(success: @escaping((String) ->Void)){
        let path:String = httpPath(path: HTTPPath.获取手机绑定钱包_P)
        RequestHandler.get(url: path, parameters: [:], success: { (json) in
            if let dic = json.dictionary{
                if let wiccAddress = dic["data"]?.stringValue{
                    success(wiccAddress)
                    
                }
            }
        }) { (error) in
            UILabel.showFalureHUD(text: error)
        }
        
    }
}
