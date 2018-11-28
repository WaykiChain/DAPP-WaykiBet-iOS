//
//  AuthorityManager.swift
//  WaykiApp
//
//  Created by louis on 2018/8/24.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit
import LocalAuthentication


fileprivate let faceIDString = "FaceID-Authorization"
fileprivate let touchIDString = "TouchID-Authorization"

class AuthorityManager: NSObject {
    
    class func faceID(isUseable:@escaping ((Bool)->()),isPass:@escaping ((Bool)->())){
        if #available(iOS 11.0, *) {
            var authError:NSError? = nil
            let context:LAContext = LAContext()
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError){
                if context.biometryType != .faceID{
                    isUseable(false)
                    return
                }
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: faceIDString) { (success, err) in
                    if success {
                        isPass(true)
                    }else{
                        isPass(false)
                    }
                }
            }
        }else{
            isUseable(false)
        }
    }
    
    //    class func touchID(isUseable:@escaping ((Bool)->()),isPass:@escaping ((Bool)->())){
    //        if #available(iOS 8.0, *){
    //            let context:LAContext = LAContext()
    //            var authorString = ""
    //
    //            /// 系统faceID是否可用
    //            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError){
    //                if context.biometryType != .touchID{
    //                    isUseable(false)
    //                    return
    //                }
    //                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: touchIDString) { (success, err) in
    //                    if success {
    //                        isPass(true)
    //                    }else{
    //                        isPass(false)
    //                    }
    //                }
    //            }
    //        }
    //    }
    
}
