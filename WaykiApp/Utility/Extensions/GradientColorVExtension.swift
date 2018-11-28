//
//  GradientColorVExtension.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/25.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

extension UIView{
    //添加渐变色
    func addGradientLayer(colors:[CGColor]){
        //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        //  创建渐变色数组，需要转换为CGColor颜色
        gradientLayer.colors = colors
        
        //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        //  设置颜色变化点，取值范围 0.0~1.0
        gradientLayer.locations = [0,1]
        
        //  添加
        self.layer.masksToBounds = true
        self.layer.addSublayer(gradientLayer)
        
    }
}
