//
//  BackupShowPromptView.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/12.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

class BackupShowPromptView: UIView {
    let contentSize = CGSize(width: scale*327, height: scale*133)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BackupShowPromptView{
    private func buildView(){
        self.backgroundColor = UIColor.white
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: scale*4, width: self.width(), height: scale*54))
        titleLabel.text = "导出助记词".local;
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.init(name: "PingFangSC-Semibold", size: 16)
        titleLabel.textColor = UIColor.RGBHex(0x475a82)
        self.addSubview(titleLabel)
        
        let xSpace = scale*20
        
        let firstLabel = UILabel(frame: CGRect(x: xSpace, y: titleLabel.bottom(), width: self.width()-2*xSpace, height: scale*17))
        firstLabel.textAlignment = .left
        firstLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 12)
        firstLabel.textColor = UIColor.RGBHex(0x2c84ff)
        firstLabel.text = "输入您的钱包密码查看助记词".local;
        self.addSubview(firstLabel)
        
        let secondLabel = UILabel(frame: CGRect(x: xSpace, y: firstLabel.bottom()+scale*6, width: self.width()-2*xSpace, height: scale*55))
        secondLabel.textAlignment = .left
        secondLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 12)
        secondLabel.numberOfLines = 0
        secondLabel.textColor = UIColor.RGBHex(0x475a82)
        secondLabel.text = "助记词用于回复钱包或重置钱包密码，请将它准确的抄写到纸上，并存放在只有您自己知道的安全地方".local;
        self.addSubview(secondLabel)
        secondLabel.sizeToFit()
        
    }
}
