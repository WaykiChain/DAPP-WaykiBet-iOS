//
//  AccountManager.swift
//  WaykiApp
//
//  Created by sorath on 2018/8/24.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

@objcMembers class NewAccount:NSObject,NSCoding {
    @objc private var passwordEncrypt:String = ""/////md5 32摘要  ,此密码不保存
    @objc private var helpStringEncrypt:String =  ""//加密后部分
    var mHash:String =  ""
    var address:String =  ""
    var regId:String = ""
    var validHeight:Double = 0
    var wiccSumAmount:Double = 0    //主币数量
    var tokenSumAmount:Double = 0   //代币数量
    var wiccFSumAmount:Double = 0   //冻结、锁仓wicc数量

    var phoneNum:String = ""        //钱包绑定的账户手机号
    var token:String = ""           //Token,每次启动需要清除
    var areaCode:String = ""        //区号
    static let instance = NewAccount()    /// 单例
    
    class func shared() ->NewAccount{
        return instance
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(helpStringEncrypt, forKey: "helpStringEncrypt")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(regId, forKey: "regId")
        aCoder.encode(validHeight, forKey: "validHeight")
        aCoder.encode(mHash, forKey: "mHash")
        aCoder.encode(wiccSumAmount, forKey: "wiccSumAmount")
        aCoder.encode(tokenSumAmount, forKey: "tokenSumAmount")
        aCoder.encode(wiccFSumAmount, forKey: "wiccFSumAmount")

        aCoder.encode(phoneNum, forKey: "phoneNum")
        aCoder.encode(token, forKey: "token")
        aCoder.encode(areaCode, forKey: "areaCode")

    }
    
    required init?(coder aDecoder: NSCoder) {
        helpStringEncrypt =  aDecoder.decodeString(forKey: "helpStringEncrypt")
        address = aDecoder.decodeString(forKey: "address")
        regId = aDecoder.decodeString(forKey: "regId")
        validHeight = aDecoder.decodeDouble(forKey: "validHeight")
        mHash = aDecoder.decodeString(forKey: "mHash")
        wiccSumAmount = aDecoder.decodeDouble(forKey: "wiccSumAmount")
        tokenSumAmount = aDecoder.decodeDouble(forKey: "tokenSumAmount")
        wiccFSumAmount = aDecoder.decodeDouble(forKey: "wiccFSumAmount")

        phoneNum = aDecoder.decodeString(forKey: "phoneNum")
        token = aDecoder.decodeString(forKey: "token")
        areaCode = aDecoder.decodeString(forKey: "areaCode")

    }
    
    override init() {
        super.init()
    }
    
    //将一个model的值转到另一个model上（存储在本地的）
    func giveDataToOtherAccount(newModel:NewAccount){
        
        for valueStr in self.getAllPropertys() {
            if let value = self.getValueOfProperty(property: valueStr){
                newModel.setValueOfProperty(property: valueStr, value: value)
            }
        }
        
    }
    
    //通过这个方法向单例添加密码
    private func setPassword(inputPassword:String){
        let password:NSString = inputPassword as NSString
        let encryptPWD =  password.md5()
        passwordEncrypt = encryptPWD!
    }
    //通过这个方法向单例添加助记词和密码
    func setEncyptHelpStringAndPassword(helpStr:String,password:String){
        setPassword(inputPassword: password)
        helpStringEncrypt = helpStr.encryt(password: passwordEncrypt)
    }
    
    //获取助记词
    func getHelpString(password:String) ->String{
        let encryptPwd = (password as NSString).md5()
        let helpStr = helpStringEncrypt.dencryt(password: encryptPwd!)
        return helpStr
    }
    
    //获取私钥
    func getPrivateKey(password:String) ->String{
        let helpStr = self.getHelpString(password: password)
        let secreatKet = Bridge.getAddressAndPrivateKey(withHelp: helpStr, password: password)
        var key = ""
        if secreatKet?.last is String {
            key = (secreatKet?.last as? String)!
        }
        return key
    }
    
    
    //检验密码是否正确
    func checkPassword(inputPassword:String) ->Bool{
        let encryptPwd = (inputPassword as NSString).md5()
        let helpStr = helpStringEncrypt.dencryt(password: encryptPwd!)
        if helpStr.count>0 {
            return true
        }
        return false
    }
    
    //检验原密码是否正确，如果密码正确则更新密码
    func checkAndUpdatePassword(oldPassword:String,nPassword:String) ->Bool{
        let isEqual = checkPassword(inputPassword: oldPassword)
        if isEqual  {
            //内存中存储新密码，本地存储经新密码加密过后的助记词
            let helpStr = getHelpString(password: oldPassword)
            setEncyptHelpStringAndPassword(helpStr: helpStr, password: nPassword)
            AccountManager.saveAccount(account: self)
        }
        return isEqual
    }
    
    //检验此账户是否存在(助记词和密码是否存在)
    func checkAccountIsExisted() -> Bool{
        var isExist = false
        if helpStringEncrypt.count>10&&address.count>6{
            isExist = true
        }
        return isExist
    }
    
    
}
//MARK: - AccountManager 获取、保存
class AccountManager: NSObject {
    
    static let new_path:String = NSHomeDirectory()+"/Documents/new_path.data"
    
    class func saveAccount(account:NewAccount){
        //每次存储的时候刷新本地account
        let shareAccount = NewAccount.shared()
        account.giveDataToOtherAccount(newModel: shareAccount)
        NSKeyedArchiver.archiveRootObject(account,toFile:new_path)
    }
    /// 获取账户
    class func getAccount() -> NewAccount{

        let account = NewAccount.shared()
        if account.address.count < 4 {
            if let savedModel:NewAccount = NSKeyedUnarchiver.unarchiveObject(withFile: new_path) as? NewAccount {
                savedModel.giveDataToOtherAccount(newModel: account)
            }
        }
        return account
    }
    
}

//MARK: - AccountManager 其他逻辑
extension AccountManager{
    //检测钱包信息（手机号）是否和登录的信息相同,如果不同，则清除并替换
    class func checkLocalWalletInfo(phone:String,token:String,areaCode:String) ->Bool{
        let account = AccountManager.getAccount()
        //先判断和本地存储手机号的是否相同
        if phone != account.phoneNum {
            clearNewAccountWithPhoneAndToken(token: token, phoneNum: phone,areaCode:areaCode)
            return false
        }else{
            account.phoneNum = phone
            account.token = token
            account.areaCode = areaCode
            AccountManager.saveAccount(account: account)
            return true
        }
    }
    
    //更新（替换）本地钱包,仅保存手机号和token（这两个是h5传递来的数据）
    class func clearNewAccountWithPhoneAndToken(token:String,phoneNum:String,areaCode:String){
        let newAccount = NewAccount()
        newAccount.token = token
        newAccount.phoneNum = phoneNum
        newAccount.areaCode = areaCode
        AccountManager.saveAccount(account: newAccount)
    }
}
