//
//  WalletM_CardView.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/4.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit
class ExchangeModel:NSObject{
    var rate :Double = 0                        //汇率
    var coinToTokenRate:Double = 0
    var tokenToCoinRate:Double = 0
    
    var expendCoin:CoinType = CoinType.wicc     //消耗的币种
    var getCoin:CoinType = CoinType.token       //兑换的币种
    
    var expendAmount:Double = 0;                //消耗币种的数量
    var getAmount:Double = 0;                   //兑换币种的数量
    
    
    //手续费(这里的是默认最小手续费)
    var gasCoin:CoinType = CoinType.wicc        //手续费币种(应与消耗币种相同)
    var gasAmount:Double = 0                    //手续费币种数量
    var tokenFee:Double = 0
    var coinFee:Double = 0

    
    var maxAmount:Double = 0                    //最大可消耗数量
    
    //翻转兑换关系
    func turnOver(){
        let oldExpendCoin = expendCoin
        
        expendCoin = getCoin
        expendAmount = 0
        gasCoin = expendCoin
        
        getAmount = 0
        getCoin = oldExpendCoin
        
        setRateAndFee()

        
    }
    
    //根据 消耗和兑换币种 判断 汇率 和 最大可消耗额度
    func setRateAndFee(){
        if  expendCoin == CoinType.wicc &&  getCoin == CoinType.token{
            rate =  coinToTokenRate
            gasAmount = coinFee
            maxAmount = AccountManager.getAccount().wiccSumAmount - coinFee
            
        }else if  expendCoin == CoinType.token &&  getCoin == CoinType.wicc{
            rate =  tokenToCoinRate
            gasAmount = tokenFee
            maxAmount = AccountManager.getAccount().tokenSumAmount - tokenFee
            
        }
        gasCoin = expendCoin
        if maxAmount<0{
            maxAmount = 0
        }
    }
    
}


class WalletM_CardView: UIView,UITextFieldDelegate {
    let xSpace = scale*14
    
    var exModel = ExchangeModel()
    
    let promptLabel:UILabel = UILabel()
    
    let inputTF:UITextField = UITextField()
    let inputCoinNameLabel = UILabel()
    
    let outputLabel:UILabel = UILabel()
    let outputCoinNameLabel = UILabel()
    
    var exchangeBlock:((ExchangeModel) ->Void)?
    var turnOverBlock:((Bool)->Void)?
    var clickRecordBlock:(() ->Void)?

