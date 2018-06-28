

import UIKit

enum HTTPPath:String {
    
    case 校验地址是否报名 =  "/gameactivity/checksignupwithaddress/"
    case 查询抽奖次数_G = "/api/gameactivity/selectLuckyCountByAddress?"//address=address

    case 篮球赛事_G = "/api/lottery/basketball/list"
    case 篮球投注记录_G = "/api/lottery/basketball/orderrecords/" // {address}
    case 篮球投注详情_G = "/api/lottery/basketball/orderdetails/" // {address}/{orderid}

    case 足球赛事_G = "/api/lottery/football/list"
    case 足球投注详情_G = "/api/lottery/football/orderdetails/" // {address}/{orderid}
    case 足球投注记录_G = "/api/lottery/football/orderrecords/" // {address}
    
    case 交易详情_G =  "/api/assets/txDetails/" //{address}/{txid}
    case 交易记录_P = "/api/assets/txRecords/"  //{address}
    
    case 获取应用Banner_G = "/api/common/getAppBanner"
    case 获取最新移动版本_G = "/api/common/getLastMobileVersion/" //{apptype} app类型(1.安卓,2.苹果)
    case 获取启动页Banner_G =  "/api/common/getStarterBanner"
    
}

//存储认证相关信息
struct IdentityAndTrust {
    var identityRef:SecIdentity
    var trust:SecTrust
    var certArray:AnyObject
}





