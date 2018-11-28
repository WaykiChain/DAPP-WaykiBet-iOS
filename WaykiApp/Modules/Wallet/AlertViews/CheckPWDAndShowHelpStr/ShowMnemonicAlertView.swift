//
//  ShowMnemonicAlertView.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/12.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

//显示助记词、私钥的 alert
class ShowMnemonicAlertView: UIView ,UITextFieldDelegate{
    let contentView:UIView = UIView()//content
    let contentSize:CGSize = CGSize(width: scale*327, height: scale*269)
    
    var btnTitles = ["已备份".local]
    
    var showPromptView:UIView?
    
    var mnemonicLabel:UILabel?
    
    var confirmBlock:((Int,ShowMnemonicAlertView)->Void)?
    
    var checkPWDType = CheckPWDType.backup
    
    var pwd:String = ""
    
    init(checkPWDType:CheckPWDType,pwd:String,frame:CGRect){
        super.init(frame: frame)
        self.checkPWDType = checkPWDType
        self.pwd = pwd
        buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//MARK: - public action
extension ShowMnemonicAlertView{
    //显示
    func showAlert(){
        
        let keyWindow = UIApplication.shared.keyWindow
        self.backgroundColor = UIColor.RGBDecColor(r: 0, g: 0, b: 0, alpha: 0)
        
        
        for vi in (keyWindow?.subviews)!{
            if vi.isKind(of: ShowMnemonicAlertView.self){
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
extension ShowMnemonicAlertView{
    
    
    //点击按钮
    @objc private func clickConfirm(btn:UIButton){
        
        
        if confirmBlock != nil{
            confirmBlock!(btn.tag,self)
        }
        dismissAlert()
    }
    
}

//MARK: -UI
extension ShowMnemonicAlertView{
    private func buildView(){
        let conSize:CGSize
        conSize = contentSize
        var showText:String = ""
        if checkPWDType == .backup {
            showPromptView = BackupShowPromptView(frame: CGRect(x: 0, y: 0, width: contentSize.width, height: scale*133))
            btnTitles = ["取消".local,"复制".local]
            showText = AccountManager.getAccount().getHelpString(password: pwd)
        }else if checkPWDType == .exportPK{
            showPromptView = ExportKeyShowPromptView(frame: CGRect(x: 0, y: 0, width: contentSize.width, height: scale*133))
            btnTitles = ["取消".local,"复制".local]
            showText = AccountManager.getAccount().getPrivateKey(password: pwd)
        }else{
            showPromptView = UIView()
        }
        
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

        let inputBV = UIView(frame: CGRect(x: scale*20, y: (showPromptView?.bottom())!+4*scale, width: contentView.width() - 2*xSpace, height: vScale*63))
        inputBV.backgroundColor = UIColor.RGBHex(0xf6f9fe)
        inputBV.layer.cornerRadius = 3
        inputBV.layer.borderWidth = 0.5
        inputBV.layer.borderColor = UIColor.RGBHex(0x8eaced).cgColor
        contentView.addSubview(inputBV)
        
        mnemonicLabel = UILabel(frame: CGRect(x: scale*10, y: 0, width: inputBV.width() - 2*scale*10, height: inputBV.height()))
        mnemonicLabel?.text = showText
        mnemonicLabel?.numberOfLines = 0
        mnemonicLabel?.font = UIFont.init(name: "PingFangSC-Regular", size: 14)
        mnemonicLabel?.textColor = UIColor.RGBHex(0x475a82)
        inputBV.addSubview(mnemonicLabel!)


        
        let btnWidth = scale*146
        let btnHeight = scale*44
        
        var btnSpace = (contentSize.width - btnWidth*CGFloat(btnTitles.count))/(CGFloat(btnTitles.count)+1)
        if btnSpace<0 {
            btnSpace = 0
        }
        let btnLeftX = btnSpace

        for i in 0..<btnTitles.count{
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: btnLeftX+CGFloat(i)*(btnSpace+btnWidth), y: contentView.height()-sXSpace-btnHeight, width: btnWidth, height: btnHeight)
            btn.setBackgroundImage(UIImage(named: "btn_normal"), for: .normal)
            btn.setTitle(btnTitles[i], for: .normal)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.layer.cornerRadius = 3
            btn.tag = i
            btn.addTarget(self, action: #selector(clickConfirm(btn:)), for: .touchUpInside)
            btn.titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 15)
            contentView.addSubview(btn)
            
            if btnTitles.count>1&&i==0{
                btn.backgroundColor = UIColor.RGBHex(0xbfcada)
                btn.setBackgroundImage(UIImage(named: ""), for: .normal)
            }
        }
        
        
    }
    
}
