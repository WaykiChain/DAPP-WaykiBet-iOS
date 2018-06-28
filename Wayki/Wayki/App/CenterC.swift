//
//  CenterC.swift
//  Wayki
//
//  Created by louis on 2018/6/27.
//  Copyright © 2018年 wk. All rights reserved.
//

import UIKit

class CenterC: UIViewController {
    let functions = ["创建钱包","导入钱包","激活","转账","投注","资产查询"]
    override func viewDidLoad() {
        super.viewDidLoad()
        buildV()
    }

}

extension CenterC{
    
    func buildV(){
        title = "功能总汇"
        
        for (index,fu) in functions.enumerated(){
            let btn = UIButton(frame: CGRect(x: 50, y:150+80*CGFloat(index), width: ScreenWidth-100, height: 50))
            btn.tag = index
            btn.backgroundColor = UIColor.black
            btn.setTitle(fu, for: .normal)
            btn.addTarget(self, action: #selector(pushEvent(btn:)), for: .touchUpInside)
            view.addSubview(btn)
        }
    }
    
}

extension CenterC{
    @objc func pushEvent(btn:UIButton){
        switch btn.tag {
        case 0:
            let c = CreateAccountC()
            c.title = functions[btn.tag]
            navigationController?.pushViewController(c, animated: true)
            break
        case 1:
            let c = ImportAccountC()
            c.title = functions[btn.tag]
            navigationController?.pushViewController(c, animated: true)
            break
        case 2:
            let c = ActivateC()
            c.title = functions[btn.tag]
            navigationController?.pushViewController(c, animated: true)
            break
        case 3:
            let c = TransferC()
            c.title = functions[btn.tag]
            navigationController?.pushViewController(c, animated: true)
            break
        case 4:
            let c = BetC()
            c.title = functions[btn.tag]
            navigationController?.pushViewController(c, animated: true)
            break
        default:
            let c = AssertC()
            c.title = functions[btn.tag]
            navigationController?.pushViewController(c, animated: true)
        }
    }
}
