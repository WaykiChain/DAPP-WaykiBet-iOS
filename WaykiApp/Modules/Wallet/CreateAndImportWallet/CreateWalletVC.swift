//
//  CreateWalletVC.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/10.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

class CreateWalletVC: BaseViewController,UITextFieldDelegate {
    lazy var passwordTF:InputPasswordTextFiled = InputPasswordTextFiled()
    lazy var makesureTF:InputPasswordTextFiled = InputPasswordTextFiled()
    var agreenBtn:UIButton?
    var protocolLabel:CJLabel?
    var startCreateButton:UIButton?
    var importBtn:UIButton?

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

extension CreateWalletVC{
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
            startCreateButton?.setTitleColor(UIColor.init(white: 1, alpha: 0.5), for: .normal)
        }else{
            startCreateButton?.setTitleColor(UIColor.init(white: 1, alpha: 1), for: .normal)
        }
 
        startCreateButton?.isEnabled = isEnable
    }

    
    //开始点击创建钱包
    @objc func startCreate(){
        view.endEditing(true)
        if agreenBtn?.isSelected == false {
            return
        }
        let password = passwordTF.text
        let makesurePWD = makesureTF.text
        CreateOrImportProvider.startCreateCheck((agreenBtn?.isSelected)!, password: password!, makesurePWD: makesurePWD!) { (isSuccess, alertStr, address, helpStr,password) in
            if isSuccess==true{
                RequestHandler.showHUD()
                let mhash = Bridge.getWalletHash(from: helpStr)
                //先去绑定钱包，再存储在本地
                BindWalletManager.bindWallet(address: address, mHash:mhash!, complete: {
                    self.saveWalletInfoAndAlert(address: address, mhash: mhash!, helpStr: helpStr, password: password, isFromRegister: self.isFromRegister)
                })


            }else{
                UILabel.showFalureHUD(text: alertStr)
            }
        }
        
    }
    
    //存放信息以及提示
    @objc func saveWalletInfoAndAlert(address:String,mhash:String,helpStr:String,password:String,isFromRegister:Bool){
        let account = NewAccount()
        account.address = address
        account.mHash = mhash
        account.token = AccountManager.getAccount().token
        account.phoneNum = AccountManager.getAccount().phoneNum
        account.setEncyptHelpStringAndPassword(helpStr: helpStr, password: password)
        AccountManager.saveAccount(account: account)
        NotificationCenter.default.post(name: NSNotification.Name.init("Noti_refreshBindInfo"), object: nil)
        OnceBackupManager.saveKeyInfo()

        if isFromRegister {
            RequestHandler.showHUD()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
                RequestHandler.dismissHUD()
                //alert
                CreateOrImportProvider.checkGivingRequest(address: address) { (isSuccess, num) in
                    if isSuccess{
                        //奖励提示
                        CommonAlertView.registerAlertGiving {
                            self.popToHome()
                        }
                    }else{
                        UILabel.showSucceedHUD(text: "恭喜您，新钱包创建成功".local)
                        self.perform(#selector(self.popToHome), with: nil, afterDelay: 2)
                    }
                    
                }
            }

 
        }else{
            UILabel.showSucceedHUD(text: "恭喜您，新钱包创建成功".local)
            self.perform(#selector(self.popView), with: nil, afterDelay: 2)
        }


    }
    
    //点击导入钱包
    @objc func importWallet(){
        let c = ImportWalletVC()
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
            let tabbar = Tools.getTabber()
            var i = 0

            for vc in (tabbar?.viewControllers)!{
                let nav = vc as! UINavigationController
                if nav.viewControllers.first is WalletVC{
                    tabbar?.selectedIndex = i
                    break
                }
                i = i+1
            }
        }
    }
    
    @objc func popToHome(){
        if navigationController != nil && (navigationController?.viewControllers.count)!>1{
            navigationController?.popToRootViewController(animated: true)
        }else{
            UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
            let tabbar = Tools.getTabber()
            tabbar?.selectedIndex = 0
        }
    }
    
}

//MARK: - UITextFieldDelegate
extension CreateWalletVC{
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
extension CreateWalletVC{
    private func layoutUI(){
        titleLabel?.text = "创建钱包".local
        addTopShowView()
        addPasswordView()
        addAgreenBtnAndProtocol()
        addStartBtn()
    }
    
    private func addTopShowView(){
        CreateOrImportProvider.addRemarkLabel(superview: self.view)
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
       // self.view.addSubview(agreenBtn!)
        
        let protocolWidth = view.width() - (agreenBtn?.right())! - scale*8
        protocolLabel = CJLabel(frame: CGRect(x: (agreenBtn?.right())! + scale*8.0 ,y: topSpace, width: protocolWidth, height: 20))
        let truple = CreateOrImportProvider.addAttStylesWithLabel(label: protocolLabel!)
        protocolLabel?.addLinkString(truple.secondStr, linkAddAttribute: truple.attStyles, block: { [weak self](linkModel) in
            self?.onLookUserProtol()
        })
       // self.view.addSubview(protocolLabel!)
    }
    
    func addStartBtn(){
        let btnWidth = scale*327
        let btnHeight = scale*44
        startCreateButton = UIButton(type: .custom)
        startCreateButton?.frame = CGRect(x: (view.width() - btnWidth)/2.0, y: (protocolLabel?.bottom())! + scale*15, width: btnWidth, height: btnHeight)
        startCreateButton?.setTitle("创建钱包".local, for: .normal)
        startCreateButton?.setTitleColor(UIColor.init(white: 1, alpha: 0.5), for: .normal)
        startCreateButton?.setBackgroundImage(UIImage(named: "btn_normal"), for: .normal)
        startCreateButton?.isEnabled = false
        startCreateButton?.layer.cornerRadius = 3
        
        startCreateButton?.addTarget(self, action: #selector(startCreate), for: .touchUpInside)
        self.view.addSubview(startCreateButton! )
        
        importBtn = UIButton(type: .custom)
        importBtn?.frame = CGRect(x: (view.width() - btnWidth)/2.0, y: (startCreateButton?.bottom())! + scale*15, width: btnWidth, height: btnHeight)
        importBtn?.setTitle("导入钱包".local, for: .normal)
        importBtn?.setTitleColor(UIColor.white, for: .normal)
        importBtn?.backgroundColor = UIColor.clear
        importBtn?.layer.cornerRadius = 3
        importBtn?.addTarget(self, action: #selector(importWallet), for: .touchUpInside)
        self.view.addSubview(importBtn! )
        
    }
}
