//
//  OnlyPromptView.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/21.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

class OnlyPromptView: UIView {
    
    let promptLabel = UILabel()
    var promptStr:String = ""
    init(frame: CGRect,promptStr:String) {
        super.init(frame: frame)
        self.promptStr = promptStr
        buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension OnlyPromptView{
    private func buildView(){
        promptLabel.frame = CGRect(x: scale*22, y: 0, width: self.width() - 2*scale*22, height: self.height())
        promptLabel.textAlignment = .left
        promptLabel.text = promptStr
        promptLabel.numberOfLines = 0
        promptLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 15)
        promptLabel.textColor = UIColor.RGBHex(0x475182)
        self.addSubview(promptLabel)
    }
}
