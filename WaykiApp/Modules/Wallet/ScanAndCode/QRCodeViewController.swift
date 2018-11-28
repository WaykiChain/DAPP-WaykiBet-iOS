//
//  QRCodeViewController.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/8.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

class QRCodeViewController: BaseViewController {

    let address = AccountManager.getAccount().address
    
    let qrBackView:UIView = UIView()
    let qrCodeImageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
    }


}

//MARK: - action
extension QRCodeViewController{
    //跳转至收款记录
    @objc func jumpToReocrd(){
        let c = TransferReocrdVC()
        if navigationController?.viewControllers.first is WalletVC{
            let walletvc = navigationController?.viewControllers.first as! WalletVC
            c.balanceModel = walletvc.coinsInfoModel

        }
        c.coinSymbol = CoinType.wicc
        c.wordsArr = ["全部".local,"转账".local,"兑换".local,"激活".local]
        navigationController?.pushViewController(c, animated: true)
    }
    
    //点击设置金额
    @objc func clickSetAmount(){
        
    }
    
    //点击保存图片
    @objc func clickSavePictrue(){

        let screenRect = UIScreen.main.bounds
        UIGraphicsBeginImageContext(screenRect.size)
        let ctx:CGContext = UIGraphicsGetCurrentContext()!
        self.view.layer.render(in: ctx)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();

        UIImageWriteToSavedPhotosAlbum(image!,
                                       self,#selector(savedPhotosAlbum(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc func savedPhotosAlbum(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        
        if error != nil {
            UILabel.showFalureHUD(text: "二维码保存失败！".local)
        } else {
            UILabel.showSucceedHUD(text:  "二维码已经保存！".local )
        }
    }
    
    //点击复制地址
    @objc func clickCopy(){
        UIPasteboard.general.string = address
        UILabel.showSucceedHUD(text:  "地址已复制！".local )

    }
    
    //点击获取wicc
    @objc func clickGetWicc(){
        WalletProvider.getWiccLink { (linkStr) in
            if URL(string: linkStr) != nil{
                let c = ItemsWebController()
                c.url = linkStr
                self.navigationController?.pushViewController(c, animated: true)
            }else{
                
            }
        }
    }
}

//MARK: - UI
extension QRCodeViewController{
    private func layoutUI(){
        titleLabel?.text = "收款码".local
        
        addRightBtn()
        addAddressInfo()
//        addMiddleBtn()
        addBottomBtn()
    }
    
    private func addRightBtn(){
        let rightToSpace:CGFloat = 8
        let btnWidth:CGFloat = 36
        rightBtn = UIButton(type: .custom)
        rightBtn?.frame = CGRect(x: (header?.width())! - rightToSpace - btnWidth , y: (leftItem?.top())!, width: btnWidth, height: btnWidth)
        rightBtn?.addTarget(self, action: #selector(jumpToReocrd), for: .touchUpInside)
        rightBtn?.setImage(UIImage(named: "icon_record"), for: .normal)
        header?.addSubview(rightBtn!)
        
    }
    
    //地址和二维码
    private func addAddressInfo(){
        let addressLabel = UILabel(frame: CGRect(x: 0, y: (header?.bottom())! + scale*40, width: view.frame.width, height: 15))
        addressLabel.text = address
        addressLabel.textAlignment = .center
        addressLabel.font = UIFont.init(name: "Helvetica", size: 13)
        addressLabel.textColor = UIColor.amountColor()
        view.addSubview(addressLabel)
        
        
        let backWidth = scale*160
        qrBackView.frame = CGRect(x: (view.width() - backWidth)/2.0, y: addressLabel.bottom()+scale*40, width: backWidth, height: backWidth)
        qrBackView.backgroundColor = UIColor.white
        qrBackView.layer.cornerRadius = 5
        view.addSubview(qrBackView)
        
        qrCodeImageView.frame = CGRect(x: scale*4, y: scale*4, width: backWidth - 2*scale*4, height: backWidth - 2*scale*4)
        let qrImage = UIImage.QRwithString(string: address, imageName: "qrcode")
        qrCodeImageView.image = qrImage
        qrBackView.addSubview(qrCodeImageView)
    }
    
    //设置金额 保存图片
    private func addMiddleBtn(){
        let middleBackView = UIView(frame: CGRect(x: 0, y: qrBackView.bottom()+scale*60, width: view.width(), height: 20))
        view.addSubview(middleBackView)
        
        let line = UIView(frame: CGRect(x: middleBackView.width()/2, y: 0, width: 0.5, height: middleBackView.height()))
        line.backgroundColor = UIColor.RGBHex(0x6c7dab)
        middleBackView.addSubview(line)
        
        let btnWidth =  scale*156
        let btnX = (middleBackView.width() - 2*btnWidth)/2.0
        let setAmountBtn = UIButton(type: .custom)
        setAmountBtn.frame = CGRect(x: btnX, y: 0, width: btnWidth, height: middleBackView.height())
        setAmountBtn.setTitle("设置金额".local, for: .normal)
        setAmountBtn.titleLabel?.font = UIFont.init(name: "PingFang SC", size: 14)
        setAmountBtn.setTitleColor(UIColor.RGBHex(0xd0ddff), for: .normal)
        setAmountBtn.addTarget(setAmountBtn, action: #selector(clickSetAmount), for: .touchUpInside)
        middleBackView.addSubview(setAmountBtn)
        
        
        let savePicBtn = UIButton(type: .custom)
        savePicBtn.frame = CGRect(x: line.right(), y: 0, width: btnWidth, height: middleBackView.height())
        savePicBtn.setTitle("保存图片".local, for: .normal)
        savePicBtn.titleLabel?.font = UIFont.init(name: "PingFang SC", size: 14)
        savePicBtn.setTitleColor(UIColor.RGBHex(0xd0ddff), for: .normal)
        savePicBtn.addTarget(self, action: #selector(clickSavePictrue), for: .touchUpInside)
        middleBackView.addSubview(savePicBtn)
    }
    
    //复制地址、获取wicc
    private func addBottomBtn(){
        let copyBtn = UIButton(type: .custom)
        copyBtn.frame = CGRect(x: scale*24, y: qrBackView.bottom()+scale*60+20+scale*60, width: view.width() - 2*scale*24, height: scale*44)
        copyBtn.setTitle("复制地址".local, for: .normal)
        copyBtn.setTitleColor(UIColor.white, for: .normal)
        copyBtn.titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 17)
        copyBtn.backgroundColor = UIColor.RGBHex(0x2e85fe)
        copyBtn.layer.cornerRadius = 3
        copyBtn.addTarget(self, action: #selector(clickCopy), for: .touchUpInside)
        view.addSubview(copyBtn)
        
        let getWiccBtn = UIButton(type: .custom)
        getWiccBtn.frame = CGRect(x: scale*24, y: copyBtn.bottom()+scale*16, width: view.width() - 2*scale*24, height: scale*44)
        getWiccBtn.setTitle("获取WICC".local, for: .normal)
        getWiccBtn.setTitleColor(UIColor.RGBHex(0x2e85fe), for: .normal)
        getWiccBtn.titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 17)
        getWiccBtn.backgroundColor = UIColor.white
        getWiccBtn.layer.cornerRadius = 3
        getWiccBtn.addTarget(self, action: #selector(clickGetWicc), for: .touchUpInside)
        view.addSubview(getWiccBtn)
        
    }
}
