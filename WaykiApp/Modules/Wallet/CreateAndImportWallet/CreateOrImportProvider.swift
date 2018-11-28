

import UIKit
//MARK: - import
class CreateOrImportProvider: NSObject {
    //点击开始导入的逻辑判断
    class func startImportCheck(_ isAgreen:Bool = true, helpStr:String, password:String, makesurePWD:String, complete:@escaping ((_ isSuccess:Bool,_ alertString:String,_ address:String,_ helpStr:String,_ password:String) -> Void)) -> Void {
        var alertMessage:String

        if isAgreen == false{
            alertMessage = "请阅读并同意 服务及隐私条款".local
            complete(false,alertMessage,"","","")
            return
        }
        
        if helpStr.count>0 {
            if (makesurePWD.count>7) || (password.count>7){
                if makesurePWD == password{
                    let helpArr = Bridge.getWalletHelpCodes(from: helpStr)
                    let helpString = Bridge.getWaletHelpString(withCodes: helpArr) as String
                    if Bridge.checkMnemonicCode(Bridge.getWalletHelpCodes(from: helpString)) == true {
                        let arr = Bridge.getAddressAndPrivateKey(withHelp: helpString, password: password)
                        let address = arr![0] as! String
                        //let privateKey = arr![1]
                        if Bridge.addressIsAble(address ){
                            complete(true,"",address,helpString,password)
                            return
                        }else{
                            alertMessage = "请输入正确的助记词".local
                            complete(false,alertMessage,"","","")
                            return
                        }
                    }else{
                        alertMessage = "请输入正确的助记词".local
                        complete(false,alertMessage,"","","")
                        return
                    }
                }else{
                    alertMessage = "两次密码输入不一致".local
                    complete(false,alertMessage,"","","")
                    return
                }
                
            }else{
                alertMessage = "请输入8~16位密码".local
                complete(false,alertMessage,"","","")
                return
            }
        }else{
            alertMessage = "请输入助记词".local
            complete(false,alertMessage,"","","")
            return
        }
    }
    
    //cjlabel 同意服务及点击条款设计
    class func addAttStylesWithLabel(label:CJLabel) ->(secondStr:String,attStyles:[AnyHashable:Any]){
        label.isUserInteractionEnabled = true
        label.isUserInteractionEnabled = true
        label.font = UIFont(name: "PingFangSC-Regular", size: 12)

        let firstStr = "我已认真阅读并同意".local
        let secondStr = " 服务及隐私条款".local
        let pStr = firstStr.appendingFormat(secondStr)
        let muAttstr = NSMutableAttributedString(string: pStr)
        muAttstr.addAttribute(.foregroundColor, value: UIColor.RGBHex(0xb2c3f2), range: NSRange(location: 0, length: firstStr.count))
        muAttstr.addAttribute(.font, value: UIFont.systemFont(ofSize: 12), range: NSRange(location: 0, length: firstStr.count))
        muAttstr.addAttribute(.font, value: UIFont.systemFont(ofSize: 12) as Any, range: NSRange(location: firstStr.count, length: pStr.count - firstStr.count))

        let fontColor = UIColor.RGBHex(0xdee7ff) as Any
        muAttstr.addAttribute(.foregroundColor, value: fontColor, range: NSRange(location: firstStr.count, length: pStr.count - firstStr.count))
        label.attributedText = muAttstr
        let attStyles = [AnyHashable(NSAttributedStringKey.foregroundColor): fontColor]
        
        let truple:(secondStr:String,attStyles:[AnyHashable:Any]) = (secondStr:secondStr,attStyles:attStyles)

        return truple
    }
    

    
}

//MARK: - create
extension CreateOrImportProvider {
    //点击开始创建钱包的判断逻辑
    class func startCreateCheck(_ isAgreen:Bool = true, password:String, makesurePWD:String,complete:@escaping ((_ isSuccess:Bool,_ alertString:String,_ address:String,_ helpStr:String,_ password:String) -> Void)) -> Void {
        var alertMessage:String
        
