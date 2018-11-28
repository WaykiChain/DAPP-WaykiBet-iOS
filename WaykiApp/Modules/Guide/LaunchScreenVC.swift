//
//  LaunchScreenVC.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/17.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit
import CoreTelephony

class LaunchScreenVC: UIViewController {
    var connectStatus:Bool = false
    let reachability = Reachability()!

    override func viewDidLoad() {
        super.viewDidLoad()
        getAndShowLaunchImage()
        //网络权限
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+5, execute: {
            
            self.networkStatusListener()
        })
        //开始请求接口，配置app
        self.firstStartConfigure()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.firstStartConfigure()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // 移除消息通知
    deinit {
        // 关闭网络状态消息监听
        reachability.stopNotifier()
        // 移除网络状态消息通知
        NotificationCenter.default.removeObserver(self)
    }

}

//程序Configure
extension LaunchScreenVC{
    //初次开始流程
    private func  firstStartConfigure(){
        connectStatus = true
        startConfigure()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+5) {
            if UIApplication.shared.keyWindow?.rootViewController == self {
                //如果开始配置5s还没有完成（更换根控制器），则更改状态为未连接
                self.connectStatus = false
            }
        }
    }
    
    private func startConfigure(){
        ConfigureManager.configure()
    }
}

//Reachability
extension LaunchScreenVC{
    //开始监听
    private func networkStatusListener() {
        // 1、设置网络状态消息监听 2、获得网络Reachability对象
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: Notification.Name.reachabilityChanged,object: reachability)
        do{
            // 3、开启网络状态消息监听
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
    }
    
    // 主动检测网络状态
    @objc func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability // 准备获取网络连接信息
        
        if reachability.connection != .none { // 判断网络连接状态
            print("网络连接：可用")
            if reachability.connection == .wifi { // 判断网络连接类型
                print("连接类型：WiFi")
            } else {
                print("连接类型：移动网络")
            }
            //如果状态是未连接，且网络状态切换，并且根控制器是本vc，则再次开始流程
            if connectStatus == false && UIApplication.shared.keyWindow?.rootViewController == self&&UIApplication.shared.keyWindow?.rootViewController?.presentedViewController==nil{
                firstStartConfigure()
            }
        } else {
            print("网络连接：不可用")
            connectStatus = false
            DispatchQueue.main.async { // 不加这句导致界面还没初始化完成就打开警告框，这样不行
                self.alert_noNetwrok() // 警告框，提示没有网络
            }
        }
    }
    
    // 警告框，提示没有连接网络 *********************
    func alert_noNetwrok() -> Void {
        DispatchQueue.main.async(execute: { () -> Void in
            let alertController = UIAlertController(title: "网络已关闭".local,
                                                    message: "请打开网络设置，确保设备联网".local,
                                                    preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title:"取消".local, style: .cancel, handler:nil)
            
            let settingsAction = UIAlertAction(title:"设置".local, style: .default, handler: {
                (action) -> Void in
                let url = URL(string: UIApplicationOpenSettingsURLString)
                if let url = url, UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url, options: [:],
                                                  completionHandler: {
                                                    (success) in
                        })
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            
            self.present(alertController, animated: true, completion: nil)
        })
    }
}


extension LaunchScreenVC{
    /// 检测是否开启联网
    func openEventServiceWithBolck(action :@escaping ((Bool)->())) {
        let cellularData = CTCellularData()
        cellularData.cellularDataRestrictionDidUpdateNotifier = { (state) in
            if state == CTCellularDataRestrictedState.restrictedStateUnknown ||  state == CTCellularDataRestrictedState.notRestricted {
                action(false)
            } else {
                action(true)
            }
        }
        let state = cellularData.restrictedState
        if state == CTCellularDataRestrictedState.restrictedStateUnknown ||  state == CTCellularDataRestrictedState.notRestricted {
            action(false)
        } else {
            action(true)
        }
    }

}

//LaunchImage
extension LaunchScreenVC{
    //获取并展示启动页
    private func getAndShowLaunchImage(){
        //获取启动页图片
        let image = LaunchImageManager.getLaunchImage()
        let v = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.width(), height: UIScreen.height()))
        v.image = image
        view.addSubview(v)
    }
}
