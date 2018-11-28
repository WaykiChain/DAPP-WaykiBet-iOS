//
//  ProoeritesManager.swift
//  WaykiApp
//
//  Created by sorath on 2018/10/2.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

//errorCode 文本翻译
class ProperitesManager: NSObject {
    var fileDic:[String:String] = [:]
    static let instance = ProperitesManager()
    
    override init() {
        super.init()
        fileDic = getFromProperites()
    }
    
    //从单例中获取数据
    func translate(code:Int) ->String{
        let result:String
        if let str = fileDic["\(code)"]{
            result = str
        }else{
            result = ""
        }
        return result
    }
    
    //从资源树中获取
    private func getFromProperites() ->[String:String]{
        var dic:[String:String] = [:]
        let fileName = getFilePath()
        if let dataFile = try? String.init(contentsOfFile: fileName, encoding: String.Encoding.utf8){
            let dataArr = dataFile.components(separatedBy: "\n")
            for str in dataArr{
                let rows = str.components(separatedBy: "=")
                if rows.count == 2{
                    dic[rows.first!] = rows.last
                }
            }
        }
        
        return dic
    }

    //文件路径
    private func getFilePath() ->String{
        let pathName:String
        if "localLanguage".local == "0" || "localLanguage".local == "1"{
            //中文
            pathName = "i18n-cn"
        }else{
            //默认英文
            pathName = "i18n-en"
        }
        var file  =  ""
        if Bundle.main.path(forResource: pathName, ofType: "properties") != nil{
            file = Bundle.main.path(forResource: pathName, ofType: "properties")!
        }
        return file
    }
    
}
