//
//  GuideScrollView.swift
//  WaykiApp
//
//  Created by sorath on 2018/10/25.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

class GuideImageManager:NSObject{
    
}


class GuideScrollView: UIScrollView {
    let guidePageTitles:[String] = ["便捷的开庄工具人人可创建竞猜".local,"更多的盘口、更高的赔率".local,"全部数据上链，公开、透明".local]
    var dismissBlock:(()->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension GuideScrollView{
    private func buildView(){
        self.bounces = false
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.isPagingEnabled = true
        self.isScrollEnabled = true
        self.contentSize = CGSize(width: width()*CGFloat(guidePageTitles.count), height: height())
        for index in 0..<guidePageTitles.count {
            let imageV = UIImageView(frame: CGRect(x: self.width()*CGFloat(index), y: 0, width: self.width(), height: self.height()))
            imageV.image = UIImage(named:"guide_image_\(UIDevice.model())_\(index+1)")
            imageV.contentMode = .scaleToFill
            addSubview(imageV)
            
            let labelTop = UIScreen.naviBarHeight() + scale * 20
            let labelHeight:CGFloat = 44

            let showLabel = UILabel(frame: CGRect(x: 0, y: labelTop, width: self.width(), height: labelHeight))
            showLabel.text = guidePageTitles[index]
            showLabel.textAlignment = .center
            showLabel.numberOfLines = 2
            showLabel.textColor = UIColor.RGBHex(0xd9e8f5)
            imageV.addSubview(showLabel)
            if index == guidePageTitles.count-1{
                imageV.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(removeSelf))
                imageV.addGestureRecognizer(tap)
                let btn = UIButton(type: .custom)
                
                let btnWidth = scale*131
                let btnHeight = scale*44
                var btnTop = frame.height - scale*60 - btnHeight
                if UIScreen.height()>=812{
                    btnTop = frame.height - scale*100 - btnHeight
                }
                btn.frame = CGRect(x: (frame.width - btnWidth)/2, y: btnTop, width: btnWidth, height: btnHeight)
                imageV.addSubview(btn)

                btn.setTitle("进入".local, for: UIControlState.normal)
                btn.titleLabel?.font = UIFont.init(name: "PingFangSC-Regular", size: 15)
                btn.setTitleColor(UIColor.white, for: UIControlState.normal)
                btn.layer.cornerRadius = 5
                btn.setBackgroundImage(UIImage(named: "btn_normal"), for: UIControlState.normal)
                btn.addTarget(self, action: #selector(removeSelf), for: UIControlEvents.touchUpInside)
            }
        }
    }
    
    @objc func removeSelf(){
        self.removeFromSuperview()
        if dismissBlock != nil{
            dismissBlock!()
        }
    }
}
