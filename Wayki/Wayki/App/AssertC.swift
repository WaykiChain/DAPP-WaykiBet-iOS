//
//  AssertC.swift
//  Wayki
//
//  Created by louis on 2018/6/26.
//  Copyright © 2018年 wk. All rights reserved.
//

import UIKit

class AssertC: UIViewController {

    var wiccLabel:UILabel!
    var tokenLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildV()
    }

}


extension AssertC{
    func buildV(){
        view.backgroundColor = UIColor.white
        wiccLabel = UILabel(frame: CGRect(x: 0, y: 150, width: ScreenWidth, height: 50))
        wiccLabel.numberOfLines = 0
        wiccLabel.font = UIFont.systemFont(ofSize: 13)
        wiccLabel.textAlignment = .center
        view.addSubview(wiccLabel)
        
        tokenLabel = UILabel(frame: CGRect(x: 0, y: 250, width: ScreenWidth, height: 50))
        tokenLabel.numberOfLines = 0
        tokenLabel.font = UIFont.systemFont(ofSize: 13)
        tokenLabel.textAlignment = .center
        view.addSubview(tokenLabel)
        
        let btn = UIButton(frame: CGRect(x: 0, y: 350, width: ScreenWidth, height: 60))
        btn.backgroundColor = UIColor.blue
        btn.setTitle("查询账户余额", for: .normal)
        btn.addTarget(self, action: #selector(getAssertCount), for: .touchUpInside)
        view.addSubview(btn)
    }
}


extension AssertC{
    
    @objc func getAssertCount(){
        
        // 获取wicc的总量
        JsonRpcManager.getBalance(succeed: { [weak self](count, regid) in
            self?.wiccLabel.text = "WICC: \(count)"
        }) { (str) in
            UILabel.showFalureHUD(text: str)
        }
        
        // 获取spc的总量
        JsonRpcManager.getTokenBalance(succeed: { [weak self](count) in
            self?.tokenLabel.text = "Token: \(count)"
        }) { (str) in
            UILabel.showFalureHUD(text: str)
        }
    }
    
    
}
