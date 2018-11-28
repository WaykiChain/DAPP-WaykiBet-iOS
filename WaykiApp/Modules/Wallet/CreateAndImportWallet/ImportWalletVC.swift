//
//  ImportWalletVC.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/11.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

class ImportWalletVC: BaseViewController,UITextFieldDelegate {
    lazy var passwordTF:InputPasswordTextFiled = InputPasswordTextFiled()
    lazy var makesureTF:InputPasswordTextFiled = InputPasswordTextFiled()
    
    var textBackView:UIView?
    var textView:UITextView?
    var placeholderLabel:UILabel?
    
    var agreenBtn:UIButton?
    var protocolLabel:CJLabel?
    var startImportBtn:UIButton?
    var createButton:UIButton?
    
    var isFromRegister:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        NotificationCenter.default.addObserver(self, selector: #selector(listenInBtnStatus), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - event

extension ImportWalletVC{
    @objc func agreedProtocol(_ btn:UIButton){
        btn.isSelected = !btn.isSelected
        listenInBtnStatus()
    }
    
    @objc func onLookUserProtol(){
        //        let c = ShowProtocolVC()
        //        self.navigationController?.pushViewController(c, animated: true)
    }
    
    //判断按钮是否可点击
    @objc func listenInBtnStatus(){
        let isAgreen = agreenBtn?.isSelected
        var isEnable = false
        if isAgreen==true {
            if ((passwordTF.text?.count)!>0) && ((makesureTF.text?.count)!>0){
                isEnable = true
                
            }else{
                isEnable = false
            }
        }else{
            isEnable = false
        }
        if isEnable == false{
            startImportBtn?.setTitleColor(UIColor.init(white: 1, alpha: 0.5), for: .normal)
        }else{
            startImportBtn?.setTitleColor(UIColor.init(white: 1, alpha: 1), for: .normal)
        }
        startImportBtn?.isEnabled = isEnable
    }

    //开始点击导入钱包
    @objc func startImport(){
        view.endEditing(true)
        if agreenBtn?.isSelected == false {
            return
        }
        let helpstr = textView?.text
        let password = passwordTF.text
        let makesurePWD = makesureTF.text
        CreateOrImportProvider.startImportCheck((agreenBtn?.isSelected)!, helpStr: helpstr!, password: password!, makesurePWD: makesurePWD!) { (isSuccess, alertStr, address, helpStr,password) in
            if isSuccess==true{
                self.importWallet(helpStr: helpStr, address: address, password: password)
            }else{
                UILabel.showFalureHUD(text: alertStr)
            }
        }
        
    }
    //点击跳转创建钱包
    @objc func jumpToCreateWallet(){
        let c = CreateWalletVC()
        c.isFromRegister = isFromRegister
        if navigationController != nil{
            navigationController?.pushViewController(c, animated: true)
        }else{
            self.present(c, animated: true, completion: nil)
        }
    }
    

    @objc func popView() {
        
        if navigationController != nil && (navigationController?.viewControllers.count)!>1{
            navigationController?.popToRootViewController(animated: true)
        }else{
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    //导入钱包，助记词存储加密,密码生成加密key,并且绑定钱包
    func importWallet(helpStr:String,address:String,password:String){
        
        
//        UmengEvent.eventWithDic(name: "import_success")
        let mHash =  Bridge.getWalletHash(from: helpStr)

        //绑定本地钱包到帐号上
        //绑定成功后再存储在本地
        BindWalletManager.bindWallet(address: address, mHash: mHash!) {
            let account = NewAccount()
            account.address = address
            account.mHash = Bridge.getWalletHash(from: helpStr)
            account.token = AccountManager.getAccount().token
            account.phoneNum = AccountManager.getAccount().phoneNum
            account.setEncyptHelpStringAndPassword(helpStr: helpStr, password: password)
            AccountManager.saveAccount(account: account)
            UILabel.showSucceedHUD(text: "钱包导入成功".local)
            NotificationCenter.default.post(name: NSNotification.Name.init("Noti_refreshBindInfo"), object: nil)
            self.perform(#selector(self.popView), with: nil, afterDelay: 2)
        }
        
        return
    }
    
}

//MARK: - UITextViewDelegate
extension ImportWalletVC:UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {

        listenInBtnStatus()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
        if textView.text.count>0 {
            
        }else{
            placeholderLabel?.isHidden = false
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let toBeString = textView.text
        if (toBeString?.count)!>200 {
            textView.text = toBeString?.subString(to: 200)
            return false
        }else{
            return true
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel?.isHidden = true
    }
    
}


//MARK: - UITextFieldDelegate
extension ImportWalletVC{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }else if (textField.text?.count)!>=16{
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - UI
extension ImportWalletVC{
    private func layoutUI(){
        titleLabel?.text = "导入钱包".local
        createTextView()
        addPasswordView()
        addAgreenBtnAndProtocol()
        addStartBtn()
    }
    

    private func createTextView(){
        
        let textWidth = scale*327
        let tfSpace = scale*20.0
        let bView = UIView(frame: CGRect(x: (view.width() - textWidth)/2.0, y: (header?.bottom())! + scale*21.0, width: textWidth, height: scale*86))
        bView.layer.cornerRadius = 3
        bView.backgroundColor = UIColor.RGBHex(0x101b36)

        textBackView = bView
        self.view.addSubview(bView)
        
        let tWidth = textWidth - 2*tfSpace
        let tHeight = scale*86 - scale*28.0
        textView = UITextView(frame: CGRect(x: (view.width() - tWidth)/2.0, y: (header?.bottom())! + scale*14.0 + tfSpace, width: tWidth, height: tHeight))
        textView?.layer.cornerRadius = 6
        textView?.layer.masksToBounds = true
        textView?.backgroundColor = UIColor.clear
        textView?.font = UIFont(name: "PingFangSC-Regular", size: 13)
        textView?.textColor = UIColor.white
        textView?.delegate = self
        self.view.addSubview(textView!)
        
        placeholderLabel = UILabel(frame: CGRect(x: 0, y:0, width: tWidth, height:20))
        placeholderLabel?.textColor = UIColor.RGBHex(0x4f6592)
        placeholderLabel?.font = UIFont(name: "PingFangSC-Regular", size: 13)
        placeholderLabel?.text = "助记词 按空格分隔".local
        textView?.addSubview(placeholderLabel!)
    }
    
    
    private func addPasswordView(){
        let xSpace = scale*24
        let tfWidth = view.width() - 2*xSpace
        let tfHeight = scale*55
        let tfVSpace = scale*12
        
        passwordTF.frame = CGRect(x: xSpace, y: (header?.bottom())! + 102*scale + scale*20 , width: tfWidth, height: tfHeight)
        passwordTF.font = UIFont(name: "PingFangSC-Regular", size: 16)
        passwordTF.isSecureTextEntry = true
        passwordTF.textColor = UIColor.white
        passwordTF.delegate = self
        passwordTF.attributedPlaceholder = NSAttributedString(string: "请设置钱包密码（8～16位）".local,attributes: [NSAttributedStringKey.foregroundColor : UIColor.RGBHex(0x4f6592, alpha: 1),NSAttributedStringKey.font:UIFont.init(name: "PingFangSC-Regular", size: 16)!])
        view.addSubview(passwordTF)
        
        let line1 = UIView(frame: CGRect(x: passwordTF.left(), y: passwordTF.bottom(), width: passwordTF.width(), height: 1))
        line1.backgroundColor = UIColor.RGBHex(0x6c7dab, alpha: 0.5)
        view.addSubview(line1)
        
        
        makesureTF.frame = CGRect(x: xSpace, y: passwordTF.bottom() + tfVSpace , width: tfWidth, height: tfHeight)
        makesureTF.font = UIFont(name: "PingFangSC-Regular", size: 16)
        makesureTF.isSecureTextEntry = true
        makesureTF.textColor = UIColor.white
        makesureTF.delegate = self
        makesureTF.attributedPlaceholder = NSAttributedString(string: "再次输入您的钱包密码".local,attributes: [NSAttributedStringKey.foregroundColor : UIColor.RGBHex(0x4f6592, alpha: 1),NSAttributedStringKey.font:UIFont.init(name: "PingFangSC-Regular", size: 16)!])
        view.addSubview(makesureTF)
        
        let line2 = UIView(frame: CGRect(x: makesureTF.left(), y: makesureTF.bottom(), width: makesureTF.width(), height: 1))
        line2.backgroundColor = UIColor.RGBHex(0x6c7dab, alpha: 0.5)
        view.addSubview(line2)
    }
    
    func addAgreenBtnAndProtocol(){
        let space = scale*24.0
        let topSpace = makesureTF.bottom() + scale*30
        agreenBtn = UIButton(type: .custom)
        agreenBtn?.frame = CGRect(x: space, y: topSpace, width: scale*17, height: scale*17)
        agreenBtn?.setImage(UIImage(named: "agreen_dis"), for: .normal)
        agreenBtn?.setImage(UIImage(named: "agreen_selected"), for: .selected)
        agreenBtn?.isSelected = true
        agreenBtn?.addTarget(self, action: #selector(agreedProtocol(_:)), for: .touchUpInside)
        //self.view.addSubview(agreenBtn!)
        
        let protocolWidth = view.width() - (agreenBtn?.right())! - scale*8
        protocolLabel = CJLabel(frame: CGRect(x: (agreenBtn?.right())! + scale*8.0 ,y: topSpace, width: protocolWidth, height: 20))
        let truple = CreateOrImportProvider.addAttStylesWithLabel(label: protocolLabel!)
        protocolLabel?.addLinkString(truple.secondStr, linkAddAttribute: truple.attStyles, block: { [weak self](linkModel) in
            self?.onLookUserProtol()
        })
        //self.view.addSubview(protocolLabel!)
    }
    
    func addStartBtn(){
        let btnWidth = scale*327
        let btnHeight = scale*44
        startImportBtn = UIButton(type: .custom)
        startImportBtn?.frame = CGRect(x: (view.width() - btnWidth)/2.0, y: (protocolLabel?.bottom())! + scale*15, width: btnWidth, height: btnHeight)
        startImportBtn?.setTitle("导入钱包".local, for: .normal)
        startImportBtn?.setTitleColor(UIColor.init(white: 1, alpha: 0.5), for: .normal)
        startImportBtn?.setBackgroundImage(UIImage(named: "btn_normal"), for: .normal)
        startImportBtn?.isEnabled = false
        startImportBtn?.layer.cornerRadius = 3
        
        startImportBtn?.addTarget(self, action: #selector(startImport), for: .touchUpInside)
        self.view.addSubview(startImportBtn! )
        
        createButton = UIButton(type: .custom)
        createButton?.frame = CGRect(x: (view.width() - btnWidth)/2.0, y: (startImportBtn?.bottom())! + scale*15, width: btnWidth, height: btnHeight)
        createButton?.setTitle("创建钱包".local, for: .normal)
        createButton?.setTitleColor(UIColor.white, for: .normal)
        createButton?.backgroundColor = UIColor.clear
        createButton?.layer.cornerRadius = 3
        createButton?.addTarget(self, action: #selector(jumpToCreateWallet), for: .touchUpInside)
        self.view.addSubview(createButton! )
        
    }
}