    init(frame: CGRect,expendCoin:CoinType = CoinType.wicc,expendAmount:Double = 0,getCoin:CoinType = CoinType.token,coinToTokenRate:Double,tokenToCoinRate:Double,coinMinFee:Double,tokenMinFee:Double) {
        super.init(frame: frame)
        self.exModel.expendCoin = expendCoin
        self.exModel.expendAmount = expendAmount
        self.exModel.getCoin = getCoin
        self.exModel.coinToTokenRate = coinToTokenRate
        self.exModel.tokenToCoinRate = tokenToCoinRate
        self.exModel.coinFee = coinMinFee
        self.exModel.tokenFee = tokenMinFee

        self.exModel.setRateAndFee()

        buildView()
        //设置显示0
        setShowData()

        self.clipsToBounds = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK: - data
extension WalletM_CardView{
    
    //设置新的汇率
    func setNewData(coinToTokenRate:Double,tokenToCoinRate:Double,coinMinFee:Double,tokenMinFee:Double,reservedCoin:Double){
        setNewData(expendAmount: self.exModel.expendAmount, coinToTokenRate: coinToTokenRate, tokenToCoinRate: tokenToCoinRate,coinMinFee:coinMinFee,tokenMinFee:tokenMinFee,reservedCoin:reservedCoin)
    }

    //设置新的汇率
    func setNewData(expendAmount:Double,coinToTokenRate:Double,tokenToCoinRate:Double,coinMinFee:Double,tokenMinFee:Double,reservedCoin:Double){
        self.exModel.expendAmount = expendAmount
        self.exModel.coinToTokenRate = coinToTokenRate
        self.exModel.tokenToCoinRate = tokenToCoinRate
        self.exModel.coinFee = coinMinFee + reservedCoin    //最小手续费+预留余额，来作为计算余额的基准
        self.exModel.tokenFee = tokenMinFee
        self.exModel.setRateAndFee()
        setShowData()

    }
    
    //重置
    func reset(){
        self.exModel.expendAmount = 0
        self.exModel.getAmount = 0
        setShowData()
    }
    
    //设置显示数据
    private func setShowData(){

        inputTF.text = "\(self.exModel.expendAmount)".removeEndZeros()
        if self.exModel.expendAmount == 0{
            inputTF.text = nil
        }
        inputCoinNameLabel.text = self.exModel.expendCoin.rawValue
        outputLabel.text = "\(self.exModel.getAmount)".removeEndZeros()
        outputCoinNameLabel.text = self.exModel.getCoin.rawValue
    }

    //兑换
    private func exchange(_ expend:Double) ->Double{
        let getAmountStr = String.init(format: "%.8f", expend*self.exModel.rate).removeEndZeros()
        self.exModel.getAmount = Double(getAmountStr)!
        return self.exModel.getAmount
    }

}

//MARK: - action
extension WalletM_CardView{
    //兑换翻转
    @objc func clickTurnOverBtn(btn:UIButton){
        self.exModel.turnOver()
        
        setShowData()
        startTurnOverAnimation(vi: btn)
        if turnOverBlock != nil {
            var isW2u:Bool = false
            if self.exModel.expendCoin == CoinType.wicc&&self.exModel.getCoin == CoinType.token{
                isW2u = true
            }
            turnOverBlock!(isW2u)

        }
    }
    
    //点击兑换
    @objc func clickConfirm(){
        self.inputTF.resignFirstResponder()
        
        if self.superview?.viewController() is WalletVC{
            let vc = self.superview?.viewController() as! WalletVC
            if vc.clickAndCheck() == false{
                return
            }
        }

        if exModel.getAmount==0||exModel.expendAmount==0 {
            UILabel.showFalureHUD(text: "兑换金额不能为0".local)
            return
        }
        
        if exchangeBlock != nil{
            exchangeBlock!(self.exModel)
        }
    }
    
    //点击记录
    @objc func clickRecord(){
        if clickRecordBlock != nil{
            clickRecordBlock!()
        }
    }
}


//MARK: - UITextFieldDelegate
extension WalletM_CardView{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == inputTF {
            let flag =  string.formartInputMoney(inputMoney: textField.text!, inputCharacter: string)

            if flag == false{
                return false
            }
            let str:NSString = textField.text! as NSString

            let showStr = str.replacingCharacters(in: range, with: string)
            let strArr = showStr.components(separatedBy: ".")

            if((strArr.last?.count)! > 8  ){
                //最大输入8位数
            }else{
                //显示消耗
                textField.text = showStr
                checkAndAlert(showStr: showStr)
    
            }


            return false
        }
        return true
    }
    
    private func checkAndAlert(showStr:String){
        //判断是否超过最大额度
        if let a = Double(showStr){
            if a > self.exModel.maxAmount{
                inputTF.text = String.init(format: "%.8f",self.exModel.maxAmount).removeEndZeros()
                UILabel.showFalureHUD(text: "您只能兑换".local + (inputTF.text)!)
            }
            //设值兑换和消耗
            self.exModel.expendAmount =  Double(inputTF.text!)!
            let getAmount = exchange(Double(inputTF.text!)!)
            outputLabel.text = "\(getAmount)".removeEndZeros()
        }
    }
}
//MARK: - animation
extension WalletM_CardView{
    private func startTurnOverAnimation(vi:UIView){
//        let _trans = vi.transform;
//        let rotate = acosf(Float(_trans.a));
//        let rotationAngle = CGFloat(rotate) + CGFloat(Double.pi)
//
//        UIView.animate(withDuration: 0.3, animations: {
//
//            vi.transform =  CGAffineTransform(rotationAngle: rotationAngle);
//
//        }) { (isComplete) in
//
//        }
        
        let animation = CABasicAnimation.init(keyPath: "transform.rotation.z")
        animation.fromValue = Double.pi
        animation.toValue = 0
        animation.duration = 0.3;
        animation.autoreverses = false
        animation.fillMode = kCAFillModeForwards;
        animation.repeatCount = 1;
        vi.layer.add(animation, forKey: nil)
  
    }
}

//MARK: - UI
extension WalletM_CardView{
    private func buildView(){
        self.layer.cornerRadius = 6
        self.backgroundColor = UIColor.white
        self.addGradientLayer(colors: [UIColor.white.cgColor,UIColor.RGBHex(0xe5ecff).cgColor])
        let firstTitleLabel = UILabel(frame: CGRect(x: xSpace, y: scale*12, width: 60, height: scale*16))
        firstTitleLabel.textColor = UIColor.RGBHex(0x1f3564, alpha: 0.35)
        firstTitleLabel.text = "消耗".local
        firstTitleLabel.font = UIFont.init(name: "PingFangSC-Medium", size: 11)
        self.addSubview(firstTitleLabel)
        
        let pX = firstTitleLabel.right()
        promptLabel.frame = CGRect(x: pX, y: firstTitleLabel.top(), width: frame.width - 2*pX, height: firstTitleLabel.height())
        promptLabel.textColor = UIColor.RGBHex(0xff6e6c, alpha: 1)
        promptLabel.textAlignment = .center
        promptLabel.font = UIFont.init(name: "PingFang SC", size: 11)
        self.addSubview(promptLabel)
        
        //消耗币种的金额
        inputTF.frame = CGRect(x: xSpace, y: firstTitleLabel.bottom(), width: scale*267, height: scale*30)
        inputTF.font = UIFont.init(name: "PingFangSC-Regular", size: 16)
        inputTF.textColor = UIColor.RGBHex(0x1a2741)
        inputTF.delegate = self
        inputTF.keyboardType = .decimalPad
        inputTF.attributedPlaceholder = NSAttributedString(string: "输入您的兑换金额".local, attributes: [NSAttributedStringKey.foregroundColor : UIColor.RGBHex(0xd7dbe7)] as [NSAttributedStringKey:Any])
        self.addSubview(inputTF)
        
        let line = UIView(frame: CGRect(x: xSpace, y: inputTF.bottom() + scale*6, width: inputTF.width(), height: 1))
        line.backgroundColor = UIColor.lineColor()
        self.addSubview(line)
        
        
        let secondTitleLabel = UILabel(frame: CGRect(x: xSpace, y: line.bottom() + scale*6, width: 60, height: scale*16))
        secondTitleLabel.textColor = UIColor.RGBHex(0x1f3564, alpha: 0.35)
        secondTitleLabel.text = "兑换".local
        secondTitleLabel.font = UIFont.init(name: "PingFangSC-Medium", size: 11)
        self.addSubview(secondTitleLabel)
        
        //兑换币种的金额
        outputLabel.frame = CGRect(x: inputTF.left(), y: secondTitleLabel.bottom(), width: inputTF.width(), height: scale*30)
        outputLabel.textColor = UIColor.RGBHex(0x1a2741)
        outputLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 16)
        self.addSubview(outputLabel)
        
        
        inputCoinNameLabel.frame = CGRect(x: inputTF.right() +  scale*4, y: inputTF.top(), width: scale*55, height: inputTF.height())
        inputCoinNameLabel.font = UIFont.init(name: "Helvetica-BoldOblique", size: 12)
        inputCoinNameLabel.textAlignment = .center
        self.addSubview(inputCoinNameLabel)
        
        
        outputCoinNameLabel.frame = CGRect(x: outputLabel.right() +  scale*4, y: outputLabel.top(), width: scale*55, height: outputLabel.height())
        outputCoinNameLabel.font = UIFont.init(name: "Helvetica-BoldOblique", size: 12)
        outputCoinNameLabel.textAlignment = .center
        self.addSubview(outputCoinNameLabel)
        
