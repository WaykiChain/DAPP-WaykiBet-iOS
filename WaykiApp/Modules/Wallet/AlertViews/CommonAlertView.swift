//
//  CreateOrImportAlertView.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/18.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

//显示创建、导入的弹框
class CommonAlertView: UIView {
    let contentView:UIView = UIView()//content
    let contentSize:CGSize = CGSize(width: scale*327, height: scale*164)
    
    var titleFont = UIFont.init(name: "PingFangSC-Regular", size: 14)
    var titleColor = UIColor.RGBHex(0x475a82)
    var titleTextAl = NSTextAlignment.left
    
    var title:NSAttributedString = NSAttributedString(string: "")
    var btnTitles:[String] = []
    var clickBlock:((Int)->Void)?
    var dismissBlock:(()->Void)?
    init(title:NSAttributedString,btnTitles:[String],frame:CGRect){
        super.init(frame: frame)
        
        self.title = title
        self.btnTitles = btnTitles
        buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//MARK: - public action
extension CommonAlertView{
    //弹出创建、导入的Alert
    class func alertCreateOrImport() ->CommonAlertView{
        let title1 = "您还未创建或导入钱包，无法进行投注开庄等操作，".local
        let title2 = "首次创建或者导入成功即送\(givingWusd)\(CoinType.token.rawValue)".local
        let buleColor = UIColor.RGBHex(0x2c84ff)

        let title = title1 + title2
        let att = NSMutableAttributedString(string: title)
        att.addAttributes([NSAttributedStringKey.foregroundColor : buleColor], range: NSMakeRange(title1.count, title2.count))
        
        let v = CommonAlertView(title: att, btnTitles: ["导入钱包".local,"创建钱包".local], frame: CGRect(x: 0, y: 0, width: UIScreen.width(), height: UIScreen.height()))
        v.clickBlock = {(tag) in
            if tag == 0{
                let c = ImportWalletVC()
                UIApplication.shared.keyWindow?.rootViewController?.present(c, animated: true, completion: nil)
            }else if tag == 1{
                let c = CreateWalletVC()
                UIApplication.shared.keyWindow?.rootViewController?.present(c, animated: true, completion: nil)
            }
        }
        v.showAlert()
        return v
    }
    
    class func alertAgainCreateOrImport(){
        let title1 = "当前设备未导入钱包助记词，".local
        let title2 = "钱包内WICC需要导入钱包后方可使用".local
        let buleColor = UIColor.RGBHex(0x2c84ff)
        
        let title = title1 + title2
        let att = NSMutableAttributedString(string: title)
        att.addAttributes([NSAttributedStringKey.foregroundColor : buleColor], range: NSMakeRange(title1.count, title2.count))
        
        let v = CommonAlertView(title: att, btnTitles: ["创建新钱包".local,"导入原有钱包".local], frame: CGRect(x: 0, y: 0, width: UIScreen.width(), height: UIScreen.height()))
        v.clickBlock = {(tag) in
            if tag == 0{
                let c = CreateWalletVC()
                UIApplication.shared.keyWindow?.rootViewController?.present(c, animated: true, completion: nil)
            }else if tag == 1{
                let c = ImportWalletVC()
                UIApplication.shared.keyWindow?.rootViewController?.present(c, animated: true, completion: nil)
            }
        }
        v.showAlert()
    }
    
    class func registerAlertGiving(click:@escaping(()->Void)){
        let title1 = "创建钱包成功！系统将赠送 \(givingWusd) \(CoinType.token.rawValue) 作为新手奖励，区块确认中，请60秒后查看。".local
        let blueColor = UIColor.RGBHex(0x2c84ff)
        
        var blueRange:NSRange = NSRange(location: 0, length: 0)
        let str = title1 as NSString
        blueRange = str.range(of: "100 WTEST")
        
        let att = NSMutableAttributedString(string: title1)
        att.addAttributes([NSAttributedStringKey.foregroundColor : blueColor], range: blueRange)
        
        let v = CommonAlertView(title: att, btnTitles: ["确定".local], frame: CGRect(x: 0, y: 0, width: UIScreen.width(), height: UIScreen.height()))

        v.dismissBlock = {() in
            click()
        }
        v.showAlert()
    }
    
//    class func
    
    //显示
    func showAlert(){
        
        let keyWindow = UIApplication.shared.keyWindow
        self.backgroundColor = UIColor.RGBDecColor(r: 0, g: 0, b: 0, alpha: 0)
        
        
        for vi in (keyWindow?.subviews)!{
            if vi.isKind(of: CommonAlertView.self){
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
        if dismissBlock != nil{
            dismissBlock!()
        }
    }
    
}

//MARK: - private Methods
extension CommonAlertView{
    
    //点击确定
    @objc private func clickConfirm(btn:UIButton){
        
        if clickBlock != nil{
            clickBlock!(btn.tag)
        }
        dismissAlert()
    }
}

//MARK: -UI
extension CommonAlertView{
    
    
    private func buildView(){
        let backV = UIView(frame: self.bounds)
        backV.backgroundColor = UIColor.clear
        self.addSubview(backV)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissAlert))
        backV.addGestureRecognizer(tap)
        
        let vScale = frame.width/375
        let xSpace = frame.width*22/375
        let viewX = (frame.size.width - contentSize.width)/2.0
        let viewY = (frame.size.height - contentSize.height)/2.0
        contentView.frame = CGRect(x: viewX, y: viewY, width: contentSize.width, height: contentSize.height)
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = 6
        self.addSubview(contentView)
        
        let titleLabel = UILabel(frame: CGRect(x: xSpace, y: 0, width: contentView.width() - 2*xSpace, height: vScale*102))
        titleLabel.font = titleFont
        titleLabel.numberOfLines = 0
        titleLabel.textColor = titleColor
        titleLabel.textAlignment = titleTextAl
        titleLabel.attributedText = title
        contentView.addSubview(titleLabel)
        
        
        
        let btnHeight = vScale*44
        var btnWidth = vScale*146
        let leftSpace = vScale*12
        var btnSpace = (contentSize.width - btnWidth*CGFloat(btnTitles.count))/(CGFloat(btnTitles.count)+1)
        if btnSpace<0 {
            btnSpace = 0
        }
        if btnTitles.count == 1 {
            btnWidth = vScale*200
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x:(contentSize.width - btnWidth)/2.0 , y: contentView.height()-leftSpace-btnHeight, width: btnWidth, height: btnHeight)
            btn.setBackgroundImage(UIImage(named: "btn_normal"), for: .normal)

            btn.setTitle(btnTitles[0], for: .normal)
            btn.setTitleColor(UIColor.white, for: .normal)
            btn.layer.cornerRadius = 3
            btn.tag = 0
            btn.addTarget(self, action: #selector(clickConfirm(btn:)), for: .touchUpInside)
            btn.titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 15)
            contentView.addSubview(btn)
        }else{
            for i in 0..<btnTitles.count{
                let btn = UIButton(type: .custom)
                btn.frame = CGRect(x: leftSpace+CGFloat(i)*(btnSpace+btnWidth), y: contentView.height()-leftSpace-btnHeight, width: btnWidth, height: btnHeight)
                if i == 0{
                    btn.addGradientLayer(colors: [UIColor.RGBHex(0xbfcada).cgColor,UIColor.RGBHex(0xb4bcd0).cgColor])
                }else{
                    btn.setBackgroundImage(UIImage(named: "btn_normal"), for: .normal)
                }
                btn.setTitle(btnTitles[i], for: .normal)
                btn.setTitleColor(UIColor.white, for: .normal)
                btn.layer.cornerRadius = 3
                btn.tag = i
                btn.addTarget(self, action: #selector(clickConfirm(btn:)), for: .touchUpInside)
                btn.titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 15)
                contentView.addSubview(btn)
                
            }
        }
        

        
    }
    
}
