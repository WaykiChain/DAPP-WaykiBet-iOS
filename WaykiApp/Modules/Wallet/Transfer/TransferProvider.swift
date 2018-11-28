//
//  TransferProvider.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/7.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit
import AVFoundation
class TransferProvider: NSObject {
    //入口，逻辑判断
    class func sureTransfer(tAddress:String?,amount:String?,remark:String?,fee:Double,coinType:CoinType,vc:UIViewController){
        var amountTFText = amount
        
        //判断是否激活，没有则提示激活
        if ActiviteManager.checkIsActivityAndActivity(vc: vc) == false{

            return
        }

   
        if tAddress == nil || tAddress == "" {
            UILabel.showFalureHUD(text: "请输入钱包地址".local)
            return
        }
        if walletNetConfirure == 0{
            //主网
            if tAddress?.first != "W"{
                UILabel.showFalureHUD(text: "钱包地址不正确".local)
                return
            }
        }else{
            if tAddress?.first != "w"{
                UILabel.showFalureHUD(text: "钱包地址不正确".local)
                return
            }
        }


        if amountTFText == nil || amountTFText == "" {
            UILabel.showFalureHUD(text: "请输入转账金额".local)

            return
        }

        if amountTFText == "." {
            amountTFText = "0.0"
        }

        if (amountTFText?.toFloat())! < CGFloat(0.001){
            UILabel.showFalureHUD(text: "最低转账金额为0.001".local)

            return
        }


        let amountF:Double = Double(amountTFText!)!
        var valueAmount:Double
        if coinType == CoinType.wicc {
            valueAmount = AccountManager.getAccount().wiccSumAmount
        }else{
            valueAmount = AccountManager.getAccount().tokenSumAmount
        }
        if amountF == 0 {
            UILabel.showFalureHUD(text: "转账金额不能为0".local)

            return;
        }

        if tAddress == AccountManager.getAccount().address{
            UILabel.showFalureHUD(text: "转账地址不能与本地地址相同".local)

            return
        }
        let isValid:Bool = Bridge.addressIsAble(tAddress)
        if isValid {
            if amountF <= valueAmount {

                
                if (valueAmount - amountF >= fee) {
                    alertInputPWD(tAddress: tAddress!, amount: amountF, remark: remark, fee: fee, coinType: coinType)
                }else{
                    UILabel.showFalureHUD(text: "当前余额不足".local)
                }
            }else{
                UILabel.showFalureHUD(text: "当前余额不足".local)
            }
        }else{
            UILabel.showFalureHUD(text: "收款地址无效".local)
        }
    }
    
    
    //弹出输入密码框
    class func alertInputPWD(tAddress:String,amount:Double,remark:String?,fee:Double,coinType:CoinType){
        let model = TransferInputModel()
        model.address = tAddress
        model.amount = amount
        model.remark = remark
        model.coin = CoinType.wicc
        model.fee = fee
        let v = TransferAlertView(model: model, frame: CGRect(x: 0, y: 0, width: UIScreen.width(), height: UIScreen.height()))
        v.showAlert()
        v.confirmBlock = { (vModel) in
            self.auto(model: vModel)
        }
    }
    // 相机权限
    class func isRightCamera(right:@escaping(()->Void)){
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus != .restricted && authStatus != .denied {
            right()
        }else{
            if UIApplication.shared.keyWindow?.rootViewController?.presentedViewController != nil {
                if (UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.isKind(of: UIAlertController.self))! {
                    UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.dismiss(animated: false, completion: nil)
                }
            }
            //没有相机权限
            let alertC = UIAlertController(title: "提示".local, message: "尚未开启相机权限,您可以去设置中开启".local, preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "取消".local, style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "确定".local, style: .default) { (action) in
                let url =  URL(string: UIApplicationOpenSettingsURLString)
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                } else {
                   UIApplication.shared.openURL(url!)
                }
            }
            alertC.addAction(cancelAction)
            alertC.addAction(okAction)
            UIApplication.shared.keyWindow?.rootViewController?.present(alertC, animated: true, completion: nil)
        }
    }

}

//MARK: - request
extension TransferProvider{
     private class func auto(model:TransferInputModel){
        WalletCommonRequestManager.getVaildHeight(){ (vaildHeight) in
            //签名，从api中获取
            let account = AccountManager.getAccount()
            let helpString = account.getHelpString(password: model.pwd)
            var hex:String! = ""
            hex = Bridge.getTransfetWICCHex(withHelpStr: helpString, withPassword:model.pwd, fees:model.fee , validHeight: vaildHeight, srcRegId: account.regId, destAddr: model.address, transferValue: model.amount)
            print(hex)
            let remarkStr = model.remark
            self.requestTransfer(hex:hex,remark:remarkStr!,address: account.address)
        }
    }
    
    //签名 发起请求
    private class func requestTransfer(hex:String,remark:String?,address:String){
        let path = httpPath(path: .转账和激活_P)
        var para:Dictionary<String,Any> = [:]
        para["txRemark"] = remark
        para["rawtx"] = hex
        para["type"] = 200
        para["wiccAddress"] = address

        RequestHandler.post(url: path, parameters: para, success: { (json) in
            NotificationCenter.default.post(name: NSNotification.Name.init("Noti_transferSuccess"), object: nil)
        }) { (error) in
            UILabel.showFalureHUD(text: error)
        }
    }

    //获取余额
    class func getWiccSum(success:@escaping(() ->Void)){

        WalletProvider.requestAccountInfo { (model) in
            let account = AccountManager.getAccount()
            account.wiccSumAmount = model.wiccModel.balanceAvailable
            AccountManager.saveAccount(account: account)
        }
    }
}

