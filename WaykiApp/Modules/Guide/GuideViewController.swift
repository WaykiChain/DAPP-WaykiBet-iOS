//
//  GuideViewController.swift
//  WaykiApp
//
//  Created by sorath on 2018/10/25.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getAndShowLaunchImage()
  
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if checkIfNeed() == false {
            showGuide()
        }else{
            startConfigure()
        }
    }
    
    private func checkIfNeed() ->Bool{
        if UserDefaults.standard.string(forKey: "isShowGuide") == "true"{
            
            return true
        }
        
        return false
    }
    
    private func showGuide(){
        let guideScrollView = GuideScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.width(), height: UIScreen.height()))
        guideScrollView.dismissBlock = { [weak self]() in
            self?.startConfigure()
        }
        UserDefaults.standard.set("true", forKey: "isShowGuide")
        self.view.addSubview(guideScrollView)
    }
    
    private func startConfigure(){
        let c = LaunchScreenVC()
        UIApplication.shared.keyWindow?.rootViewController = c
    }
    
}
//LaunchImage
extension GuideViewController{
    //获取并展示启动页
    private func getAndShowLaunchImage(){
        //获取启动页图片
        let image = LaunchImageManager.getLaunchImage()
        let v = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.width(), height: UIScreen.height()))
        v.image = image
        view.addSubview(v)
    }
}
