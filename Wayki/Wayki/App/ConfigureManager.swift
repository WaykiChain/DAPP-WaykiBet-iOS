

import UIKit

// MARK:- 配置节点服务器

/*
 搭建维基链节点的教程:
 https://pan.baidu.com/s/1ZHnxEb095837rc_A05WvGQ   密码:h3cb
 */

let nodeURL:String =  "http://<UserName>:<Password>@Host:Port/"

// MARK:- 配置赛事信息服务器
let netpro = "https://"
let hostName = "Host"
let port = ":Port"
func httpPath(path:HTTPPath)->String{ return  netpro+hostName+port+path.rawValue }

// MARK:- 配置图片
let allimagePath:String = ""

// App的三方库账号配置
class ConfigureManager: NSObject {
    static func configureLibrary(){
        ConfigureManager.configure3DTouch()
    }
}

// MARK:- 配置3DTouch
extension ConfigureManager{
    
    static func configure3DTouch(){
        let qrCode = UIApplicationShortcutItem(type: "receive", localizedTitle: "收款",localizedSubtitle: "收款地址",icon: UIApplicationShortcutIcon.init(templateImageName: "touch_qr"))
        let transfer = UIApplicationShortcutItem(type: "transfer", localizedTitle: "转账",localizedSubtitle: "快速转账",icon: UIApplicationShortcutIcon.init(templateImageName: "touch_transfer"))
        UIApplication.shared.shortcutItems = [qrCode,transfer]
    }

    static func handle3DTouchAction(type:String){// 3D Touch 事件处理
        if AccountManager.getAccount().address == ""{ return }
        if type == "receive"{

        }else if type == "transfer" {

        }
    }

}

// MARK:- 配置更新
enum UpdateType:Int{
    case 强制 = 0
    case 提示 = 1
}

class UpdateM:NSObject {
    var 内容:String = ""
    var 强制升级:Bool = false
    var 版本名称:String = ""
    var 更新时间:String = ""
    var 下载路径:String = ""
    var 版本号:String = ""
    
    class func analysisData(json:JSON)->UpdateM{
        let model = UpdateM()
        if let dic = json.dictionary{
            if let status = dic["status"]?.int{
                if status == 1{ // 获取数据成功
                    if let result = dic["result"]?.dictionary{
                        if let content = result["content"]?.string{
                            model.内容 = content.replacingOccurrences(of: "<p>", with: "\r\n")
                        }
                        if let content = result["forceupdate"]?.bool{
                            model.强制升级 = content
                        }
                        if let content = result["name"]?.string{
                            model.版本名称 = content
                        }
                        if let content = result["time"]?.string{
                            model.更新时间 = content
                        }
                        if let content = result["url"]?.string{
                            model.下载路径 = content
                        }
                        if let content = result["version"]?.string{
                            model.版本号 = content
                        }
                    }
                }
            }
        }
        return model
    }
}

