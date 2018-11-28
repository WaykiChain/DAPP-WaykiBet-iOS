//
//  GetAppInfoManager.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/10.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

let GetAppInfoKey:String = "GetAppInfoManager"

class GetAppInfoManager: NSObject {
    static let tabbar_path:String = NSHomeDirectory()+"/Documents/tabbar_path.data"
    
    
    //从后台获取app tabber配置信息
    class func getTabbarDetail(success:@escaping(([TabbarItemModel]) ->Void)){
        let models = getModels()
        if models.count>0 {
            //如果本地存储有信息，则直接返回，然后再异步请求数据,之后更新本地信息
            success(models)
            requestGet { (arr) in
                saveModels(models: (arr))
            }
            return
        }else{
            //如果本地没有，则需要请求数据，直到数据返回
            requestGet { (arr) in
                saveModels(models: (arr))
                success(arr)
            }
        }
        
    }
    
    class func getTestModels() -> [TabbarItemModel]{
        
        let model1 = TabbarItemModel()
        model1.title = "竞猜"
        model1.redirectUrl = netpro+hostName+port+"/guess/"
        model1.type = 100
        let model2 = TabbarItemModel()
        model2.title = "钱包"
        model2.redirectUrl = ""
        model2.type = 200
        let model3 = TabbarItemModel()
        model3.title = "我"
        model3.type = 100
        model3.redirectUrl = netpro+hostName+port+"/mine"
        return [model1,model2,model3]
    }
    
    

}
    
extension GetAppInfoManager{
    //保存在本地
    class func saveModels(models:[TabbarItemModel]){

        NSKeyedArchiver.archiveRootObject(models,toFile:tabbar_path)
    }
    
    /// 从本地获取tabbar信息
    class func getModels() -> [TabbarItemModel]{
        if let models:[TabbarItemModel] = NSKeyedUnarchiver.unarchiveObject(withFile: tabbar_path) as? [TabbarItemModel] {
            return models
        }
        return []
    }
    
    //从后台获取app tabber配置信息,存储在本地
    class func requestGet(success:@escaping(([TabbarItemModel])->Void)){
        RequestHandler.get(url: httpPath(path: HTTPPath.查询底部菜单), parameters: [:], runHUD: HUDStyle.loading, isNeedToken: true, success: {(json) in
            if let dic = JSON(json).dictionary{
                if let dataArr = dic["data"]?.arrayValue{
                    var models:[TabbarItemModel] = []
                    for i in 0..<dataArr.count{
                        if let aDic = dataArr[i].dictionaryObject{
                            let model = TabbarItemModel()
                            model.setValuesForKeys(aDic)
                            models.append(model)
                        }
                    }
                    var sortArr:[TabbarItemModel] = []
                    //从小到大
                    sortArr = models.sorted(by: { (model1, model2) -> Bool in
                        if model1.displayOrder>model2.displayOrder{
                            return false
                        }else{
                            return true
                        }
                    })
 
                    success(sortArr)
                }
            }
            
        }) { (error) in
            UILabel.showFalureHUD(text: error)
        }
    }
}


@objcMembers
class TabbarItemModel:NSObject,NSCoding{
    
    var id: Int = 0
    var version: String = ""
    var title: String = ""
    var type: Int = 0
    var displayOrder: Int = 0
    var selectImageUrlSecond: String = ""
    var selectImageUrlThird: String = ""
    var selectImage:UIImage?
    
    var imageUrlSecond: String = ""
    var imageUrlThird: String = ""
    var normalImage:UIImage?
    
    var redirectUrl: String = ""
    //并发队列，依赖于global
    var queue:DispatchQueue?
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(version, forKey: "version")
        aCoder.encode(normalImage, forKey: "normalImage")
        aCoder.encode(selectImage, forKey: "selectImage")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(displayOrder, forKey: "displayOrder")
        aCoder.encode(selectImageUrlSecond, forKey: "selectImageUrlSecond")
        aCoder.encode(selectImageUrlThird, forKey: "selectImageUrlThird")

        aCoder.encode(imageUrlSecond, forKey: "imageUrlSecond")
        aCoder.encode(imageUrlThird, forKey: "imageUrlThird")
        aCoder.encode(redirectUrl, forKey: "redirectUrl")
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeInteger(forKey: "id")
        version = aDecoder.decodeString(forKey: "version")
        selectImage =  aDecoder.decodeObject(forKey: "selectImage") as? UIImage
        normalImage =  aDecoder.decodeObject(forKey: "normalImage") as? UIImage

        title = aDecoder.decodeString(forKey: "title")
        selectImageUrlSecond = aDecoder.decodeString(forKey: "selectImageUrlSecond")
        selectImageUrlThird = aDecoder.decodeString(forKey: "selectImageUrlThird")

        imageUrlSecond = aDecoder.decodeString(forKey: "imageUrlSecond")
        imageUrlThird = aDecoder.decodeString(forKey: "imageUrlThird")

        redirectUrl = aDecoder.decodeString(forKey: "redirectUrl")
        type = aDecoder.decodeInteger(forKey: "type")
        displayOrder = aDecoder.decodeInteger(forKey: "displayOrder")
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if value == nil{
            return
        }

        super.setValue(value, forKey: key)
    }
    
    //下载图片
    func downloadImage(success:@escaping(()->Void)){
        //开启group，分别下载图片
        if #available(iOS 10.0, *) {
            queue = DispatchQueue.init(label: "com.wayki.downloadimage", qos: DispatchQoS.default, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.workItem, target: DispatchQueue.global())
        } else {
            queue = DispatchQueue.global()
        }
        let group = DispatchGroup()
        queue?.async(group: group, qos: .default, flags: [], execute: {
            if self.normalImage == nil{
                var imageUrl:String = ""
                if UIScreen.phoneIs3x(){
                    imageUrl = self.imageUrlThird
                }else{
                    imageUrl = self.imageUrlSecond
                }
                
                //下载
                UIImageView().kf.setImage(with: URL.init(string: imageUrl), placeholder: nil, options: nil, progressBlock: nil) { (image, error, cache, url) in
                    
                    let image1 = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal);
                    self.normalImage = image1!
                }
                
            }
        })
       queue?.async(group: group, qos: .default, flags: [], execute: {
            if self.selectImage == nil{
                var selectedUrl:String = ""
                if UIScreen.phoneIs3x(){
                    selectedUrl = self.selectImageUrlThird
                }else{
                    selectedUrl = self.selectImageUrlSecond
                }
                UIImageView().kf.setImage(with: URL.init(string: selectedUrl), placeholder: nil, options: nil, progressBlock: nil) { (image, error, cache, url) in
                    let image1 = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal);
                    self.selectImage = image1!
                }
            }
        })
        //执行完上面的两个耗时操作, 在进行存储行为
        group.notify(queue: DispatchQueue.global()) {
            success()
        }

        
            
        
    }
    
    
}