        var btnHeight = outputCoinNameLabel.top() - inputCoinNameLabel.bottom()
        if btnHeight>scale*21 {
            btnHeight = scale*21
        }
        
        //翻转按钮
        let turnoverBtn = UIButton(type: .custom)
        turnoverBtn.frame = CGRect(x: inputCoinNameLabel.center.x-btnHeight/2, y: inputCoinNameLabel.bottom(), width: btnHeight, height: btnHeight)
        if isDomestic == true{
            //国内,不可翻转，只能wicc兑换token
            turnoverBtn.setBackgroundImage(UIImage(named: "arrow_newDown"), for: .normal)
            turnoverBtn.setBackgroundImage(UIImage(named: "arrow_newDown"), for: .highlighted)
        }else{
            //国外，可翻转兑换
            turnoverBtn.setBackgroundImage(UIImage(named: "ex_expend"), for: .normal)
            turnoverBtn.setBackgroundImage(UIImage(named: "ex_expend"), for: .highlighted)
            turnoverBtn.addTarget(self, action: #selector(clickTurnOverBtn(btn:)), for: .touchUpInside)
        }

        self.addSubview(turnoverBtn)
        
        //兑换按钮
        let confirmBtn = UIButton(type: .custom)
        confirmBtn.frame = CGRect(x: xSpace, y: outputLabel.bottom()+scale*16, width: scale*230, height: scale*40)
        confirmBtn.setBackgroundImage( UIImage(named: "btn_normal"), for: .normal)
        confirmBtn.addTarget(self, action: #selector(clickConfirm), for: .touchUpInside)
        confirmBtn.setTitle("兑换".local, for: .normal)
        confirmBtn.titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 17)
        self.addSubview(confirmBtn)
        
        let recordBtn = UIButton(type: .custom)
        recordBtn.frame = CGRect(x: confirmBtn.right() + scale*28, y: confirmBtn.top(), width: scale*55, height: confirmBtn.height())
        recordBtn.addTarget(self, action: #selector(clickRecord), for: .touchUpInside)
        recordBtn.setTitle("兑换记录".local, for: .normal)
        recordBtn.backgroundColor = UIColor.clear
        recordBtn.titleLabel?.font = UIFont.init(name: "PingFangSC-Regular", size: 12)
        recordBtn.titleLabel?.numberOfLines = 0
        recordBtn.setTitleColor(UIColor.RGBHex(0x1f3564), for: .normal)
        self.addSubview(recordBtn)
    }
    
    
}
