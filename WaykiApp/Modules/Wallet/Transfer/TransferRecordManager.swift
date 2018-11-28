//
//  TransferRecordManager.swift
//  WaykiApp
//
//  Created by lcl on 2018/9/7.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit


class TransferRecordManager: NSObject {
    
    class func getDataModels(curPage:Int, type:Int,coinSymbol:String, models:@escaping(_ m:[TransferRecordModel],_ selectedKind:Int)->Void){
        let typeNum = getTypeNum(selectedKind: type, coinSymbol: coinSymbol)
        
        let path = httpPath(path: .获取交易记录_P)
        var para = ["pageNumber": curPage,
                    "pageSize": 10,
                    "walletAddress": AccountManager.getAccount().address,
                    "coinSymbol":coinSymbol
            ] as [String : Any]
        para["type"] = typeNum
        let jsonD = String.getJSONStringFromDictionary(dictionary: para as NSDictionary)
        RequestHandler.post(url: path, parameters: para, runHUD: HUDStyle.loading, isNeedToken: true, success: { (json) in
            if let dic = JSON(json).dictionary{
                if let dataArr = dic["data"]?.arrayValue{
                    var dataModeds:[TransferRecordModel] = []
                    for i in 0..<dataArr.count{
                        if let dic = dataArr[i].dictionaryObject{
                            let model = TransferRecordModel.init(dic)
                            dataModeds.append(model)
                        }
                    }
                    models(dataModeds,type)
                }
            }
        }) { (error) in
            UILabel.showFalureHUD(text: error)
        }
        
    }
    
}

//MARK: - Detail
extension TransferRecordManager{
    ////详情
    
