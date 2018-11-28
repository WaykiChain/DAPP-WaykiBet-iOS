//
//  ManageWalletVC.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/3.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

class ManageWalletVC: BaseViewController {
    var tableView:UITableView?
    var titleArray:[String] = []
    var imageArray:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()

        layoutUI()
    }
}

//MARK: - Data
extension ManageWalletVC{
    func setData(){
        titleArray = ["导出助记词".local,"导出私钥".local,"导入钱包".local,"创建钱包".local,"修改钱包密码".local]
        imageArray = ["backupWallet","exportPK","importWallet","createWallet","revisePWD"]
    }
}


//MARK: - action
extension ManageWalletVC{
    @objc func clickItem(tap:UIGestureRecognizer){
        let supView = tap.view
        let tag = supView?.tag
        switch tag {
        case 1:
            backupWallet()
        case 2:
            exportPrivateKey()
        case 3:
            importWallet()
        case 4:
            createWallet()
        case 5:
            revisePWD()
        default:
            break
        }
    }
    
    
    //备份钱包
    @objc func backupWallet(){

        let inputAlert = InputPWDAlertView(checkPWDType:.backup, frame: self.view.bounds)
        inputAlert.confirmBlock = {(pwd) in
            let v = ShowMnemonicAlertView(checkPWDType: .backup, pwd: pwd, frame: CGRect(x: 0, y: 0, width: UIScreen.width(), height: UIScreen.height()))
            v.confirmBlock = {(tag,alert) in
                if tag == 1{
                    UIPasteboard.general.string = alert.mnemonicLabel?.text
                    UILabel.showSucceedHUD(text:  "已成功复制到剪贴板".local )
                }
            }
            v.showAlert()
            
        }
        inputAlert.showAlert()
    }
    
    //导出私钥
    @objc func exportPrivateKey(){
        let inputAlert = InputPWDAlertView(checkPWDType:.exportPK, frame: self.view.bounds)
        inputAlert.confirmBlock = {(pwd) in
            let v = ShowMnemonicAlertView(checkPWDType: .exportPK, pwd: pwd, frame: CGRect(x: 0, y: 0, width: UIScreen.width(), height: UIScreen.height()))
            v.confirmBlock = {(tag,alert) in
                if tag == 1{
                    UIPasteboard.general.string = alert.mnemonicLabel?.text
                    UILabel.showSucceedHUD(text:  "已成功复制到剪贴板".local )
                }
            }
            v.showAlert()
            
        }
        inputAlert.showAlert()    }
    
    //导入钱包
    @objc func importWallet(){
        let v = WalletPromptAlertView(title: "导入新钱包后将替换您现有的钱包，请确认您的钱包已做好助记词备份".local, btnTitle: "导入钱包".local, isHavedCancel: true, frame: self.view.bounds)
        v.clickBlock = {[weak self]() in
            let c = ImportWalletVC()
            self?.navigationController?.pushViewController(c, animated: true)
        }
        v.showAlert()
    }
    
    //创建钱包
    @objc func createWallet(){
        let v = WalletPromptAlertView(title: "创建钱包后将替换您现有的钱包，请确认您的钱包已做好助记词备份".local, btnTitle: "创建钱包".local, isHavedCancel: true, frame: self.view.bounds)
        v.clickBlock = {[weak self]() in
            let c = CreateWalletVC()
            self?.navigationController?.pushViewController(c, animated: true)
        }
        v.showAlert()

    }
    
    //修改钱包密码
    @objc func revisePWD(){
        let c = ReviseWalletPasswordVC()
        navigationController?.pushViewController(c, animated: true)
    }
    
}

//MARK: - UI
extension ManageWalletVC{
    private func layoutUI(){
        titleLabel?.text = "管理钱包".local
        let xSpace = scale*20
        let itemWidth = scale*167
        let itemHeight = scale*142
        
        for i in 0..<titleArray.count {
            let title = titleArray[i]
            let imageStr = imageArray[i]

            let v = createBaseItem(frame: CGRect(x:xSpace +  itemWidth*CGFloat(i%2), y: (header?.bottom())! +  CGFloat(i/2)*(itemHeight+1), width: itemWidth, height: itemHeight), image: UIImage(named: imageStr), title: title)
            v.tag = i+1
            let tap = UITapGestureRecognizer(target: self, action: #selector(clickItem(tap:)))
            v.addGestureRecognizer(tap)
            view.addSubview(v)
            
        }
        
        let line1 = UIView(frame: CGRect(x: xSpace+itemWidth, y: (header?.bottom())! + 20*scale, width: 1, height: itemHeight*3))
        line1.backgroundColor = UIColor.RGBHex(0x6c7dab, alpha: 0.3)
        view.addSubview(line1)
        
        for i in 0..<2 {
            let hLine = UIView(frame: CGRect(x: xSpace, y: (header?.bottom())! +  CGFloat(i+1)*itemHeight, width: itemWidth*2+1, height: 1))
            hLine.backgroundColor = UIColor.RGBHex(0x6c7dab, alpha: 0.3)
            view.addSubview(hLine)
        }
        
        createVersionInfo()
        
    }
    
    
    //创建
    //142*166
    private func createBaseItem(frame:CGRect, image:UIImage?,title:String) ->UIView{
        let v = UIView()
        v.frame = frame
        v.clipsToBounds = true
        v.isUserInteractionEnabled = true

        
        let imageWidth = scale*54
        let iconImageView = UIImageView(image: image)
        iconImageView.frame = CGRect(x: (v.width() - imageWidth)/2, y: scale*38, width: imageWidth, height: imageWidth)
        v.addSubview(iconImageView)
        
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: iconImageView.bottom(), width: v.width(), height: 21))
        titleLabel.font = UIFont(name: "PingFangSC-Regular", size: 15)
        titleLabel.textColor = UIColor.RGBHex(0xd0ddff)
        titleLabel.textAlignment = .center
        titleLabel.text = title
        v.addSubview(titleLabel)

        
        return v
    }
    
    //版本信息
    private func createVersionInfo(){
        if walletNetConfirure == 1 {
            let label = UILabel(frame: CGRect(x: 0, y: view.height()-100, width: view.width(), height: 100))
            label.numberOfLines  =  0
            label.textAlignment = .center
            label.textColor = UIColor.white
            label.font = UIFont.systemFont(ofSize: 16)
            let walletNtt:String = (walletNetConfirure == 1) ? "test" : "main"
            label.text = "version: " + appVersion + "\n" + "channelCode: " + channelCode + "\n" + "walletNet: " + walletNtt
            view.addSubview(label)
        }

    }
}


extension ManageWalletVC{

}


