

import UIKit

class NewAccount:NSObject,NSCoding {
    private var passwordEncrypt:String = ""/////md5 32摘要
    private var helpStringEncrypt:String =  ""//加密后部分
    var mHash:String =  ""
    var address:String =  ""
    var regId:String = ""
    var validHeight:Double = 0
    var wiccSumAmount:Double = 0
    var spcSumAmount:Double = 0
    var time:TimeInterval?
    
    var exClickTime:Date  = Date(timeIntervalSince1970: 0) //上次点击兑换的时间
    var exchangeTime:Date = Date(timeIntervalSince1970: 0) //上次发起请求的兑换时间
    var exchangeTimes:Int = 0 //今日投注次数

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
        aCoder.encode(spcSumAmount, forKey: "spcSumAmount")
        aCoder.encode(exchangeTime, forKey: "exchangeTime")
        aCoder.encode(exchangeTimes, forKey: "exchangeTimes")


    }
    required init?(coder aDecoder: NSCoder) {
        helpStringEncrypt =  aDecoder.decodeObject(forKey: "helpStringEncrypt") as! String
        address = aDecoder.decodeObject(forKey: "address") as! String
        regId = aDecoder.decodeObject(forKey: "regId") as! String
        validHeight = aDecoder.decodeDouble(forKey: "validHeight")
        mHash = aDecoder.decodeObject(forKey: "mHash") as! String
        wiccSumAmount = aDecoder.decodeDouble(forKey: "wiccSumAmount")
        spcSumAmount = aDecoder.decodeDouble(forKey: "spcSumAmount")
        exchangeTimes = aDecoder.decodeInteger(forKey: "exchangeTimes")

        if let etime = aDecoder.decodeObject(forKey: "exchangeTime"){
             exchangeTime = etime as! Date
        }
    }
    override init() {
        super.init()
    }
      
    //将一个model的值转到另一个model上（存储在本地的）
    func giveDataToOtherAccount(newModel:NewAccount){
        newModel.address = self.address
        newModel.helpStringEncrypt = self.helpStringEncrypt
        newModel.mHash = self.mHash
        newModel.regId = self.regId
        newModel.validHeight = self.validHeight
        newModel.wiccSumAmount = self.wiccSumAmount
        newModel.spcSumAmount = self.spcSumAmount
        newModel.exchangeTime = self.exchangeTime
        newModel.exchangeTimes = self.exchangeTimes

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
    
    //判断投注是否需要输入密码
    func checkBetIfNeededInputPassword() ->(isNeededInput:Bool,helpStr:String){
        var trupel:(isNeededInput:Bool,helpStr:String)
        if time != nil{
            let nowTime = Date().timeIntervalSince1970
            let oldTime =  time
            if nowTime - oldTime! > 600{
                trupel = (isNeededInput:true,helpStr:"")
            }else{
                if (passwordEncrypt.count)>1{
                    let helpStr = helpStringEncrypt.dencryt(password: passwordEncrypt)
                    trupel = (isNeededInput:false,helpStr:helpStr)

                }else{
                    trupel = (isNeededInput:true,helpStr:"")
                }
            }
        }else{
          trupel = (isNeededInput:true,helpStr:"")
        }
        
        if trupel.isNeededInput == true {
        
        }
        return trupel
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
    
    //如果密码正确，则更新投注时间和密码
    func updateTimeAndPwd(inputTime:TimeInterval,pwd:String){
        if checkPassword(inputPassword: pwd) {
            time = inputTime
            setPassword(inputPassword: pwd)
        }
    }
    
}


class AccountManager: NSObject {

    static let account_path:String = NSHomeDirectory()+"/Documents/account_path.data"
    static let new_path:String = NSHomeDirectory()+"/Documents/new_path.data"
    
    class func saveAccount(account:NewAccount){
        //每次存储的时候刷新本地account
        let shareAccount = NewAccount.shared()
        account.giveDataToOtherAccount(newModel: shareAccount)
        NSKeyedArchiver.archiveRootObject(account,toFile:new_path)
    }
    /// 获取账户
    class func getAccount() -> NewAccount{
        if FileManager.default.fileExists(atPath: account_path) {
            let new = NewAccount.shared()
            if let oldAccount = NSKeyedUnarchiver.unarchiveObject(withFile: account_path) as? Account {
                new.setEncyptHelpStringAndPassword(helpStr: oldAccount.helpString, password: oldAccount.password)
                new.mHash = Bridge.getWalletHash(from: oldAccount.helpString)
                new.address = oldAccount.adress
                try! FileManager.default.removeItem(at: URL(fileURLWithPath: account_path))
            }
            return new
        }else{
            let account = NewAccount.shared()
            if account.address.count < 4 {
                if let savedModel:NewAccount = NSKeyedUnarchiver.unarchiveObject(withFile: new_path) as? NewAccount {
                    savedModel.giveDataToOtherAccount(newModel: account)
                }
            }
            return account
        }
    }
    
}

class SecurityManager: NSObject {
    
    class func getEncryptingString(str:String)->String{
        return SecurityUtil.encryptAESData(str)
    }
    
    class func getDecryptingString(str:String)->String {
        return SecurityUtil.decryptAESData(str)
    }
}




