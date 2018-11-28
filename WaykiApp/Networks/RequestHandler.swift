 

import UIKit
import Alamofire
import SVProgressHUD

enum HUDStyle {
    case none
    case loading
}

let CONNECTFAILD = "Connect error"

class RequestHandler: NSObject {
    
    class func post(url:String,parameters:Dictionary<String,Any>,runHUD:HUDStyle = .none,isNeedToken:Bool=true,success: @escaping ((_ json:JSON)->Void),failure:@escaping ((_ error:String)->Void)){
        
        
        
        // 显示加载器
        if runHUD == .loading{ showHUD() }
        // 参数处理
        let parameter:Parameters = parameters
        let uuid:String = UUIDTool.getUUIDInKeychain()
        let requestKey = AccountManager.getAccount().phoneNum.count>0 ? AccountManager.getAccount().phoneNum : "-"
        let requestUUID:String = UUIDTool.createRandomString(withKey: requestKey)
        let timeZone = TimeZone.getOffset()
        let lang = changeLang()
        var header = ["Accept":"application/json","Content-Type":"application/json","device_uuid":uuid,"request_uuid":requestUUID,"channel_code":channelCode,"user_timezone":timeZone,"lang":lang]
        if isNeedToken{
            header = addToken(header: header)
        }

        Alamofire.request(url, method: .post,
                          parameters: parameter,
                          encoding: JSONEncoding.default,
                          headers:header).responseJSON { (response) in
                            if runHUD == .loading { dismissHUD()}
                            var errorStr:String?
                            switch response.result.isSuccess {
                            case true:
                                if let value = response.result.value {
                                    if let dic = JSON(value).dictionary{
                                        if let code = dic["code"]?.int{
                                            if code == 0{
                                                success(JSON(value))
                                                return
                                            }
                                            checkSignout(code: code)
                                            //根据code 显示错误信息
                                            errorStr = ProperitesManager.instance.translate(code: code)
                                        }
                                        //如果errorcode 没有在本地存在翻译 则 接口返回的错误信息
                                        if errorStr?.count == 0{
                                            if let msg = dic["msg"]?.string{
                                                errorStr = msg
                                            }
                                        }

                                        
                                    }
                                }
                            case false:
                                let error = response.result.error
                                var message : String?
                                if let httpStatusCode = response.response?.statusCode {
                                    switch(httpStatusCode) {
                                    case 400:
                                        message = "http code 400"
                                    case 401:
                                        message = "http code 401"
                                    case 402:
                                        message = "http code 402"
                                    case 403:
                                        message = "http code 403"
                                    case 404:
                                        message = "http code 404"
                                    default:
                                        message = ""
                                    }
                                } else {
                                    if error?.localizedDescription != nil{
                                        message = (error?.localizedDescription)!
                                    }
                                }
                                errorStr = message
                            }
                            
                            if errorStr == nil{
                                errorStr = CONNECTFAILD
                            }
                            failure(errorStr!)
        }
    }
    
    
    
    
    class func get(url:String,parameters:Dictionary<String,Any>,runHUD:HUDStyle = .none,isNeedToken:Bool=true,success: @escaping ((_ json:JSON)->Void),failure:@escaping ((_ error:String)->Void) ){
        // 显示加载器
        if runHUD == .loading{ showHUD() }
        // 参数处理
        let parameter:Parameters = parameters
        let uuid:String = UUIDTool.getUUIDInKeychain()
        let requestKey = AccountManager.getAccount().phoneNum.count>0 ? AccountManager.getAccount().phoneNum : "-"
        let requestUUID:String = UUIDTool.createRandomString(withKey: requestKey)
        let timeZone = TimeZone.getOffset()
        let lang = changeLang()
        var header:[String:String] = ["device_uuid":uuid,"request_uuid":requestUUID,"channel_code":channelCode,"user_timezone":timeZone,"lang":lang]
        if isNeedToken{
            header = addToken(header: header)
        }
        Alamofire.request(url, method: .get, parameters: parameter, encoding: URLEncoding.default, headers:header).responseJSON { (response) in
            if runHUD == .loading { dismissHUD()}
           
            var errorStr:String?
            switch response.result.isSuccess {
            case true:
                if let value = response.result.value {
                    if let dic = JSON(value).dictionary{
                        if let code = dic["code"]?.int{
                            if code == 0{
                                success(JSON(value))
                                return
                            }

                            checkSignout(code: code)
                            //根据code 显示错误信息
                            errorStr = ProperitesManager.instance.translate(code: code)
                        }
                        //如果errorcode 没有在本地存在翻译 则 接口返回的错误信息
                        if errorStr?.count == 0{
                            if let msg = dic["msg"]?.string{
                                errorStr = msg
                            }
                        }
                    }
                }
            case false:
                let error = response.result.error
                var message : String?
                if let httpStatusCode = response.response?.statusCode {
                    switch(httpStatusCode) {
                    case 400:
                        message = "http code 400"
                    case 401:
                        message = "http code 401"
                    case 402:
                        message = "http code 402"
                    case 403:
                        message = "http code 403"
                    case 404:
                        message = "http code 404"
                    default:
                        message = ""
                    }
                } else {
                    if error?.localizedDescription != nil{
                        message = (error?.localizedDescription)!
                    }
                }
                errorStr = message
            }
            if errorStr == nil{
                errorStr = CONNECTFAILD
            }
            failure(errorStr!)
        }
    }
    
}
 
extension RequestHandler{
    
}


extension RequestHandler{
    class func showHUD(){ SVProgressHUD.show() }
    
    class func dismissHUD(){ SVProgressHUD.dismiss() }
    
    
    class func addToken(header:[String:String]) ->[String:String]{
        let account = AccountManager.getAccount()
        var headers = header
        if account.token.count>0 {
            headers["access_token"] = account.token
        }
        return headers
    }
    
    //检验是否登出，并执行
    class func checkSignout(code:Int){
        if code == 2011{
            if ((UIApplication.shared.keyWindow?.subviews) != nil){
                UIApplication.shared.keyWindow?.removeAllSubviews()
            }
           
            AccountManager.getAccount().token = ""
            AccountManager.saveAccount(account: AccountManager.getAccount())
            let c = LoginWebController()
            UIApplication.shared.keyWindow?.rootViewController = c
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                UILabel.showFalureHUD(text: "登录已过期".local)
            }
        }

    }
    
    //处理语言
    class func changeLang() ->String{
        let lang = "localLanguage".local
        let langType:String
        if lang == "0"{
            langType = "zh-CHS"
        }else if lang == "1"{
            langType = "zh-CHT"

        }else{
            langType = "en"

        }
        return langType
    }
    
}