        if isAgreen == false{
            alertMessage = "请阅读并同意 服务及隐私条款".local
            complete(false,alertMessage,"","","")
            return
        }
        
        if (makesurePWD.count>7&&makesurePWD.count<17) || (password.count>7&&password.count<17){
            if makesurePWD == password{
                let helpcodes = Bridge.getWalletHelpCodes()
                let helpstring = Bridge.getWaletHelpString(withCodes: helpcodes)
                let addressAndPrivateKeyArr = Bridge.getAddressAndPrivateKey(withHelp: helpstring, password: password) as! [String]
                complete(true,"",addressAndPrivateKeyArr[0],helpstring!,password)
                return
            }else{
                alertMessage = NSLocalizedString("两次密码输入不一致", comment: "")
                complete(false,alertMessage,"","","")
                return
            }
        }else{
            alertMessage = NSLocalizedString("请输入8~16位密码", comment: "")
            complete(false,alertMessage,"","","")
            return
        }
    }
    
    //生成提示Label
    class func addRemarkLabel(superview:UIView){
        let ScreenWidth  =  UIScreen.width()

        let xSpace = scale*24.0
        let lWidth = ScreenWidth - 2*xSpace
        let firstTop = scale*16.0 + UIScreen.naviBarHeight()
//        if ScreenWidth == 320 {
//            firstTop = scale*10.0 + UIScreen.naviBarHeight()
//        }
        
        let bcView = UIView()
        bcView.frame = CGRect(x: xSpace, y: firstTop, width: lWidth, height: scale*86)
        bcView.backgroundColor = UIColor.RGBHex(0x101b36)
        superview.addSubview(bcView)
        
        let warningImageView = UIImageView(image: UIImage(named: "wallet_warning"))
        warningImageView.frame = CGRect(x: scale*16, y: scale*16, width: scale*18, height: scale*14)
        bcView.addSubview(warningImageView)
        
        
        let topLabel = UILabel(frame: CGRect(x: warningImageView.right()+scale*8, y: scale*12, width: scale*280, height: scale*18))
        topLabel.font = UIFont(name: "PingFangSC-Regular", size: 13)
        topLabel.textColor = UIColor.RGBHex(0xdee7ff)
        topLabel.numberOfLines = 0
        topLabel.text = "密码用于保护私钥和交易授权，强度非常重要".local
        bcView.addSubview(topLabel)
        
        let secondLabel = UILabel(frame: CGRect(x: topLabel.left(), y: topLabel.bottom()+scale*8, width: topLabel.width(), height: 34))
        secondLabel.font = UIFont(name: "PingFangSC-Regular", size: 12)
        secondLabel.textColor = UIColor.RGBHex(0xb2c3d2)
        secondLabel.numberOfLines = 0
        secondLabel.text = "WaykiChain不存储用户密码，无法提供找回或者重置密码功能，请务必牢记".local
        bcView.addSubview(secondLabel)
        if "localLanguage".local == "2"{
            topLabel.font = UIFont(name: "PingFangSC-Regular", size: 12)
            secondLabel.font = UIFont(name: "PingFangSC-Regular", size: 11)

        }
        topLabel.sizeToFit()
        secondLabel.sizeToFit()

    }

    //检测是否已发放奖励
    class func checkGivingRequest(address:String,needToAlert:@escaping((Bool,Int)->Void)){
        let dic:[String:Any] = ["address":address,"sysCoinRewardType":100]
        let path = httpPath(path: .检查获取奖励_P)
        
        RequestHandler.post(url: path, parameters: dic, runHUD: HUDStyle.loading, isNeedToken: true, success: { (json) in
            if let dic = JSON(json).dictionary{
                if let dataArr = dic["data"]?.arrayValue{
                    if dataArr.count>0{
                        needToAlert(true,givingWusd)
                        return
                    }
                }
            }
            needToAlert(false,0)
        }) { (error) in
            UILabel.showFalureHUD(text: error)
            needToAlert(false,0)
        }
    }
}


