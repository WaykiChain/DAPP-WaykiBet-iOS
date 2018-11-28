//
//  WalletM_BottomView.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/4.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

class WalletM_BottomView: UIView {
    let labelHieght = scale*30
    let labelTopSpace = scale*15
    let mX = scale*154-scale*16
    
    
    var clickBlock:((Int) ->Void)?
    var wiccLabel:UILabel = UILabel()   //wicc余额
    var rmbLabel:UILabel = UILabel()    //价值
    var lockLabel:UILabel = UILabel()  //锁仓额度
    var tokenRMBLabel:UILabel = UILabel() //token价值
    
    var wkdNameLabel:UILabel = UILabel()  //代币名称label
    var wkdLabel:UILabel = UILabel()  //代币额度

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildView()
        self.clipsToBounds = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - UI
extension WalletM_BottomView{
    private func buildView(){
        self.addSubview(createWICCV())
        //self.addSubview(createLockV())
        self.addSubview(createWKDV())
    }
    
    
    private func createWICCV() ->UIView{
        let backV = UIView(frame: CGRect(x: 0, y: 0, width: self.width(), height: self.height()/2))

        let coinNameLabel = UILabel(frame: CGRect(x: 0, y: labelTopSpace, width: 67, height: labelHieght))
        coinNameLabel.font = UIFont.init(name: "Helvetica-Bold", size: 18)
        coinNameLabel.textColor = UIColor.fontWhite()
        coinNameLabel.text = CoinType.wicc.rawValue
        backV.addSubview(coinNameLabel)
        
        rmbLabel.frame = CGRect(x: coinNameLabel.right(), y: coinNameLabel.top(), width: mX, height: coinNameLabel.height())
        rmbLabel.font = UIFont.init(name: "Helvetica", size: 12)
        rmbLabel.textColor = UIColor.RGBHex(0x7690c3)
        backV.addSubview(rmbLabel)
        
        let rightV = UIView(frame: CGRect(x: mX, y: 0, width: backV.width() - mX, height: backV.height()))
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickWICC))
        rightV.addGestureRecognizer(tap)
        rightV.isUserInteractionEnabled = true
        backV.addSubview(rightV)
    
        
        let imageWidth = scale*6
        let imageHeight = scale*12
        let arrowImageView = UIImageView(frame: CGRect(x: rightV.width()-imageWidth, y: (rightV.height()-imageHeight)/2, width: imageWidth, height: imageHeight))
        arrowImageView.image = UIImage(named: "arrow_right")
        rightV.addSubview(arrowImageView)
        
        wiccLabel.frame =  CGRect(x: 0, y: labelTopSpace, width: rightV.width()-arrowImageView.width() - scale*9, height: labelHieght)
        wiccLabel.textAlignment = .right
        wiccLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 13)
        wiccLabel.textColor = UIColor.amountColor()
        rightV.addSubview(wiccLabel)
        
        let lineV = UIView(frame: CGRect(x: 0, y: rightV.height()-1, width: backV.width(), height: 1))
        lineV.backgroundColor = UIColor.RGBHex(0x323f64)
        backV.addSubview(lineV)

        return backV
    }
    
    
    private func createWKDV() ->UIView{
        let backV = UIView(frame: CGRect(x: 0, y:self.height()*1/2, width: self.width(), height: self.height()/2))
        wkdNameLabel.frame = CGRect(x: 0, y: labelTopSpace, width: 67, height: labelHieght)
        wkdNameLabel.font = UIFont.init(name: "Helvetica-Bold", size: 18)
        wkdNameLabel.textColor = UIColor.fontWhite()
        wkdNameLabel.text = ""
        backV.addSubview(wkdNameLabel)
        
        tokenRMBLabel.frame = CGRect(x: wkdNameLabel.right(), y: wkdNameLabel.top(), width: mX, height: wkdNameLabel.height())
        tokenRMBLabel.font = UIFont.init(name: "Helvetica", size: 12)
        tokenRMBLabel.textColor = UIColor.RGBHex(0x7690c3)
        backV.addSubview(tokenRMBLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickWKD))
        backV.addGestureRecognizer(tap)
        backV.isUserInteractionEnabled = true
        
        
        let imageWidth = scale*6
        let imageHeight = scale*12
        let arrowImageView = UIImageView(frame: CGRect(x: backV.width()-imageWidth, y: (backV.height()-imageHeight)/2, width: imageWidth, height: imageHeight))
        arrowImageView.image = UIImage(named: "arrow_right")
        backV.addSubview(arrowImageView)
        
        wkdLabel.frame =  CGRect(x: 0, y: labelTopSpace, width: backV.width()-arrowImageView.width() - scale*9, height: labelHieght)
        wkdLabel.textAlignment = .right
        wkdLabel.font = UIFont.init(name: "PingFangSC-Regular", size: 13)
        wkdLabel.textColor = UIColor.amountColor()
        backV.addSubview(wkdLabel)
        return backV
    }
}

//MARK: - action
extension WalletM_BottomView{
    @objc private func clickWICC(){
        if clickBlock != nil {
            clickBlock!(1)
        }
    }
    
    @objc private func clickLock(){
        if clickBlock != nil {
            clickBlock!(2)
        }
    }
    
    @objc private func clickWKD(){
        if clickBlock != nil {
            clickBlock!(3)
        }
    }
}
