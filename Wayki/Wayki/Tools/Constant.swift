

import UIKit


let scale:CGFloat = ScreenWidth/375
let appVersion:String =  Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
let kWindowCV = UIApplication.shared.keyWindow?.rootViewController?.view
let kWindowC = UIApplication.shared.keyWindow?.rootViewController

let ScreenHeight = UIScreen.main.bounds.height
let ScreenWidth = UIScreen.main.bounds.width
let naviHeight:CGFloat = UIDevice.isX() ? 88 : 64
let tabbarHeight:CGFloat = UIDevice.isX() ? 80 : 49


class Constant: NSObject {

}


