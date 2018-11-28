//
//  WaykiBtn.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/30.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

extension UIButton {
    func setIconInLeft() {
        setIconInLeftWithSpacing(0)
    }
    
    func setIconInRight() {
        setIconInRightWithSpacing(0)
    }
    func setIconInTop() {
        
        setIconInTopWithSpacing(0)
    }
    
    func setIconInBottom() {
        
        setIconInBottomWithSpacing(0)
        
    }
    
    func setIconInLeftWithSpacing(_ Spacing: CGFloat) {
        
        titleEdgeInsets = UIEdgeInsets()
        
        titleEdgeInsets.top = 0
        
        titleEdgeInsets.`left` = 0
        
        titleEdgeInsets.bottom = 0
        
        titleEdgeInsets.`right` = 0
        
        imageEdgeInsets = UIEdgeInsets()
        
        imageEdgeInsets.top = 0
        
        imageEdgeInsets.`left` = 0
        
        imageEdgeInsets.bottom = 0
        
        imageEdgeInsets.`right` = 0
        
    }
    
    func setIconInRightWithSpacing(_ Spacing: CGFloat) {
        
        let img_W: CGFloat! = (imageView?.frame.size.width) != nil ? imageView?.frame.size.width : 0
        
        let tit_W: CGFloat! = (titleLabel?.frame.size.width) != nil ? (titleLabel?.frame.size.width) : 0
        
        titleEdgeInsets = UIEdgeInsets()
        titleEdgeInsets.top = 0
        
        titleEdgeInsets.`left` = -(img_W + Spacing / 2)
        
        titleEdgeInsets.bottom = 0
        
        titleEdgeInsets.`right` = img_W + Spacing / 2
        
        imageEdgeInsets = UIEdgeInsets()
        
        imageEdgeInsets.top = 0
        
        imageEdgeInsets.`left` = tit_W + Spacing / 2
        
        imageEdgeInsets.bottom = 0
        
        imageEdgeInsets.`right` = -(tit_W + Spacing / 2)
        
        
    }
    
    func setIconInTopWithSpacing(_ Spacing: CGFloat) {
        
        let img_W: CGFloat! = (imageView?.frame.size.width) != nil ? imageView?.frame.size.width : 0
        
        let img_H: CGFloat! = (imageView?.frame.size.height) != nil ? imageView?.frame.size.height : 0
        
        let tit_W: CGFloat! = (titleLabel?.frame.size.width) != nil ? (titleLabel?.frame.size.width) : 0

        let tit_H: CGFloat! = (titleLabel?.frame.size.height) != nil ? titleLabel?.frame.size.height : 0
        
        titleEdgeInsets = UIEdgeInsets()
        
        titleEdgeInsets.top = tit_H / 2 + Spacing / 2
        
        titleEdgeInsets.`left` = -(img_W / 2)
        
        titleEdgeInsets.bottom = -(tit_H / 2 + Spacing / 2)
        
        titleEdgeInsets.`right` = img_W / 2
        
        imageEdgeInsets = UIEdgeInsets()
        
        imageEdgeInsets.top = -(img_H / 2 + Spacing / 2)
        
        imageEdgeInsets.`left` = tit_W / 2
        
        imageEdgeInsets.bottom = img_H / 2 + Spacing / 2
        
        imageEdgeInsets.`right` = -(tit_W / 2)
        
    }
    
    func setIconInBottomWithSpacing(_ Spacing: CGFloat) {
        
        let img_W: CGFloat! = imageView?.frame.size.width
        
        let img_H: CGFloat! = imageView?.frame.size.height
        
        let tit_W: CGFloat! = titleLabel?.frame.size.width
        
        let tit_H: CGFloat! = titleLabel?.frame.size.height
        
        titleEdgeInsets = UIEdgeInsets()
        
        titleEdgeInsets.top = -(tit_H / 2 + Spacing / 2)
        
        titleEdgeInsets.`left` = -(img_W / 2)
        
        titleEdgeInsets.bottom = tit_H / 2 + Spacing / 2
        
        titleEdgeInsets.`right` = img_W / 2
        
        imageEdgeInsets = UIEdgeInsets()
        
        imageEdgeInsets.top = img_H / 2 + Spacing / 2
        
        imageEdgeInsets.`left` = tit_W / 2
        
        imageEdgeInsets.bottom = -(img_H / 2 + Spacing / 2)
        
        imageEdgeInsets.`right` = -(tit_W / 2)
        
    }
    
    
}
