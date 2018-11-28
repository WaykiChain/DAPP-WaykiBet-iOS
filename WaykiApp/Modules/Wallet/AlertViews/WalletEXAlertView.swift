//
//  WalletEXAlertView.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/5.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit


class EXDetailModel{
    //
    var leftName:String = ""
    var leftN:Double = 0
    var rightName:String = ""
    var rightN:Double = 0
    var rate:Double = 0

    var leftBalance:Double = 0      //余额
    var leftMaxAmount:Double = 0    //最大消耗数量（== 余额-手续费-预留手续费随机值）
    
    //手续费相关
    var reserved:Double = 0     //实际计算余额时，预留的手续费随机值
    var gasMin:Double = 0       //显示时使用的fee
    var gasMax:Double = 0
    var fee:Double = 0   //选择的手续费
    
    var isNeedTF:Bool = false//是否需要输入框(是否是wicc兑换wkd)
    var pwd:String = ""//如果需要输入密码则有该值
    
}

//兑换弹框（选择手续费）
class WalletEXAlertView: UIView ,UITextFieldDelegate{
    let contentView:UIView = UIView()//content
    let contentSize:CGSize = CGSize(width: scale*327, height: scale*269)
    let sContentSize:CGSize = CGSize(width: scale*327, height: scale*227)
    var titleLabel:UILabel?
    var feeLabel:UILabel?
    var slider:UISlider?
    var inputTF:UITextField?
    
    var confirmBlock:((EXDetailModel)->Void)?

    var exModel = EXDetailModel()

