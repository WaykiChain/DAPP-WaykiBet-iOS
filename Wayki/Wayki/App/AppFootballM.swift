
import UIKit


class AppFootballM: NSObject {
    
    var 截止时间:String = "" // bjdate (string
    var 投注时间:String = "" //判断是否已投注
    var 赛事唯一ID:String = "" // lid 赛事唯一ID,组装投注合约时要用
    
    var 币符号:String = "" // symbol ，例如：WICC,SPC
    var 赛事id主键:Int = 0 // lotteryid 赛事id主键,投注时要作为参数上传
    /// 合约地址
    var 联赛名称:String = "" // league
    var 比赛时间_秒:Double = 0 // bjdate (string
    var 比赛时间:String = "" // bjdate (string
    var 主队名称:String = "" // hometeam
    var 主队图标:String = "" // hometeamicon
    var 客队名称:String = "" // visitingteam
    var 客队图标:String = "" // visitingteamicon
    var 玩法列表:[AppFootballTypeM] = []    // playtypes
    var 投注次数:Int = 0 // betnum integer
    var 是否热门:Int = 0 // hot (true:热门,false:非热门)
    var 奖池金额:Int = 0 // jackpot
    

    class func getModels(json:JSON)->[AppFootballM]{
        var array:[AppFootballM] = []
        if let dic = json.dictionary{
            if let status = dic["status"]?.intValue{if status != 1 {return array }}
            if let results = dic["result"]?.array{
                for res in results {
                    let model = AppFootballM()
                    model.getModel(json:res)
                    array.append(model)
                }
            }
        }
        return array
    }
    
    func getModel(json:JSON){
        if let sep = json["symbol"].string{ 币符号 =  sep }
        if let sep = json["lid"].string{ 赛事唯一ID =  sep }
        if let sep = json["league"].string{ 联赛名称 =  sep }
        if let sep = json["bjdate"].double{
            比赛时间 = Date(timeIntervalSince1970: TimeInterval(sep/1000)).dayString()
        }
        if let sep = json["bjdate"].double{ 比赛时间_秒 = sep/1000}
        if let sep = json["lotteryid"].int{ 赛事id主键 =  sep }
        if let sep = json["hometeam"].string{ 主队名称 =  sep }
        if let sep = json["hometeamicon"].string{ 主队图标 =  sep }
        if let sep = json["visitingteam"].string{ 客队名称 =  sep }
        if let sep = json["visitingteamicon"].string{ 客队图标 =  sep }
        
        if let sep = json["betnum"].int{ 投注次数 =  sep }
        if let sep = json["hot"].int{ 是否热门 =  sep }
        if let sep = json["jackpot"].int{ 奖池金额 =  sep }
        
        玩法列表 = AppFootballTypeM.getModels(json: json["playtypes"])
    }
    
    class func getSingleModel(json:JSON)->AppFootballM{
        let model = AppFootballM()
        if let dic = json.dictionary{
            if let status = dic["status"]?.intValue{if status != 1 {return model }}
            model.getModel(json:dic["result"]!)
        }
        return model
    }
}

// 胜平负 + 大小
class AppFootballTypeM:NSObject{ // playtypes
    var 投注项列表:[AppFootballBetTypeM] = [] // bettypes
    var 玩法名称:String = ""       // name 玩法名称
    var 玩法类型:Int = 0 // playtype (用于组成投注合约报文)
    
    class func getModels(json:JSON) -> [AppFootballTypeM]{
        var array:[AppFootballTypeM] = []
        if let models = json.array {
            for m in models{
                let model = AppFootballTypeM()
                model.getModel(json: m)
                array.append(model)
            }
        }
        return array
    }
    
    func getModel(json:JSON){
        投注项列表 = AppFootballBetTypeM.getModels(json: json["bettypes"])
        if let sep = json["name"].string{ 玩法名称 =  sep }
        if let sep = json["playtype"].int{ 玩法类型 =  sep }
    }
    
}

// 胜 平 负
class AppFootballBetTypeM:NSObject{ // bettypes
    var 投注项赔率:Double = 0 // betodds
    var 投注项:Int = 0       // bettype 用于组成投注合约报文
    var 投注项名称:String = "" // name
    var 投注项支持率:Double = 0 // sprate
    class func getModels(json:JSON) -> [AppFootballBetTypeM]{
        var array:[AppFootballBetTypeM] = []
        if let models = json.array {
            for m in models{
                let model = AppFootballBetTypeM()
                model.getModel(json: m)
                array.append(model)
            }
        }
        return array
    }
    
    func getModel(json:JSON){
        if let sep = json["betodds"].double{ 投注项赔率 =  sep }
        if let sep = json["bettype"].int{ 投注项 =  sep }
        if let sep = json["name"].string{ 投注项名称 =  sep }
        if let sep = json["sprate"].double{ 投注项支持率 =  sep }
    }
}


