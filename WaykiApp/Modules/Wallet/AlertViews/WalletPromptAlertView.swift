//
//  WalletPromptAlertView.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/6.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

//提示alert （确定、取消、title）
class WalletPromptAlertView: UIView ,UITextFieldDelegate{
    let contentView:UIView = UIView()//content
    let contentSize:CGSize = CGSize(width: scale*327, height: scale*164)
    
    var titleFont = UIFont.init(name: "PingFangSC-Regular", size: 14)
    var titleColor = UIColor.RGBHex(0x475a82)
    
    var title:String = ""
    var btnTitle:String = ""
    var clickBlock:(()->Void)?
    var isHavedCancel:Bool = false
    var isBold:Bool = false
    
    init(title:String,btnTitle:String,isHavedCancel:Bool = false,isBold:Bool = false,frame:CGRect){
        super.init(frame: frame)
        self.title = title
        self.btnTitle = btnTitle
        self.isHavedCancel = isHavedCancel
        self.isBold = isBold
        
        if isBold{
            titleFont = UIFont.init(name: "PingFangSC-Semibold", size: 16)
//            titleColor = UIColor.titleColor()
        }
        
        if isHavedCancel {
            buildView_hadcancel()
        }else{
            buildView_nocancel()
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


//MARK: - public action
extension WalletPromptAlertView{
    //显示
    func showAlert(){

        let keyWindow = UIApplication.shared.keyWindow
        self.backgroundColor = UIColor.RGBDecColor(r: 0, g: 0, b: 0, alpha: 0)
        
        
        for vi in (keyWindow?.subviews)!{
            if vi.isKind(of: WalletPromptAlertView.self){
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
    }
    
}

//MARK: - private Methods
extension WalletPromptAlertView{
    
    //点击确定
    @objc private func clickConfirm(){
        
        if clickBlock != nil{
            clickBlock!()
        }
        dismissAlert()
    }
}

//MARK: -UI
extension WalletPromptAlertView{
    private func buildView_nocancel(){

        
        let backView = UIView(frame: self.bounds)
        backView.backgroundColor = UIColor.clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissAlert))
        backView.isUserInteractionEnabled = true
        backView.addGestureRecognizer(tap)
        self.addSubview(backView)

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
        titleLabel.textAlignment = .center
        titleLabel.text = title
        contentView.addSubview(titleLabel)

        
        
        let btnHeight = vScale*44
        let btnWidth = vScale*146
        let btnX = (contentView.width() - btnWidth)/2.0
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: btnX, y: contentView.height()-frame.width*12/375-btnHeight, width: btnWidth, height: btnHeight)
        btn.setBackgroundImage(UIImage(named: "btn_normal"), for: .normal)
        btn.setTitle(btnTitle, for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = 3
        btn.addTarget(self, action: #selector(clickConfirm), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 15)
        contentView.addSubview(btn)
        
        
    }
    
    
    private func buildView_hadcancel(){
        
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
        titleLabel.textAlignment = .center
        titleLabel.text = title
        contentView.addSubview(titleLabel)
        
        
        
        let btnHeight = vScale*44
        let btnWidth = vScale*146
        let leftSpace = vScale*12
        
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.frame = CGRect(x: leftSpace, y: contentView.height()-frame.width*12/375-btnHeight, width: btnWidth, height: btnHeight)
        cancelBtn.backgroundColor = UIColor.RGBHex(0xbfcada)
        cancelBtn.setTitle("关闭".local, for: .normal)
        cancelBtn.setTitleColor(UIColor.white, for: .normal)
        cancelBtn.layer.cornerRadius = 3
        cancelBtn.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        cancelBtn.titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 15)
        contentView.addSubview(cancelBtn)
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: cancelBtn.right()+leftSpace, y: contentView.height()-frame.width*12/375-btnHeight, width: btnWidth, height: btnHeight)
        btn.setBackgroundImage(UIImage(named: "btn_normal"), for: .normal)
        btn.setTitle(btnTitle, for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.layer.cornerRadius = 3
        btn.addTarget(self, action: #selector(clickConfirm), for: .touchUpInside)
        btn.titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 15)
        contentView.addSubview(btn)
    }
    
}
