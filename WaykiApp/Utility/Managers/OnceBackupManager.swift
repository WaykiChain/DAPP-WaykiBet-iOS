//
//  OnceBackupManager.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/30.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit
let backupKey = "backupKey" + AccountManager.getAccount().address
class OnceBackupManager: NSObject {
    //入口 判断创建钱包后是否有过第一次备份，没有则显示，换手机或者直接划掉app默认已备份
    class func checkIfBackup() ->Bool{
        if UserDefaults.standard.string(forKey: backupKey) != nil{
            let value = UserDefaults.standard.string(forKey: backupKey)
            if value == "needAlert"{
                alertInputView()
                return false
            }else{
                return true
            }
        }else{
            return true
        }
    }
    
    class func saveKeyInfo(){
        UserDefaults.standard.set("needAlert", forKey: backupKey)
        UserDefaults.standard.synchronize()
    }
}


extension OnceBackupManager{
    
    private class func alertInputView(){
        let v = InputPWDAlertView.init(checkPWDType: CheckPWDType.showTitle, frame: CGRect(x: 0, y: 0, width: UIScreen.width(), height: UIScreen.height()), btnTitles: ["取消".local,"立即备份".local], title: "您还没有备份钱包助记词，请立即备份".local)
        v.showAlert()
        v.confirmBlock = {(pwd) in
            self.presentBackUpView(pwd: pwd)
            //显示过即可
            UserDefaults.standard.set("alerted", forKey: backupKey)
            UserDefaults.standard.synchronize()
        }

    }
    
    private class func presentBackUpView(pwd:String){
        if Tools.getTabber() != nil{
            let c = WalletBackupVC()
            c.password = pwd
            UIApplication.shared.keyWindow?.rootViewController?.present(c, animated: true, completion: nil)
        }
    }
}
