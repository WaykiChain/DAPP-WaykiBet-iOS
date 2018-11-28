//
//  WalletBackupAlertView.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/12.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

enum CheckPWDType{
    case backup
    case exportPK
    case active
    case showTitle
}

//备份助记词、导出私钥的 输入密码alert
class InputPWDAlertView: UIView ,UITextFieldDelegate{
    let contentView:UIView = UIView()//content
    var contentSize:CGSize = CGSize(width: scale*327, height: scale*269)
    
    var showPromptView:UIView?

    var inputTF:UITextField?
    
    var titleStr:String = ""
    var confirmBlock:((String)->Void)?
    
    var checkPWDType = CheckPWDType.backup
    
    var pwd:String = ""
    
    var btnTitles:[String] = []
    init(checkPWDType:CheckPWDType,frame:CGRect,btnTitles:[String]=["取消".local,"确认".local],title:String = ""){
        super.init(frame: frame)
        self.checkPWDType = checkPWDType
        self.btnTitles = btnTitles
        self.titleStr = title
        buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//MARK: - public action
extension InputPWDAlertView{
    //显示
    func showAlert(){

        let keyWindow = UIApplication.shared.keyWindow
        self.backgroundColor = UIColor.RGBDecColor(r: 0, g: 0, b: 0, alpha: 0)
        
        
        for vi in (keyWindow?.subviews)!{
            if vi.isKind(of: InputPWDAlertView.self){
                vi.removeFromSuperview()
            }
        }
        keyWindow?.addSubview(self)
        self.contentView.layer.opacity = 0.5
        self.contentView.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1.0)
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.backgroundColor = UIColor.RGBHex(0x192545, alpha: 0.7)
            self.contentView.layer.opacity = 1
            self.contentView.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
            self.inputTF?.becomeFirstResponder()
        }, completion: nil)
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    //消失
    func dismissAlert(){
        self.layer.opacity = 1.0
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.backgroundColor = UIColor.RGBDecColor(r: 0, g: 0, b: 0, alpha: 0)
            self.contentView.layer.opacity = 0
            self.contentView.layer.transform = CATransform3DMakeScale(0.6, 0.6, 1.0)
        }) { (isSuccess) in
            for vi in self.subviews{
                vi.removeFromSuperview()
            }
            self.removeFromSuperview()
        }
    }
    
}

//MARK: - private Methods
extension InputPWDAlertView{
    
    //点击取消
    @objc private func clickCancel(){

        dismissAlert()
    }
    
    //点击确定
    @objc private func clickConfirm(){
        if let inputStr = inputTF?.text{
            pwd = inputStr
        }
        let account = AccountManager.getAccount()
        if pwd.count < 1{
            UILabel.showFalureHUD(text: "请输入钱包密码".local)
            return
        }
        
        if account.checkPassword(inputPassword: pwd) == false{
            UILabel.showFalureHUD(text: "密码错误,请重新输入".local)
            return
        }
        
        
        if confirmBlock != nil{
            confirmBlock!(pwd)
        }
        dismissAlert()
    }
}

//MARK: -UI
extension InputPWDAlertView{
    private func buildView(){
        let conSize:CGSize
        if checkPWDType == .backup {
            showPromptView = BackupShowPromptView(frame: CGRect(x: 0, y: 0, width: contentSize.width, height: scale*133))
        }else if checkPWDType == .exportPK{
            showPromptView = ExportKeyShowPromptView(frame: CGRect(x: 0, y: 0, width: contentSize.width, height: scale*133))
        }else if checkPWDType == .active{
            contentSize = CGSize(width: scale*327, height: scale*214)
            showPromptView = OnlyPromptView(frame: CGRect(x: 0, y: 0, width: contentSize.width, height: scale*78), promptStr: "激活钱包需要消耗0.0001WICC，激活钱包后可使用钱包内WICC".local)
        }else{
            contentSize = CGSize(width: scale*327, height: scale*196)
            showPromptView = OnlyPromptView(frame: CGRect(x: 0, y: 0, width: contentSize.width, height: scale*60), promptStr: titleStr)
        }
        conSize = contentSize

        let vScale = frame.width/375
        
        let xSpace = frame.width*22/375
        let sXSpace = frame.width*12/375
        let viewX = (frame.size.width - conSize.width)/2.0
        let viewY = (frame.size.height - conSize.height)/3.0
        contentView.frame = CGRect(x: viewX, y: viewY, width: conSize.width, height: conSize.height)
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = 6
        contentView.clipsToBounds = true
        self.addSubview(contentView)
    

        contentView.addSubview(showPromptView!)
        

        let inputBV = UIView(frame: CGRect(x: scale*20, y: (showPromptView?.bottom())! + scale*14, width: contentView.width() - 2*xSpace, height: vScale*38))
        inputBV.backgroundColor = UIColor.RGBHex(0xf6f9fe)
        inputBV.layer.cornerRadius = 3
        inputBV.layer.borderWidth = 0.5
        inputBV.layer.borderColor = UIColor.RGBHex(0x8eaced).cgColor
        contentView.addSubview(inputBV)

        inputTF = UITextField(frame: CGRect(x: scale*10, y: 0, width: inputBV.width(), height: inputBV.height()))
        inputTF?.delegate = self
        let placeholserAttributes = [NSAttributedStringKey.foregroundColor : UIColor.RGBHex(0xb7caf4, alpha:1)]
        inputTF?.attributedPlaceholder = NSAttributedString(string: "请输入钱包密码".local,attributes: placeholserAttributes)
        inputTF?.isSecureTextEntry = true
        inputTF?.backgroundColor = UIColor.RGBHex(0xf6f9fe)
        inputTF?.font = UIFont(name: "PingFangSC-Regular", size: 14)
        inputBV.addSubview(inputTF!)
        
        
        let btnHeight = vScale*44
        let btnWidth = (contentView.width() - sXSpace*3)/2
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.frame = CGRect(x: sXSpace, y: contentView.height()-sXSpace-btnHeight, width: btnWidth, height: btnHeight)
        cancelBtn.backgroundColor = UIColor.RGBHex(0xbfcada)
        cancelBtn.setTitle(btnTitles.first, for: .normal)
        cancelBtn.setTitleColor(UIColor.white, for: .normal)
        cancelBtn.layer.cornerRadius = 3
        cancelBtn.addTarget(self, action: #selector(clickCancel), for: .touchUpInside)
        cancelBtn.titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 15)
        contentView.addSubview(cancelBtn)
        
        
        let confirmBtn = UIButton(type: .custom)
        confirmBtn.frame = CGRect(x: cancelBtn.right() + sXSpace, y: contentView.height()-sXSpace-btnHeight, width: btnWidth, height: btnHeight)
        confirmBtn.setBackgroundImage(UIImage(named: "btn_normal"), for: .normal)
        confirmBtn.setTitle(btnTitles.last, for: .normal)
        confirmBtn.setTitleColor(UIColor.white, for: .normal)
        confirmBtn.layer.cornerRadius = 3
        confirmBtn.addTarget(self, action: #selector(clickConfirm), for: .touchUpInside)
        confirmBtn.titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 15)
        contentView.addSubview(confirmBtn)
        
    }
    
}
