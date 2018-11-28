//
//  TransferAlertView.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/8.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

class TransferInputModel{
    var address:String = ""
    var amount:Double = 0
    var remark:String?
    var fee:Double = 0
    var coin:CoinType = CoinType.wicc
    
    var pwd:String = ""//如果需要输入密码则有该值
    
}

//转账输入框alert
class TransferAlertView: UIView ,UITextFieldDelegate{
    let contentView:UIView = UIView()//content
    let contentSize:CGSize = CGSize(width: scale*327, height: scale*333)

    var titleLabel:UILabel?

    var inputTF:UITextField?
    var confirmBlock:((TransferInputModel)->Void)?
    
    var transferModel:TransferInputModel = TransferInputModel()
    
    init(model:TransferInputModel,frame:CGRect){
        super.init(frame: frame)
        self.transferModel = model
        
        buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//MARK: - public action
extension TransferAlertView{
    //显示
    func showAlert(){
        let keyWindow = UIApplication.shared.keyWindow
        self.backgroundColor = UIColor.RGBDecColor(r: 0, g: 0, b: 0, alpha: 0)
        
        
        for vi in (keyWindow?.subviews)!{
            if vi.isKind(of: TransferAlertView.self){
                vi.removeFromSuperview()
            }
        }
        keyWindow?.addSubview(self)
        self.contentView.layer.opacity = 0.5
        self.contentView.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1.0)
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.backgroundColor = UIColor.RGBHex(0x192545, alpha: 0.7)
            self.contentView.layer.opacity = 1
            self.contentView.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
            self.inputTF?.becomeFirstResponder()
        }, completion: nil)
        UIApplication.shared.keyWindow?.addSubview(self)
    }
    
    //消失
    @objc func dismissAlert(){
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
extension TransferAlertView{
    //点击取消
    @objc private func clickCancel(){
        dismissAlert()
    }
    
    //点击确定
    @objc private func clickConfirm(){

        if let inputStr = inputTF?.text{
            transferModel.pwd = inputStr
        }
        let account = AccountManager.getAccount()
        UILabel.showFalureHUD(text: "请输入钱包密码".local)
        if transferModel.pwd.count < 1{
            return
        }

        if account.checkPassword(inputPassword: transferModel.pwd) == false{
            UILabel.showFalureHUD(text: "密码错误,请重新输入".local)
            return
        }

        
        
        if confirmBlock != nil{
            confirmBlock!(transferModel)
        }
        dismissAlert()
    }
}

//MARK: -UI
extension TransferAlertView{
    private func buildView(){

        
        let titleColor = UIColor.RGBHex(0x475182)
        let vScale = frame.width/375
        
        let xSpace = frame.width*20/375
        let viewX = (frame.size.width - contentSize.width)/2.0
        let viewY = (frame.size.height - contentSize.height)/3.0
        contentView.frame = CGRect(x: viewX, y: viewY, width: contentSize.width, height: contentSize.height)
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = 6
        self.addSubview(contentView)
        
        
        //收款地址
        let firstLabel:UILabel = UILabel(frame: CGRect(x: xSpace, y: xSpace, width: contentView.width() - 2*xSpace, height: xSpace))
        firstLabel.text = "收款地址".local
        firstLabel.font = UIFont.init(name: "PingFangSC-Semibold", size: 14)
        firstLabel.textColor = titleColor
        contentView.addSubview(firstLabel)
        
        let addressLabel = UILabel(frame: CGRect(x: firstLabel.left(), y: firstLabel.bottom()+vScale*6, width: firstLabel.width(), height: vScale*38))
        addressLabel.text = transferModel.address
        addressLabel.numberOfLines = 0
        addressLabel.font = UIFont.init(name: "Helvetica", size: 12)
        addressLabel.textColor = UIColor.RGBHex(0xb3b9c4)
        contentView.addSubview(addressLabel)
        addressLabel.sizeToFit()
        
        
        //转出金额
        let secondLabel = UILabel(frame: CGRect(x: firstLabel.left(), y: firstLabel.bottom() + vScale*50, width: firstLabel.width(), height: xSpace))
        secondLabel.text = "转出金额".local
        secondLabel.font = UIFont.init(name: "PingFangSC-Semibold", size: 14)
        secondLabel.textColor = titleColor
        contentView.addSubview(secondLabel)
        
        
        let amountLabel = UILabel(frame: CGRect(x: firstLabel.left(), y: secondLabel.bottom()+vScale*6, width: firstLabel.width(), height: 12))
        amountLabel.text = "\(transferModel.amount)".removeEndZeros()
        amountLabel.font = UIFont.init(name: "Helvetica", size: 12)
        amountLabel.textColor = UIColor.RGBHex(0x2c84ff)
        contentView.addSubview(amountLabel)
        
        
        //备注
        
        
        let thirdLabel =  UILabel(frame: CGRect(x: firstLabel.left(), y: secondLabel.bottom()+vScale*36, width: firstLabel.width(), height: xSpace))
        thirdLabel.text = "备注".local
        thirdLabel.font = UIFont.init(name: "PingFangSC-Semibold", size: 14)
        thirdLabel.textColor = titleColor
        contentView.addSubview(thirdLabel)
        
        let remarkLabel = UILabel(frame: CGRect(x: firstLabel.left(), y: thirdLabel.bottom()+vScale*6, width: firstLabel.width(), height: 40))
        remarkLabel.font = UIFont.init(name: "Helvetica", size: 12)
        remarkLabel.textColor = UIColor.RGBHex(0xb3b9c4)
        remarkLabel.numberOfLines = 2
        contentView.addSubview(remarkLabel)
        
        if transferModel.remark != nil && transferModel.remark!.count>1 {
            remarkLabel.text = transferModel.remark
        }else{
            remarkLabel.text = "无".local
        }
        remarkLabel.sizeToFit()

      
        let inputBackView = UIView(frame: CGRect(x: xSpace, y: thirdLabel.bottom()+vScale*47, width:firstLabel.width(), height: vScale*38))
        inputBackView.layer.borderColor = UIColor.RGBHex(0x2861de).cgColor
        inputBackView.layer.borderWidth = 0.5
        inputBackView.layer.cornerRadius = 3
        inputBackView.backgroundColor = UIColor.RGBHex(0xf6f9fe, alpha: 1)
        contentView.addSubview(inputBackView)
            
        let sXSpace = vScale * 10
        inputTF = UITextField(frame: CGRect(x: sXSpace, y: 0, width: inputBackView.width() - 2*sXSpace, height: inputBackView.height()))
        inputTF?.delegate = self
        let placeholserAttributes = [NSAttributedStringKey.foregroundColor : UIColor.RGBHex(0x2861de, alpha: 0.3)]
        inputTF?.attributedPlaceholder = NSAttributedString(string: "请输入钱包密码".local,attributes: placeholserAttributes)
        inputTF?.isSecureTextEntry = true
        inputTF?.font = UIFont(name: "PingFangSC-Regular", size: 16)
        inputBackView.addSubview(inputTF!)
    
        
        
        let btnHeight = vScale*44
        let btnWidth = (contentView.width() - sXSpace*3)/2
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.frame = CGRect(x: sXSpace, y: contentView.height()-sXSpace-btnHeight, width: btnWidth, height: btnHeight)
        cancelBtn.backgroundColor = UIColor.RGBHex(0xbfcada)
        cancelBtn.setTitle("取消".local, for: .normal)
        cancelBtn.setTitleColor(UIColor.white, for: .normal)
        cancelBtn.layer.cornerRadius = 3
        cancelBtn.addTarget(self, action: #selector(clickCancel), for: .touchUpInside)
        cancelBtn.titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 15)
        contentView.addSubview(cancelBtn)
        
        
        let confirmBtn = UIButton(type: .custom)
        confirmBtn.frame = CGRect(x: cancelBtn.right() + sXSpace, y: contentView.height()-sXSpace-btnHeight, width: btnWidth, height: btnHeight)
        confirmBtn.backgroundColor = UIColor.RGBHex(0x2e86ff)
        confirmBtn.setTitle("确定".local, for: .normal)
        confirmBtn.setTitleColor(UIColor.white, for: .normal)
        confirmBtn.layer.cornerRadius = 3
        confirmBtn.addTarget(self, action: #selector(clickConfirm), for: .touchUpInside)
        confirmBtn.titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 15)
        contentView.addSubview(confirmBtn)
        
    }
    
}