    class func alertDetailView(m:TransferRecordModel){
            getDealDetaiData(id: "\(m.id)")
    }
    fileprivate class func setupAlertView(model:TransferRecordDetailModel){
        let bgView = UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.width(), height: UIScreen.height()))
        bgView.backgroundColor = UIColor.RGBHex(0x000000, alpha: 0.0)
        
        let touchBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: UIScreen.width(), height: UIScreen.height()))
        bgView.addSubview(touchBtn)
        touchBtn.addTarget(self, action: #selector(clickClose(btn:)), for:.touchUpInside)
        bgView.addSubview(touchBtn)
        

        let w = bgView.width()-48
        
        let imgHeight = 1.47 * w
        let imgY = (UIScreen.height() - imgHeight)/2
        let bgimg = UIImageView.init(frame: CGRect(x: 24, y: imgY, width:w , height: 1.47 * w))
        bgimg.image = UIImage(named: "re_detail_bv")
        bgView.addSubview(bgimg)
        
        let closeBtn = UIButton.init(frame: CGRect(x: bgView.width()-48, y: imgY-24-24, width: 24, height: 24))
        closeBtn.setImage(UIImage.init(named: "detail_close"), for: .normal)
        bgView.addSubview(closeBtn)
        closeBtn.addTarget(self, action: #selector(clickClose(btn:)), for:.touchUpInside)
        
        
        let statusImgW = w*0.152
        let statusImg = UIImageView.init(frame: CGRect(x: w/2-statusImgW/2 + 24, y: bgimg.top()-statusImgW/2, width: statusImgW, height: statusImgW))
        statusImg.layer.cornerRadius = statusImgW/2
        bgView.addSubview(statusImg)
        var statusImage:UIImage
        if model.status == 200{
            statusImage = UIImage(named: "detail_fail")!
        }else{
            statusImage = UIImage(named: "detail_success")!
        }
        statusImg.image  = statusImage
        
        let totleCoin = UILabel.init(frame: CGRect(x: 0, y:bgimg.height() * 41/482, width:w, height: 28))
        totleCoin.font = UIFont.boldSystemFont(ofSize: 20)
        totleCoin.textColor = UIColor.RGBHex(0x15263E)
        totleCoin.textAlignment = .center
        bgimg.addSubview(totleCoin)
        var showAmountStr = ""
        if model.amount>0{
            showAmountStr = "+" + "\(model.amount)".removeEndZeros() + model.coinSymbol
        }else{
            showAmountStr = "\(model.amount)".removeEndZeros() + model.coinSymbol
        }
        totleCoin.text = showAmountStr
        
        let statusText = UILabel.init(frame: CGRect(x: 0, y: totleCoin.bottom(), width:w, height: 17))
        statusText.font = UIFont.systemFont(ofSize: 12)
        statusText.textColor = UIColor.RGBHex(0xB3B9C4)
        statusText.textAlignment = .center
        bgimg.addSubview(statusText)
        var statusStr = ""
        if model.status == 880{
            statusStr = "交易成功".local
        }else if model.status == 900{
            statusStr = "交易失败".local
        }else{
            //<880
            statusStr = "确认中".local
        }   
        statusText.text = statusStr
        
        bgimg.isUserInteractionEnabled = true
        
        let contentV = UIScrollView.init(frame: CGRect(x: 0, y: statusText.bottom()+16, width: w, height: bgimg.height() - statusImg.bottom() - 8))
        contentV.contentSize = CGSize(width: w, height: 392)
        bgimg.addSubview(contentV)
        
        bgView.layer.transform = CATransform3DMakeScale(0.3, 0.3, 1.0)
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            bgView.backgroundColor = UIColor.RGBHex(0x000000, alpha: 0.3)
            bgView.layer.opacity = 1
            bgView.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
        }, completion: nil)
        UIApplication.shared.keyWindow?.addSubview(bgView)
        
        
        let arrTitle = ["发款方".local,"收款方".local,"矿工费用".local,"交易哈希".local,"备注".local,"交易类型".local,"交易时间".local]
        let detailArr = [model.sendAddress,model.receiveAddress,"\(model.minnerFee)".removeEndZeros(),model.txHash,model.comments,TransferRecordModel.getChineseType(type: model.type),model.txTime]
        var arrContent : [UILabel] = []
        var x : CGFloat = 20
        var width = w-40
        var index = -1
        var detailHeight:CGFloat = 0
        for var i in 0..<7{
            index+=1
            if i == 6{
                i = 5
                x = w/2+10
                width = width/2 - 20
            }
            var y:CGFloat = 0
            let height:CGFloat = 18
            if i>=1{
                let qianLabel = arrContent[i-1]
                y = (qianLabel.bottom()) + 20
            }
            let fakuan = UILabel.init(frame: CGRect(x: x, y:y, width:width, height: height))
            fakuan.text = arrTitle[index]
            fakuan.font = UIFont.boldSystemFont(ofSize: 13)
            fakuan.textColor = UIColor.RGBHex(0x536177)
            contentV.addSubview(fakuan)
            
            let address1 = UILabel.init(frame: CGRect(x: x, y: fakuan.bottom() + 6, width:width, height: fakuan.height()))
            address1.text = detailArr[index]
            address1.font = UIFont.systemFont(ofSize: 12)
            address1.textColor = UIColor.RGBHex(0xB3B9C4)
            address1.numberOfLines = 0
            if fakuan.text == "交易哈希".local{
                address1.sizeToFit()
            }
            contentV.addSubview(address1)
            arrContent.append(address1)
        }
        let v7 = arrContent[arrTitle.count-1]
        detailHeight = v7.bottom()
        contentV.contentSize = CGSize(width: w, height: detailHeight)
        
        
    }
    fileprivate class func getDealDetaiData(id:String){
        let path = httpPath(path: .获取交易详情_G) + "/" + id
        RequestHandler.get(url: path, parameters: [:], runHUD: .loading, isNeedToken: true, success: { (json) in
            if let dic = JSON(json).dictionary{
                if let dataDic = dic["data"]?.dictionaryObject{
                    let model = TransferRecordDetailModel.init(dataDic)
                    setupAlertView(model: model)
                    return
                }
            }

        }) { (error) in
            UILabel.showFalureHUD(text: error)
        }

    }
    @objc class func clickClose(btn:UIButton){
        let v = btn.superview!
        v.layer.opacity = 1.0
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            v.backgroundColor = UIColor.RGBDecColor(r: 0, g: 0, b: 0, alpha: 0)
            v.layer.opacity = 0
            v.layer.transform = CATransform3DMakeScale(0.6, 0.6, 1.0)
        }) { (isSuccess) in
            for vi in v.subviews{
                vi.removeFromSuperview()
            }
            v.removeFromSuperview()
        }
    }
}


extension TransferRecordManager{
    //根据币种类型和选项，转化为typeNum
    private class func getTypeNum(selectedKind:Int,coinSymbol:String) ->[Int]?{
        var typeNum:[Int]? = nil
        //type (integer, optional): 交易类型：110:转账+- | 120: 兑换+-| 130: 锁仓| 140:-激活 | 180:合约修改汇率(修改汇率)| 210:投注-| 220:开庄-/ 300:投注派奖-/ 310:开庄派奖-/ 600:系统奖励
        if coinSymbol == CoinType.wicc.rawValue {
            //        next.wordsArr = ["全部".local,"转账".local,"兑换".local,"激活".local]
            switch (selectedKind){
            case 0:
                typeNum = [110,120,140]
                break
            case 1:
                typeNum = [110]
                break
            case 2:
                typeNum = [120]
                break
            case 3:
                typeNum = [140]
                break
            default:
                break
            }
        }else if coinSymbol == CoinType.token.rawValue{
            //        next.wordsArr = ["全部".local,"投注".local,"开庄".local,"兑换".local,"系统奖励".local]
            switch (selectedKind){
            case 0:
                typeNum = [210,220,120,600,300,310]
                break
            case 1:
                typeNum = [210,300]
                break
            case 2:
                typeNum = [220,310]
                break
            case 3:
                typeNum = [120]
                break
            case 4:
                typeNum = [600]
                break
            default:
                break
            }
        }
        return typeNum
    }
}
