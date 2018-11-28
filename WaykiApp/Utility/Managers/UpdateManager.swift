//
//  UpdateManager.swift
//  WaykiApp
//
//  Created by louis on 2018/8/24.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit


class UpdateManager: NSObject {
    class func 配置更新(complete:@escaping((Bool)->Void)){
        let path = httpPath(path: .版本检测升级_P)
        let reqDic = [
            "appName": "WaykiChain",
            "channelCode": channelCode,
            "platformType": "ios",
            "verName": appVersion
            ] as [String : Any]
        RequestHandler.post(url: path, parameters: reqDic, runHUD: HUDStyle.loading, isNeedToken: false, success: { (json) in
            showAlert(model: UpdateM.analysisData(json: json), complete: { (isForced) in
                //当 isForced == true 时，是强制更新，且点击了更新按钮
                //这里是点击了按钮（非强制更新（更新、取消）
                if isForced == false{
                    complete(true)
                }
            })
        }) { (error) in
            UILabel.showFalureHUD(text: error)
        }

    }
    
    //当失败时，提醒并
    class func alertAgain(){
        
    }
    
    class func showAlert(model:UpdateM,complete:@escaping((Bool)->Void)){
        if model.是否升级 == -1 {
            complete(false)
            return
        }
        
        let cancleAction = UIAlertAction(title: "取消".local, style: .cancel) { (action) in
            if model.是否升级 == 1{
                showAlert(model: model, complete: complete)
                return
            }
            complete(false)
        }
        
        let sureAction = UIAlertAction(title: "更新".local, style: .default) { (action) in
            if let url = URL(string: model.下载路径){
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            if model.是否升级 == 1{
                complete(true)
                return
            }
            complete(false)
        }
        
        let alertC = UIAlertController(title: "版本更新".local, message: model.内容, preferredStyle: .alert)
        alertC.addAction(cancleAction)
        alertC.addAction(sureAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertC, animated: true, completion: nil)
    }
}

// MARK:- 配置更新
enum UpdateType:Int{
    case 强制 = 0
    case 提示 = 1
}

class UpdateM:NSObject {
    var 内容:String = ""
    var 是否升级:Int = -1 //是否需要强制升级（-1：无需升级，1：需要强制升级，0：选择性升级） ,
    var 版本名称:String = ""
    var 下载路径:String = ""
    
    class func analysisData(json:JSON)->UpdateM{
        let model = UpdateM()
        if let dic = json.dictionary{
            if let code = dic["code"]?.int{
                if code == 0{ // 获取数据成功
                    if let data = dic["data"]?.dictionary{
                        if let content = data["description"]?.string{
                            model.内容 = content.replacingOccurrences(of: "<p>", with: "\r\n")
                        }
                        if let content = data["forceUpgrade"]?.int{
                            model.是否升级 = content
                        }
                        if let content = data["verName"]?.string{
                            model.版本名称 = content
                        }
                 
                        if let content = data["releasePackageUrl"]?.string{
                            model.下载路径 = content
                        }

                    }
                }
            }
        }
        return model
    }
}

