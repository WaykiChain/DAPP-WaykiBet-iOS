//
//  BetC.swift
//  Wayki
//
//  Created by louis on 2018/6/26.
//  Copyright © 2018年 wk. All rights reserved.
//

import UIKit

class BetMessage:NSObject{
    var dataIndex:Int = 0 // 选择的数据
    var gameType:Int = 0 //  选择的游戏类型： 胜平负..
    var betType:Int = 0 // 输-平-赢
    var betCount:Int = 0
}


class BetC: UIViewController {
    // 赛事列表数据
    var datas:[AppFootballM] = []
    
    // 用户的投注信息
    private let betMessage = BetMessage()
    
    // 当前数据的页
    var currentPage:Int = 1
    
    // 每页数据的条数
    var pageRows:Int = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }

}


// MARK:-  向服务器请求赛事数据
extension BetC{
    
    func requestData(runHUD:Bool=false){
        let typepath = HTTPPath.足球赛事_G
        let requestpath = httpPath(path: typepath) + "?page=\(currentPage)&rows=\(pageRows)"
        LHRequest.get(url: requestpath,parameters: [:],runHUD: runHUD ? .loading:.none, success: {[weak self] (json) in
            self?.handleData(json: json)
        }) { (error) in }
    }
    
    func handleData(json:JSON){
        datas = AppFootballM.getModels(json: json)
        datas.sort { (s1:AppFootballM, s2:AppFootballM) -> Bool in
            return s1.比赛时间_秒 < s2.比赛时间_秒
        }
        datas.sort { (s1:AppFootballM, s2:AppFootballM) -> Bool in
            return s1.是否热门 > s2.是否热门
        }
    }
}

// MARK:- 投注
extension BetC {
    
    // 用户选择了-(比赛; 类型:篮球、足球; 玩法:胜平负; 投注:胜、负) 投注后输入密码
    func handleBet(index:Int,type:Int,bet:Int,betCount:Int){
        betMessage.betCount = betCount
        betMessage.dataIndex = index
        betMessage.gameType = type
        betMessage.betType = bet
        
        // 用户输入密码解析出助记词
        let password = "用户输入密码"
        let helpS = AccountManager.getAccount().getHelpString(password: password)
        let appID:String = "合约的地址" // http://47.106.77.165:8080/app_apppage.do 可以查询
        let address = AccountManager.getAccount().address
        
        // 获取区块高度
        JsonRpcManager.getBlockHeight(succeed: { [weak self] (height) in
            self?.judgeBet(height: height, address: address, appID: appID, helpString: helpS)
        }) { (str) in
            print(str)
        }
    }
    
    func judgeBet(height:Double,address:String,appID:String,helpString:String){ // 投注请求
        let sinHex = Bridge.getBetSign(withHelp: helpString,
                                       blockHeight: height,
                                       regID: AccountManager.getAccount().regId,
                                       lotteryID: self.datas[betMessage.dataIndex].赛事唯一ID,
                                       destAddress: appID,
                                       gameType: 1,
                                       playType: Int32(datas[betMessage.dataIndex].玩法列表[betMessage.gameType].玩法类型),
                                       betType: Int32(datas[betMessage.dataIndex].玩法列表[betMessage.gameType].投注项列表[betMessage.betType].投注项),
                                       betCount: Int32(betMessage.betCount))
        let dic = Dictionary<String, Any>.register(signHex: sinHex!)
        LHRequest.postJsonRPC(url: nodeURL, parameters: dic, success: {  (json) in
            UILabel.showSucceedHUD(text: "投注成功,等待区块确认！".local)
        }) {s in
            UILabel.showFalureHUD(text: "投注失败".local)
        }
    }
    
    
}
