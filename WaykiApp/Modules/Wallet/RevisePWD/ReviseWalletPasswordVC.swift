//
//  ReviseWalletPasswordVC.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/12.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

class ReviseWalletPasswordVC: BaseViewController {
    
    var inputBackView:UIView?
    
    lazy var oldPwdTF:InputPasswordTextFiled = InputPasswordTextFiled()
    lazy var nPwdTF:InputPasswordTextFiled = InputPasswordTextFiled()
    lazy var makeSurePWDTF:InputPasswordTextFiled = InputPasswordTextFiled()
    var placeHolderColor = UIColor.placeHolderColor
    
    var confirmBtn:UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        NotificationCenter.default.addObserver(self, selector: #selector(listenInBtnStatus), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

//MARK: - UI
extension ReviseWalletPasswordVC{
    func layoutUI(){
        titleLabel?.text = "修改钱包密码".local
        addInputBV()
        addConfirmBtn()
    }
    
    func addInputBV(){

        
        let tfHeight = scale*56
        let tfSpace = scale*12
        let xSpace = scale*20
        let tfWidth = view.width() - 2*xSpace
        let vTop = (header?.bottom())! + scale*40
        
        
        oldPwdTF.frame = CGRect(x:xSpace, y: vTop, width: view.width() - 2*xSpace, height: tfHeight)
        oldPwdTF.font = UIFont.init(name: "PingFangSC-Regular", size: 16)
        oldPwdTF.textColor = UIColor.white
        oldPwdTF.delegate = self
        oldPwdTF.isSecureTextEntry = true
        oldPwdTF.attributedPlaceholder = NSAttributedString(string: "请输入原密码".local, attributes: [NSAttributedStringKey.foregroundColor : UIColor.placeHolderColor()] as [NSAttributedStringKey:Any])
        view.addSubview(oldPwdTF)
        
        let line1 = UIView(frame: CGRect(x: 0, y: (oldPwdTF.height()) - 0.5, width: (oldPwdTF.width()), height: 0.5))
        line1.backgroundColor = UIColor.lineColor()
        oldPwdTF.addSubview(line1)

        nPwdTF.frame =  CGRect(x: (oldPwdTF.left()), y: (oldPwdTF.bottom())+tfSpace, width: tfWidth, height: tfHeight)
        nPwdTF.font = UIFont.init(name: "PingFangSC-Regular", size: 16)
        nPwdTF.textColor = UIColor.white
        nPwdTF.delegate = self
        nPwdTF.isSecureTextEntry = true
        nPwdTF.attributedPlaceholder = NSAttributedString(string: "请输入新密码（8～16位）".local, attributes: [NSAttributedStringKey.foregroundColor : UIColor.placeHolderColor()] as [NSAttributedStringKey:Any])
        view.addSubview(nPwdTF)

        let line2 = UIView(frame: CGRect(x: 0, y: (nPwdTF.height()) - 0.5, width: (nPwdTF.width()), height: 0.5))
        line2.backgroundColor = UIColor.lineColor()
        nPwdTF.addSubview(line2)

        makeSurePWDTF.frame =  CGRect(x: (oldPwdTF.left()), y: (nPwdTF.bottom())+tfSpace, width: tfWidth, height: tfHeight)
        makeSurePWDTF.font = UIFont.init(name: "PingFangSC-Regular", size: 16)
        makeSurePWDTF.textColor = UIColor.white
        makeSurePWDTF.delegate = self
        makeSurePWDTF.isSecureTextEntry = true
        makeSurePWDTF.attributedPlaceholder = NSAttributedString(string: "请重复输入新密码".local, attributes: [NSAttributedStringKey.foregroundColor : UIColor.placeHolderColor()] as [NSAttributedStringKey:Any])
        view.addSubview(makeSurePWDTF)
        
        let line3 = UIView(frame: CGRect(x: 0, y: (makeSurePWDTF.height()) - 0.5, width: (makeSurePWDTF.width()), height: 0.5))
        line3.backgroundColor = UIColor.lineColor()
        nPwdTF.addSubview(line3)
    }
    
    func addConfirmBtn(){
        
        let btnWidth = scale*327.0
        let btnHeight = scale*44.0
        confirmBtn = UIButton(type: .custom)
        confirmBtn?.frame = CGRect(x: (view.width() - btnWidth)/2.0, y: (makeSurePWDTF.bottom()) + scale*30.0, width: btnWidth, height: btnHeight)
        confirmBtn?.setTitle("确定".local, for: .normal)
        confirmBtn?.setTitleColor(UIColor.white, for: .normal)
        confirmBtn?.setBackgroundImage(UIImage(named: "btn_normal"), for: .normal)
        confirmBtn?.isEnabled = false
        confirmBtn?.layer.cornerRadius = 3
        confirmBtn?.addTarget(self, action: #selector(clickConfirm), for: .touchUpInside)
        self.view.addSubview(confirmBtn! )
    }
    
    
}

extension ReviseWalletPasswordVC:UITextFieldDelegate{
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

//MARK: - event
extension ReviseWalletPasswordVC{
    @objc func clickConfirm(){
        let oldPassword = oldPwdTF.text
        let surePassword = nPwdTF.text
        let makeSurePassword = makeSurePWDTF.text
        
        
        if ((oldPassword?.count)! < 1) {
            UILabel.showFalureHUD(text: "请输入原密码".local)
            return
        } else if (surePassword?.count)! < 1{
            UILabel.showFalureHUD(text: "请输入新密码".local)

            return
        } else if (makeSurePassword?.count)! < 1{
            UILabel.showFalureHUD(text: "请重复输入新密码".local)
            return
        }
        
        if checkPassword(oldPWD: oldPassword!) {
            //原密码相等于输入的原密码
            if surePassword == makeSurePassword {
                //新密码两次输入是否一致
                if ((surePassword?.count)! >= 8)&&((surePassword?.count)! <= 16){
                    //新密码长度是否符合要求
                    //更新新密码
                    updateNewPassword(oldPassword: oldPassword!, newPassword: surePassword!)
//                    UmengEvent.eventWithDic(name: "resetPwd_success")
                    UILabel.showSucceedHUD(text: "修改成功".local)
                    perform(#selector(popVC), with: nil, afterDelay: 1.2)
                }else{
                    UILabel.showFalureHUD(text: "请输入8~16位新密码".local)
                }
            }else{
                UILabel.showFalureHUD(text: "两次密码输入不一致".local)
            }
        }else{
            UILabel.showFalureHUD(text: "原密码输入错误".local)
        }
    }
    
    //判断按钮是否可点击
    @objc func listenInBtnStatus(){
        
        var isEnable = false
        if ((nPwdTF.text?.count)!>0) && ((oldPwdTF.text?.count)!>0) && ((makeSurePWDTF.text?.count)!>0){
            isEnable = true
        }else{
            isEnable = false
        }
        
        confirmBtn?.isEnabled = isEnable
        
    }
    
    @objc func popVC(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //判断和原密码是否相等
    private func checkPassword(oldPWD:String) ->Bool{
        var isEqual = false
        let account = AccountManager.getAccount()
        isEqual = account.checkPassword(inputPassword: oldPWD)
        
        return isEqual
    }
    //更新新密码
    private func updateNewPassword(oldPassword:String,newPassword:String){
        let account = AccountManager.getAccount()
        let isEqual = account.checkAndUpdatePassword(oldPassword: oldPassword, nPassword: newPassword)
        if isEqual  ==  false {
            UILabel.showFalureHUD(text: "原密码输入错误".local)
        }
    }
}
