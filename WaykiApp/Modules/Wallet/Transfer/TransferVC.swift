//
//  TransferVC.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/7.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

class TransferVC: BaseViewController,UITextFieldDelegate {
    let xSPace = scale*24
    
    var balance = AccountManager.getAccount().wiccSumAmount
    var fee:Double = 0.0001
    var gasMin:Double = 0.0001
    var gasMax:Double = 0.05
    var scanAddress:String = ""//从外界传入的地址
    
    var allAmountLabel:UILabel = UILabel()  //余额label
    var toAddressTF:UITextField = UITextField() //目标地址tf
    var tAmountTF:UITextField = UITextField()   //输入金额tf
    var remarkTF:UITextField = UITextField()    //备注tf
    
    var slider:UISlider = UISlider()
    var feeLabel:UILabel = UILabel()
    var tempMoney:Double = 0    //可用额度（减去预留手续费的余额）
    
    var confirmBtn = UIButton(type:.custom)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //布局
        layoutUI()
        getAllAmount()
        //设置显示余额
        setAmount()
        //接受转账成功的通知
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("Noti_transferSuccess"), object: nil, queue: OperationQueue.main) { (noti) in
            self.perform(#selector(self.back), with: nil, afterDelay: 2.0)
            UILabel.showSucceedHUD(text: "转账成功".local)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}



//MARK: - data
extension TransferVC{
    
    //设置显示余额
    private func setAmount(){
        self.tempMoney = AccountManager.getAccount().wiccSumAmount - 0.000016
        let firstStr = "可用额度： ".local
        let secondStr:String
        secondStr = "\(AccountManager.getAccount().wiccSumAmount)".removeEndZeros() + CoinType.wicc.rawValue
        balance = AccountManager.getAccount().wiccSumAmount

        let pStr = firstStr + secondStr

        let muAttStr = NSMutableAttributedString(string: pStr)
        muAttStr.addAttributes([NSAttributedStringKey.foregroundColor:UIColor.RGBHex(0x7690c3)], range:"".nsRange(from: pStr.range(of: firstStr)!))
        
        allAmountLabel.attributedText = muAttStr
        
  
    }
    
    private func getAllAmount(){
        TransferProvider.getWiccSum {
            self.tempMoney = AccountManager.getAccount().wiccSumAmount - 0.000016
            self.setAmount()
        }
    }
    
    //设置显示矿工费
    private func setGas(){
        
        let feeStr = "矿工费：".local + String(format: "%.8f", fee).removeEndZeros() + " " + CoinType.wicc.rawValue
        feeLabel.text = feeStr
        
    }
}

//MARK: - action
extension TransferVC{
    //前往扫一扫页面
    @objc func jumpToScan(){
        TransferProvider.isRightCamera {
            let scanner =  HMScannerController.scanner(withCardName: "", avatar: UIImage.init(named: "avatar"), completion: {
                [weak self] (stringValue:String?) in
                self?.toAddressTF.text = stringValue
            })
            scanner?.setTitleColor(UIColor.white, tintColor:UIColor.red)
            self.present(scanner!, animated: true, completion: nil)
        }
    }
    
    //点击确定转账
    @objc func clickConfirm(){
//        TransferProvider.sureTransfer(tAddress: "aassssssfffffss", amount: "0.03", remark: "", fee: 0.01, coinType: CoinType.wicc)
        let toAddress = toAddressTF.text
        let amount = tAmountTF.text
        let remark = remarkTF.text
        view.endEditing(true)
        TransferProvider.sureTransfer(tAddress: toAddress, amount: amount, remark: remark, fee: fee, coinType: CoinType.wicc,vc: self)
    }
    
    ///slider滑块相应事件
    @objc private func silderEvent(obj:UISlider){
        
        let spaceGas = gasMax - gasMin
        fee = Double(obj.value) * spaceGas + gasMin
        tempMoney = balance - fee

        // 小费更新
        setGas()
    }
    

    
}

//MARK: - delegate
extension TransferVC{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tAmountTF {
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
                textField.text = showStr
                
                if let a = Double(showStr){
                    if a > self.tempMoney{
                        if self.tempMoney<0 {self.tempMoney = 0}
                        let str = String.init(format: "%.8f",self.tempMoney).removeEndZeros()
                        self.tAmountTF.text = str
                        UILabel.showFalureHUD(text: "您只能转出" + str)
                    }
                }
                
            }
            
            
            return false
        }else if textField == remarkTF{
            if ((textField.text?.count)! + string.count) > 20{
                return false
            }
        }
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

//MARK: - UI
extension TransferVC{
    private func layoutUI(){
        titleLabel?.text = CoinType.wicc.rawValue + "转账".local
        view.backgroundColor = UIColor.bgColor()
        addInputTF()
        addGasSelected()
        addConfirmBtn()
    }
    
    //可用余额、地址、金额、备注
    private func addInputTF(){
        //可用余额
        let allAmountBackV = UIView(frame: CGRect(x: xSPace, y: (header?.bottom())! + scale*8, width: view.width() - 2*xSPace, height: scale*36))
        allAmountBackV.backgroundColor = UIColor.RGBHex(0x25345c)
        view.addSubview(allAmountBackV)
        
        allAmountLabel.frame = CGRect(x: scale*12, y: 0, width: allAmountBackV.width()-2*scale*12, height: allAmountBackV.height())
        allAmountLabel.font = UIFont.init(name: "Helvetica", size: 12)
        allAmountLabel.textColor = UIColor.amountColor()
        allAmountBackV.addSubview(allAmountLabel)
        
        
        let tfHeight = scale*56
        let tfSpace = scale*12
        
        //地址
        toAddressTF.frame = CGRect(x: allAmountBackV.left(), y: allAmountBackV.bottom()+tfSpace, width: allAmountBackV.width()-scale*24, height: tfHeight)
        toAddressTF.font = UIFont.init(name: "PingFang SC", size: 12)
        toAddressTF.textColor = UIColor.white
        toAddressTF.delegate = self
        toAddressTF.text = scanAddress
        toAddressTF.attributedPlaceholder = NSAttributedString(string: "收款人钱包地址".local,attributes: [NSAttributedStringKey.foregroundColor : UIColor.RGBHex(0x4f6592, alpha: 1),NSAttributedStringKey.font:UIFont.init(name: "PingFang SC", size: 16)!])
        view.addSubview(toAddressTF)
        
        let scanBtn = UIButton(type: .custom)
        scanBtn.frame = CGRect(x: toAddressTF.right(), y: toAddressTF.top()+scale*16, width: scale*24, height: scale*24)
        scanBtn.setImage(UIImage(named: "scan_icon"), for: .normal)
        scanBtn.addTarget(self, action: #selector(jumpToScan), for: .touchUpInside)
        view.addSubview(scanBtn)
        
        let line1 = UIView(frame: CGRect(x: xSPace, y: toAddressTF.bottom(), width: allAmountBackV.width(), height: 1))
        line1.backgroundColor = UIColor.RGBHex(0x323f64)
        view.addSubview(line1)
        
        //转账金额
        tAmountTF.frame = CGRect(x: allAmountBackV.left(), y: toAddressTF.bottom()+tfSpace, width: allAmountBackV.width(), height: tfHeight)
        tAmountTF.font = UIFont.init(name: "PingFang SC", size: 16)
        tAmountTF.textColor = UIColor.white
        tAmountTF.delegate = self
        tAmountTF.keyboardType = .decimalPad
        tAmountTF.attributedPlaceholder = NSAttributedString(string: "转账金额".local,attributes: [NSAttributedStringKey.foregroundColor : UIColor.RGBHex(0x4f6592, alpha: 1),NSAttributedStringKey.font:UIFont.init(name: "PingFang SC", size: 16)!])
        view.addSubview(tAmountTF)
        
        let line2 = UIView(frame: CGRect(x: xSPace, y: tAmountTF.bottom(), width: allAmountBackV.width(), height: 1))
        line2.backgroundColor = UIColor.RGBHex(0x323f64)
        view.addSubview(line2)
        
        
        //备注
        remarkTF.frame = CGRect(x: allAmountBackV.left(), y: tAmountTF.bottom()+tfSpace, width: allAmountBackV.width(), height: tfHeight)
        remarkTF.font = UIFont.init(name: "PingFang SC", size: 16)
        remarkTF.textColor = UIColor.white
        remarkTF.textColor = UIColor.white
        remarkTF.attributedPlaceholder = NSAttributedString(string: "备注（选填）".local,attributes: [NSAttributedStringKey.foregroundColor : UIColor.RGBHex(0x4f6592, alpha: 1),NSAttributedStringKey.font:UIFont.init(name: "PingFang SC", size: 16)!])
        view.addSubview(remarkTF)
        
        let line3 = UIView(frame: CGRect(x: xSPace, y: remarkTF.bottom(), width: allAmountBackV.width(), height: 1))
        line3.backgroundColor = UIColor.RGBHex(0x323f64)
        view.addSubview(line3)
    }
    
    //手续费
    private func addGasSelected(){
        let gXSpace = scale*40
        
        feeLabel = UILabel.init(frame: CGRect(x: gXSpace, y: remarkTF.bottom()+scale*30 , width: view.width() - 2*gXSpace, height:  16*scale))
        feeLabel.textColor = UIColor.RGBHex(0x727c8a)
        setGas()
        feeLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 11)
        view.addSubview(feeLabel)
        
        slider = UISlider()
        slider.frame = CGRect(x: feeLabel.left(), y: feeLabel.bottom()+10*scale, width: feeLabel.width(), height: 20*scale)
        slider.value = 0
        slider.maximumTrackTintColor = UIColor.init(white: 0.5, alpha: 0.5)
        slider.minimumTrackTintColor = UIColor.RGBHex(0x2e86ff)
        slider.setThumbImage(UIImage(named: "silderThumb"), for: .normal)
        slider.addTarget(self, action: #selector(silderEvent(obj: )), for: .valueChanged)
        view.addSubview(slider)
        
        let slow = UILabel.init(frame: CGRect(x: slider.left(), y: slider.bottom()+scale*2 , width:40, height: 18*scale))
        slow.textColor = UIColor.RGBHex(0x7690c3)
        slow.text = "慢".local
        slow.font = UIFont.init(name: "PingFangSC-Regular", size: 13)
        view.addSubview(slow)
        
        let fast = UILabel.init(frame: CGRect(x: feeLabel.right() - 40, y: slider.bottom()+scale*2, width:40, height: 18*scale))
        fast.textColor = UIColor.RGBHex(0x7690c3)
        fast.text = "快".local
        fast.textAlignment = .right
        fast.font = UIFont.init(name: "PingFangSC-Regular", size: 13)
        view.addSubview(fast)
    }
    
    //添加确定转账按钮
    private func addConfirmBtn(){
        confirmBtn.frame = CGRect(x: xSPace, y: slider.bottom()+scale*50, width: view.width()-2*xSPace, height: scale*44)
        confirmBtn.setTitle("确定转账".local, for: .normal)
        confirmBtn.setTitleColor(UIColor.white, for: .normal)
        confirmBtn.addTarget(self, action: #selector(clickConfirm), for: .touchUpInside)
        confirmBtn.layer.cornerRadius = 3
        confirmBtn.titleLabel?.font = UIFont.init(name: "PingFang SC", size: 17)
        confirmBtn.backgroundColor = UIColor.RGBHex(0x2e86ff)
        confirmBtn.isEnabled = true
        view.addSubview(confirmBtn)
    }
}
