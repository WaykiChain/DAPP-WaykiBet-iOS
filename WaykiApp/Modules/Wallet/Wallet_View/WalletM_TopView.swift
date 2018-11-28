//
//  WalletM_TopView.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/4.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

class WalletM_TopView: UIView {
    let leftspace:CGFloat = scale*16
    var clickBlock:((Int) ->Void)?
    var isActivate:Bool = true

    var getWiccBtn = UIButton(type: .custom)
    var moreBtn = UIButton(type: .custom)
    var codeBtn = UIButton(type: .custom)
    var pasteBtn = UIButton(type: .custom)
    var rateLabel = UILabel()  //具体显示汇率
    var addressLabel:UILabel = UILabel()
    var activeBtn:UIButton! //激活按钮
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildView()
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WalletM_TopView{
    private func buildView(){
        let btnWidth:CGFloat = scale*40
        let btnY:CGFloat
        if UIDevice.isX(){
            btnY = 40
        }else{
            btnY = 24
        }
        
        moreBtn.frame = CGRect(x: UIScreen.width() - btnWidth - scale*8, y: btnY, width: btnWidth, height: btnWidth)
        moreBtn.setImage(UIImage(named: "wallet_more"), for: .normal)
        moreBtn.tag = 1
        moreBtn.addTarget(self, action: #selector(clickBtn(btn:)), for: .touchUpInside)
        self.addSubview(moreBtn)
        
        getWiccBtn.frame = CGRect(x: 0, y: moreBtn.top() + scale * 6, width: scale * 82, height: scale * 28)
        getWiccBtn.tag = 5
        getWiccBtn.setTitle("获取WICC".local, for: .normal)
        getWiccBtn.addTarget(self, action: #selector(clickBtn(btn:)), for: .touchUpInside)
        self.addSubview(getWiccBtn)
        
        let path = UIBezierPath(roundedRect: getWiccBtn.bounds, byRoundingCorners: [UIRectCorner.topRight,UIRectCorner.bottomRight], cornerRadii: CGSize(width: getWiccBtn.height()/2, height: getWiccBtn.height()/2))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        getWiccBtn.layer.mask = shapeLayer
        getWiccBtn.addGradientLayer(colors: [UIColor.RGBHex(0x2e86ff).cgColor,UIColor.RGBHex(0x2861de).cgColor])
        
        getWiccBtn.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 14)

        let addressWidth:CGFloat = 270
        
        addressLabel = UILabel(frame: CGRect(x: (self.width() - addressWidth)/2, y: moreBtn.bottom()+scale*26, width: addressWidth, height: 15))
        addressLabel.font = UIFont.init(name: "Helvetica", size: 13)
        addressLabel.textAlignment = .center
        addressLabel.textColor = UIColor.amountColor()
        addressLabel.text = ""

        self.addSubview(addressLabel)
        
        activeBtn = UIButton(type: .custom)
        activeBtn.frame = CGRect(x: addressLabel.right(), y: addressLabel.top(), width: 60, height: addressLabel.height())
        activeBtn.addTarget(self, action: #selector(clickBtn(btn:)), for: .touchUpInside)
        activeBtn.tag = 6
        activeBtn.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 12)
        activeBtn.setAttributedTitle(NSAttributedString.init(string: "激活".local, attributes: [NSAttributedStringKey.underlineStyle : NSNumber(integerLiteral: NSUnderlineStyle.styleSingle.rawValue),NSAttributedStringKey.foregroundColor:UIColor.RGBHex(0x2e83fc)]), for: .normal)
        changeActiveStatus(isActivate: self.isActivate)
        self.addSubview(activeBtn)
        
        
        let iconWidth = scale*24
        let iconY = addressLabel.bottom() + scale*35
        let xSpace:CGFloat = (self.width() - 3*iconWidth)/4
        
        
        codeBtn.frame = CGRect(x: xSpace, y: iconY, width: iconWidth, height: iconWidth)
        codeBtn.setImage(UIImage(named: "code_icon"), for: .normal)
        codeBtn.addTarget(self, action: #selector(clickBtn(btn:)), for: .touchUpInside)
        codeBtn.tag = 2

        self.addSubview(codeBtn)
        
        let scanBtn = UIButton(type: .custom)
        scanBtn.frame = CGRect(x:codeBtn.right() + xSpace, y: iconY, width: iconWidth, height: iconWidth)
        scanBtn.setImage(UIImage(named: "scan_icon"), for: .normal)
        scanBtn.addTarget(self, action: #selector(clickBtn(btn:)), for: .touchUpInside)
        scanBtn.tag = 3

        self.addSubview(scanBtn)
        
        
        pasteBtn.frame = CGRect(x: scanBtn.right() + xSpace, y: iconY, width: iconWidth, height: iconWidth)
        pasteBtn.setImage(UIImage(named: "wallet_copy"), for: .normal)
        pasteBtn.addTarget(self, action: #selector(clickBtn(btn:)), for: .touchUpInside)
        pasteBtn.tag = 4

        self.addSubview(pasteBtn)
        
        let rateTitleLabel = UILabel(frame: CGRect(x: leftspace, y: codeBtn.bottom()+scale*38, width: 36, height: 14))
        rateTitleLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 12)
        rateTitleLabel.text = "汇率：".local
        rateTitleLabel.textColor = UIColor.RGBHex(0x7690c3)
        self.addSubview(rateTitleLabel)
        
        rateLabel.frame = CGRect(x: rateTitleLabel.right(), y: rateTitleLabel.top(), width: 200, height: 14)
        rateLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 12)
        rateLabel.textColor = UIColor.white
        self.addSubview(rateLabel)
        
    }
}

//MARK: - action
extension WalletM_TopView{
    @objc private func clickBtn(btn:UIButton){
        if clickBlock != nil{
            clickBlock!(btn.tag)
        }
    }
    
    func setAddress(address:String){
        let addressCount = address.count
        if addressCount>30{
            let address:NSString = address as NSString
            addressLabel.text = address.replacingCharacters(in: NSMakeRange(addressCount/2-5, 10), with: "****")
        }
    }
    
    //改变激活按钮状态
    func changeActiveStatus(isActivate:Bool){
        self.isActivate = isActivate
        if isActivate {
            self.activeBtn.isHidden = true
        }else{
            self.activeBtn.isHidden = false
        }
    }
    
}