    init(exModel:EXDetailModel,frame:CGRect){
//        let frame = CGRect(x: 0, y: 0, width: UIScreen.width(), height: UIScreen.height())
        super.init(frame: frame)
        self.exModel = exModel
        self.exModel.fee = exModel.gasMin
        buildView()
        checkMaxFeeAndChange()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//MARK: - public action
extension WalletEXAlertView{
    //显示
    func showAlert(){
        setLayoutData()
        let keyWindow = UIApplication.shared.keyWindow
        self.backgroundColor = UIColor.RGBDecColor(r: 0, g: 0, b: 0, alpha: 0)

        
        for vi in (keyWindow?.subviews)!{
            if vi.isKind(of: WalletEXAlertView.self){
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
extension WalletEXAlertView{
    ///slider滑块相应事件
    @objc private func silderEvent(obj:UISlider){
        
        let spaceGas = exModel.gasMax - exModel.gasMin
        exModel.fee = Double(obj.value) * spaceGas + exModel.gasMin

        // 小费更新
        setGas()
    }
    
    //点击取消
    @objc private func clickCancel(){
        dismissAlert()
    }
    
    //点击确定
    @objc private func clickConfirm(){
        if exModel.isNeedTF {
            if let inputStr = inputTF?.text{
                exModel.pwd = inputStr
            }
            let account = AccountManager.getAccount()
            if exModel.pwd.count < 1{
                UILabel.showFalureHUD(text: "请输入钱包密码".local)
                return
            }
            
            if account.checkPassword(inputPassword: exModel.pwd) == false{
                UILabel.showFalureHUD(text: "密码错误,请重新输入".local)
                return
            }
        }
        
        
        if confirmBlock != nil{
            confirmBlock!(exModel)
        }
        dismissAlert()
    }
    
    //wusd兑wicc 检验最大手续费是否为0，为0，则silder不能滑动
    private func checkMaxFeeAndChange(){
        if exModel.gasMax == 0{
            slider?.isEnabled = false
            feeLabel?.text = "矿工费：".local  + "（活动期间免矿工费）".local
        }
    }
    
}

//MARK: - set data
extension WalletEXAlertView {
    private func setLayoutData(){
       setTitle()
    }
    
    private func setGas(){
        
        let feeStr = String(format: "矿工费：".local + "  %.8f", exModel.fee).removeEndZeros() + " " + exModel.leftName
        feeLabel?.text = feeStr
        checkMax()

    }
    
    //判断是否需要改变消耗的最大值
    private func checkMax(){
        exModel.leftMaxAmount = exModel.leftBalance -  exModel.fee - exModel.reserved
        //如果原显示消耗的币数量 大于 最大可消耗数量（余额减当前手续费）,那么修改
        if exModel.leftN>exModel.leftMaxAmount{
            let leftNumStr = String.init(format: "%f.8", exModel.leftMaxAmount).removeEndZeros()
            let rightNumStr =  String.init(format: "%f.8", exModel.leftMaxAmount*exModel.rate).removeEndZeros()
            
            exModel.leftN = Double(leftNumStr)!
            exModel.rightN = Double(rightNumStr)!
            setTitle()
        }
        
    }
    
    //设置title
    private func setTitle(){
        let leftStr = "\(exModel.leftN)".removeEndZeros() + exModel.leftName
        let rightStr = "\(exModel.rightN)".removeEndZeros() + exModel.rightName
        
        var pStr = "您将支付".local + " " + leftStr + " " + "兑换".local + " " + rightStr
        if "localLanguage".local == "2"  {
            pStr = "You will pay " + leftStr + " to " + rightStr
        }
        
        let muAttStr = NSMutableAttributedString(string: pStr)
        muAttStr.addAttributes([NSAttributedStringKey.foregroundColor:UIColor.RGBHex(0x2c84ff)], range:"".nsRange(from: pStr.range(of: leftStr)!))
        muAttStr.addAttributes([NSAttributedStringKey.foregroundColor:UIColor.RGBHex(0x2c84ff)], range:"".nsRange(from: pStr.range(of: rightStr)!))
        
        titleLabel?.attributedText = muAttStr
    }
}

//MARK: -UI
extension WalletEXAlertView{
    private func buildView(){
        let conSize:CGSize
        if exModel.isNeedTF {
            conSize = contentSize
        }else{
            conSize = sContentSize
        }
        
        let vScale = frame.width/375
        
        let xSpace = frame.width*22/375
        let sXSpace = frame.width*12/375
        let viewX = (frame.size.width - conSize.width)/2.0
        let viewY = (frame.size.height - conSize.height)/2.0
        contentView.frame = CGRect(x: viewX, y: viewY, width: conSize.width, height: conSize.height)
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = 6
        self.addSubview(contentView)
        
        titleLabel = UILabel(frame: CGRect(x: xSpace, y: 0, width: contentView.width() - 2*xSpace, height: vScale*70))
        titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 16)
        titleLabel?.numberOfLines = 0
        titleLabel?.textColor = UIColor.titleColor()
        titleLabel?.textAlignment = .center
        contentView.addSubview(titleLabel!)
        
        feeLabel = UILabel.init(frame: CGRect(x: xSpace, y: (titleLabel?.bottom())! + vScale*8 , width: contentView.width() - 2*xSpace, height:  22*vScale))
        feeLabel?.textColor = UIColor.RGBHex(0x727c8a)
        setGas()
        feeLabel?.font = UIFont.init(name: "PingFangSC-Regular", size: 11)
        contentView.addSubview(feeLabel!)
        
        slider = UISlider()
        slider?.frame = CGRect(x: xSpace, y: feeLabel!.bottom()+8*vScale, width: (feeLabel?.width())!, height: 20*vScale)
        slider?.value = 0
        slider?.maximumTrackTintColor = UIColor.init(white: 0.5, alpha: 0.5)
        slider?.minimumTrackTintColor = UIColor.RGBHex(0x2e86ff)
        slider?.setThumbImage(UIImage(named: "silderThumb"), for: .normal)
        slider?.addTarget(self, action: #selector(silderEvent(obj: )), for: .valueChanged)
        contentView.addSubview(slider!)
        
        let slow = UILabel.init(frame: CGRect(x: xSpace, y: slider!.bottom()+vScale*2 , width:40, height: 18*vScale))
        slow.textColor = UIColor.RGBHex(0xA69A9B)
        slow.text = "慢".local
        slow.font = UIFont.init(name: "PingFangSC-Regular", size: 12)
        contentView.addSubview(slow)
        
        let fast = UILabel.init(frame: CGRect(x: feeLabel!.right() - 40, y: (slider?.bottom())!+vScale*2, width:40, height: 18*vScale))
        fast.textColor = UIColor.RGBHex(0xA69A9B)
        fast.text = "快".local
        fast.textAlignment = .right
        fast.font = UIFont.init(name: "PingFangSC-Regular", size: 12)
        contentView.addSubview(fast)
        
        if exModel.isNeedTF {
            let inputBackView = UIView(frame: CGRect(x: sXSpace, y: fast.bottom()+vScale*14, width: contentView.width() - 2*sXSpace, height: vScale*38))
            inputBackView.layer.borderColor = UIColor.RGBHex(0x2861de).cgColor
            inputBackView.layer.borderWidth = 0.5
            inputBackView.layer.cornerRadius = 3
            inputBackView.backgroundColor = UIColor.RGBHex(0xf6f9fe, alpha: 1)
            contentView.addSubview(inputBackView)

            
            inputTF = UITextField(frame: CGRect(x: sXSpace, y: 0, width: inputBackView.width() - 2*sXSpace, height: vScale*38))
            inputTF?.delegate = self
            let placeholserAttributes = [NSAttributedStringKey.foregroundColor : UIColor.RGBHex(0x2861de, alpha: 0.3)]
            inputTF?.attributedPlaceholder = NSAttributedString(string: "请输入钱包密码".local,attributes: placeholserAttributes)
            inputTF?.isSecureTextEntry = true
            inputTF?.font = UIFont(name: "PingFangSC-Regular", size: 16)
            inputBackView.addSubview(inputTF!)
        }
        
        
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
        confirmBtn.setTitle("确定兑换".local, for: .normal)
        confirmBtn.setTitleColor(UIColor.white, for: .normal)
        confirmBtn.layer.cornerRadius = 3
        confirmBtn.addTarget(self, action: #selector(clickConfirm), for: .touchUpInside)
        confirmBtn.titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 15)
        contentView.addSubview(confirmBtn)
      
    }
    
}
