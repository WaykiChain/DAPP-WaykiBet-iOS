

import UIKit
import Alamofire
import SVProgressHUD

enum HUDStyle {
    case none
    case loading
}

// 请求数据
class LHRequest: NSObject {
    
    static var manager:SessionManager? = nil
    
    // 注册专用Post
    class func post(url:String,parameters:Dictionary<String,Any>,runHUD:HUDStyle = .loading,success: @escaping ((_ json:JSON)->Void),failure:@escaping ((String)->Void) ){
        // 显示加载器
        if runHUD == .loading{ showHUD() }
        // 参数处理
        let parameter:Parameters = parameters
        manager = Alamofire.SessionManager.default
        manager?.session.configuration.timeoutIntervalForRequest = 10
        Alamofire.request(url, method: .post,
                          parameters: parameter,
                          encoding: JSONEncoding.default,
                          headers:["Accept":"application/json","Content-Type":"application/json"]).responseJSON { (response) in
                            dismissHUD()
                            switch response.result.isSuccess {
                            case true:
                                if let value = response.result.value {
                                    if let dic = JSON(value).dictionary{
                                        if let status = dic["status"]?.int{
                                            if status == 1{
                                                success(JSON(value))
                                            }else{
                                                if let str = dic["error"]?.string{
                                                    failure(str)
                                                }
                                            }
                                        }
                                    }
                                }
                            case false:
                                failure("创建钱包失败".local)
                            }
        }
    }
    
    
    class func post(url:String,parameters:Dictionary<String,Any>,runHUD:HUDStyle = .loading,success: @escaping ((_ json:JSON)->Void),failure:@escaping (()->Void) ){
        // 显示加载器
        if runHUD == .loading{ showHUD() }
        // 参数处理
        let parameter:Parameters = parameters
        manager = Alamofire.SessionManager.default
        manager?.session.configuration.timeoutIntervalForRequest = 10
        Alamofire.request(url, method: .post,
                          parameters: parameter,
                          encoding: JSONEncoding.default,
                          headers:["Accept":"application/json","Content-Type":"application/json"]).responseJSON { (response) in
                dismissHUD()
                switch response.result.isSuccess {
                case true:
                    if let value = response.result.value {
                        if let dic = JSON(value).dictionary{
                            if let status = dic["status"]?.int{
                                if status == 1{
                                    success(JSON(value))
                                }else{
                                    failure()
                                }
                            }
                        }
                    }
                case false:
                    failure()
                }
            }
        }
    
    class func get(url:String,parameters:Dictionary<String,Any>,runHUD:HUDStyle = .none,success: @escaping ((_ json:JSON)->Void),failure:@escaping ((_ error:Error)->Void) ){
        // 显示加载器
        if runHUD == .loading{ showHUD() }
        // 参数处理
        let parameter:Parameters = parameters
        Alamofire.request(url, method: .get, parameters: parameter, encoding: URLEncoding.default, headers:nil).responseJSON { (response) in
            dismissHUD()
            switch response.result.isSuccess {
            case true:
                if let value = response.result.value {
                    success(JSON(value))
                }
            case false:
                failure(response.result.error!)
            }
        }
    }
    
    class func postJsonRPC(url:String,parameters:Dictionary<String,Any>,runHUD:HUDStyle = .loading,success: @escaping ((_ json:JSON)->Void),failure:@escaping ((String)->Void) ){
        // 显示加载器
        if runHUD == .loading{ showHUD() }
        // 参数处理
        let parameter:Parameters = parameters
        manager = Alamofire.SessionManager.default
        manager?.session.configuration.timeoutIntervalForRequest = 10
        Alamofire.request(url, method: .post,
                          parameters: parameter,
                          encoding: JSONEncoding.default,
                          headers:["content-type":"application/json"]).responseJSON { (response) in
                            dismissHUD()
                            switch response.result.isSuccess {
                            case true:
                                if let value = response.result.value {
                                    if let dic = JSON(value).dictionary{
                                        if let status = dic["error"]{
                                            if status == nil {
                                                success(JSON(value))
                                            }else{
                                                failure("")
                                            }
                                        }
                                    }
                                }
                            case false:
                                failure("创建钱包失败".local)
                            }
        }
    }
    
}

extension LHRequest{
    class func showHUD(){ SVProgressHUD.show() }
    
    class func dismissHUD(){ SVProgressHUD.dismiss() }
    
}

