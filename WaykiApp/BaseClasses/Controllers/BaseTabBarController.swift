//
//  BaseTabBarController.swift
//  WaykiApp
//
//  Created by louis on 2018/8/24.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit
import Kingfisher


class BaseTabBarController: UITabBarController ,UITabBarControllerDelegate,UINavigationControllerDelegate{
    var tabbarItems:[TabbarItemModel] = []

    var isBind = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        //获取绑定信息
        checkRequest {

        }
        
        //获取合约地址
        WalletCommonRequestManager.getContractInfo { (model) in

        }
        //如果没有数据，则获取一套测试的环境
        if tabbarItems.count == 0{
            tabbarItems = GetAppInfoManager.getTestModels()
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("Noti_refreshBindInfo"), object: nil, queue: OperationQueue.main) { (noti) in
            self.isBind = true
            self.checkRequest {
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    override func viewWillLayoutSubviews() {
        if !UIDevice.isX(){
            var tabFrame = tabBar.frame
            tabFrame.size.height = 60
            tabFrame.origin.y = view.frame.size.height - 60
            tabBar.frame = tabFrame
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
 
}

extension BaseTabBarController{
    
    func checkRequest(alert:@escaping(()->Void)){
        //在此判断帐号是否绑定过
        BindWalletManager.getPhoneBindWallet { (address) in
            if AccountManager.getAccount().address != address{
                //如果钱包地址不一样的逻辑，已经在登录时处理了(钱包信息不一致则清除)
                AccountManager.getAccount().address = address
            }
            if address.count == 0{
                self.isBind = false
                alert()
            }else{
                self.isBind = true
            }
        }
    }
}

extension BaseTabBarController{
    
    @objc func build(datas:[TabbarItemModel]) -> UITabBarController {
        tabbarItems = datas
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.white], for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.white], for: .selected)
        var naviArray:[UIViewController] = []
        
        tabBar.isTranslucent = false
        tabBar.barTintColor =  UIColor.bgColor()
        // tabBar.backgroundImage = UIImage(named: UIDevice.isX() ? "blue_tabbar_x":"blue_tabbar")
        
        for i in 0..<tabbarItems.count{
            
            let model = tabbarItems[i]
            let c:UIViewController
            if model.type == 100{
                //web
                let vc = ItemsWebController()
                var url = model.redirectUrl
                if (url.contains("https") == false)&&url.contains("http") == false{
                    url = netpro+hostName+port+url
                }
                vc.url = url
                c = vc
                if model.title.local == "我".local{
                    vc.isNotBGColor = false
                }
            }else{
                //yu
                c = WalletVC()
            }

            
            c.title = model.title.local
            let navi = UINavigationController.init(rootViewController: c)
            navi.navigationBar.isHidden = true
            navi.navigationBar.backgroundColor = UIColor.clear
            navi.delegate = self
            
            // 标签页
            //预设图片
            if i == 0{
                navi.tabBarItem.image = UIImage(named: "bet_normal")
                navi.tabBarItem.selectedImage = UIImage(named: "bet_selected")
            }else if i == 1{
                navi.tabBarItem.image = UIImage(named: "wallet_normal")
                navi.tabBarItem.selectedImage = UIImage(named: "wallet_selected")
            }else{
                navi.tabBarItem.image = UIImage(named: "me_normal")
                navi.tabBarItem.selectedImage = UIImage(named: "me_selected")
            }

            var imageUrl:String = ""
            var selectedUrl:String = ""
            if UIScreen.phoneIs3x(){
                imageUrl = model.imageUrlThird
                selectedUrl = model.selectImageUrlThird
            }else{
                imageUrl = model.imageUrlSecond
                selectedUrl = model.selectImageUrlSecond
            }
 
            
            //下载
            UIImageView().kf.setImage(with: URL.init(string: imageUrl), placeholder: navi.tabBarItem.image, options: nil, progressBlock: nil) { (image, error, cache, url) in
                if image != nil{
                    let resultImage = image?.compressScale(size: CGSize(width: 30, height: 30))
                    navi.tabBarItem.image = resultImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
                }
             
            }
            UIImageView().kf.setImage(with: URL.init(string: selectedUrl), placeholder: navi.tabBarItem.image, options: nil, progressBlock: nil) { (image, error, cache, url) in
                if image != nil{
                    
                   let resultImage = image?.compressScale(size: CGSize(width: 30, height: 30))
                    navi.tabBarItem.selectedImage = resultImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
                }
            }
            navi.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.RGBHex(0x2e86ff),NSAttributedStringKey.font:UIFont.systemFont(ofSize: 10)], for: .selected)
            navi.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.RGBHex(0x657dae),NSAttributedStringKey.font:UIFont.systemFont(ofSize: 10)], for: .normal)
                naviArray.append(navi)
        
        }
        self.viewControllers = naviArray
        
        tabBar.backgroundColor = UIColor.bgColor()
        tabBar.layer.shadowRadius = 3
        tabBar.layer.shadowOpacity = 0.5
        if UIScreen.naviBarHeight()==64 {
            for it in  tabBar.items! {
                it.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4)
            }
        }else{
            for it in  tabBar.items! {
                it.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 4)
            }
        }
        return self;
    }
    
    
}

//MARK: - UITabBarControllerDelegate
extension BaseTabBarController{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is UINavigationController{
            let nav = viewController as! UINavigationController
            if nav.viewControllers.first is WalletVC{
                //判断，如果 是钱包vc 且 没有绑定钱包,则弹出创建钱包
                if isBind == false{
                    let c = CreateWalletVC()
                    UIApplication.shared.keyWindow?.rootViewController?.present(c, animated: true, completion: nil)
                    return false
                }
                
            }
        }

        return true
    }
}

