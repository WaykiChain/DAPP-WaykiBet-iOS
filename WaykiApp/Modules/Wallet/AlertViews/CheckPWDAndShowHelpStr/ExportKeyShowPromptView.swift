//
//  ExportKeyShowPromptView.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/12.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

class ExportKeyShowPromptView: UIView {
    let contentSize = CGSize(width: scale*327, height: scale*133)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ExportKeyShowPromptView{
    private func buildView(){
        self.backgroundColor = UIColor.white
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: scale*4, width: self.width(), height: scale*54))
        titleLabel.text = "导出私钥".local;
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.init(name: "PingFangSC-Semibold", size: 16)
        titleLabel.textColor = UIColor.RGBHex(0x475a82)
        self.addSubview(titleLabel)
        
        let xSpace = scale*20
        
        
        let warningImageView = UIImageView(image: UIImage(named: "wallet_warning"))
        warningImageView.frame = CGRect(x: xSpace, y: titleLabel.bottom(), width: scale*18, height: scale*14)
        self.addSubview(warningImageView)
        
        let firstLabel = UILabel(frame: CGRect(x: warningImageView.right()+scale*10, y: warningImageView.top(), width: self.width()-warningImageView.right(), height: warningImageView.height()))
        firstLabel.textAlignment = .left
        firstLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 14)
        firstLabel.textColor = UIColor.RGBHex(0x2c84ff)
        firstLabel.text = "警告".local;
        self.addSubview(firstLabel)
        
        let secondLabel = UILabel(frame: CGRect(x: xSpace, y: firstLabel.bottom()+scale*10, width: self.width()-2*xSpace, height: scale*55))
        secondLabel.textAlignment = .left
        secondLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 12)
        secondLabel.numberOfLines = 0
        secondLabel.textColor = UIColor.RGBHex(0x475a82)
        secondLabel.text = "私钥未加密，泄漏风险极大，请保存在安全的位置".local;
        self.addSubview(secondLabel)
        secondLabel.sizeToFit()
        
    }
}
