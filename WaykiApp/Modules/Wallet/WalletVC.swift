//
//  WalletViewController.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/3.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

class WalletVC: BaseViewController {
    var walletMTopView:WalletM_TopView?
    var cardBackView:WalletM_CardView?
    var bottomBackView:WalletM_BottomView?
    let leftspace:CGFloat = scale*16
    
    var isHavedLocalWallet:Bool = false //是否存在本地钱包
    var isBackUp:Bool = true            //是否已备份过
    
    //数据信息
    var coinsInfoModel:BalanceModel = BalanceModel()    //各个币种信息
    var w2uRate:Double = 0                              //wicc 兑换 wusd的汇率
    var u2wRate:Double = 0                              //wusd 兑换 wicc的汇率
    
    let wiccFeeSM:CoinScopeFeeModel = CoinScopeFeeModel()   //wicc手续费范围
    let tokenFeeSM:CoinScopeFeeModel = CoinScopeFeeModel() //wusd手续费范围

    //兑换信息
    var exDetailModel = EXDetailModel()   //兑换详情model（包含兑换种类、数量、手续费、密码）
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        //设置通知
        setNoti()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
        checkLocalWallet()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}



//MARK: - logic
extension WalletVC{
    
    
    //检测本地钱包是否存在，存在则是否显示激活逻辑
    func checkLocalWallet(){
        isHavedLocalWallet = AccountManager.getAccount().checkAccountIsExisted()
        //如果存在，且本地钱包没有regid，则请求相应的regid,
        if isHavedLocalWallet{
            //如果本地没有regid，则请求
            if AccountManager.getAccount().regId.count<1{
                //如果钱包没有激活，则界面显示激活按钮
                WalletCommonRequestManager.getRegIdAndBlock { (isActivate) in
                    self.walletMTopView?.changeActiveStatus(isActivate: isActivate)
                }
            }else if AccountManager.getAccount().regId == " "{
                //已激活，但是regid还未生成,则再次请求
                WalletCommonRequestManager.getRegId()
            }else{
                //如果本地激活，则
                self.walletMTopView?.changeActiveStatus(isActivate: true)
            }
 
        }else{
            //如果本地钱包不存在，则该页面所有按钮，点击都要提示导入或激活
            //点击按钮时，根据isHavedLocalWallet 状态  有不同逻辑
        }
    }

    //激活成功的通知
    private func setNoti(){
        //激活成功
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("Noti_activiteSuccess"), object: nil, queue: OperationQueue.main) { (noti) in
            self.walletMTopView?.changeActiveStatus(isActivate: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 30, execute: {
                //更改激活按钮状态
                WalletCommonRequestManager.getRegId()
            })
        }
    }
}

//MARK: - data
extension WalletVC{
    func refreshData(){
        requestRate();
        requestFeeScope()
        requestAccountInfo()
    }
    
    private func requestRate(){
        //汇率
        WalletProvider.requestRate { (w2u, u2w) in
            //保留4位小数，不四舍五入
            self.w2uRate = Double(Int(10000*w2u))/10000
            self.u2wRate = Double(Int(10000*u2w))/10000
            self.setUIWithCarData()
        }
    }
    
    private func requestAccountInfo(){
        //账户信息
        WalletProvider.requestAccountInfo { (model) in
            self.coinsInfoModel = model
            let account = AccountManager.getAccount()
            account.wiccSumAmount = model.wiccModel.balanceAvailable
            account.tokenSumAmount = model.tokenModel.balanceAvailable
            
            AccountManager.saveAccount(account: account)
            self.setUIWithBalance()
        }
    }
    
    private func requestFeeScope(){
        //手续费范围
        //wicc兑换wusd（需签名）手续费范围固定
        //wicc要加一个随机的最大值（0～99的随机数/10^8）,避免失败
        self.wiccFeeSM.min = 0.001
        self.wiccFeeSM.reserved = 0.00001
        self.wiccFeeSM.max = 0.05
        self.setUIWithFeeScope()
        
        //wusd兑换wicc的手续费,此版本默认为0

        self.tokenFeeSM.min = 0
        self.tokenFeeSM.max = 0
        self.setUIWithFeeScope()

    }
    
}

//MARK: - SETUI
extension WalletVC{
    
    //设置显示的余额和地址
    private func setUIWithBalance(){
        walletMTopView?.setAddress(address: coinsInfoModel.wiccModel.address)
        
        bottomBackView?.wiccLabel.text = String.init(format: "%.8f", (AccountManager.getAccount().wiccSumAmount)).removeEndZeros()
        bottomBackView?.rmbLabel.text = "≈  " + String.init(format: "%.2f", (coinsInfoModel.wiccModel.priceCNY)) + "(CNY)"
        bottomBackView?.wkdLabel.text = String.init(format: "%.8f", (AccountManager.getAccount().tokenSumAmount)).removeEndZeros()
        bottomBackView?.wkdNameLabel.text = CoinType.token.rawValue
        bottomBackView?.tokenRMBLabel.text = "=  " + String.init(format: "%.2f", (coinsInfoModel.tokenModel.priceCNY)) + "(CNY)"

        bottomBackView?.lockLabel.text = "\(AccountManager.getAccount().wiccFSumAmount)".removeEndZeros()
        cardBackView?.setNewData(coinToTokenRate: self.w2uRate, tokenToCoinRate: self.u2wRate, coinMinFee: wiccFeeSM.min, tokenMinFee: tokenFeeSM.min,reservedCoin: wiccFeeSM.reserved)
    }
    
    //设置卡片使用的手续费范围
    private func setUIWithFeeScope(){
        cardBackView?.setNewData(coinToTokenRate: self.w2uRate, tokenToCoinRate: self.u2wRate, coinMinFee: wiccFeeSM.min + wiccFeeSM.reserved, tokenMinFee: tokenFeeSM.min,reservedCoin: wiccFeeSM.reserved)
    }
    
    //设置兑换卡片的数据
    private func setUIWithCarData(){
        cardBackView?.setNewData(coinToTokenRate: self.w2uRate, tokenToCoinRate: self.u2wRate, coinMinFee: wiccFeeSM.min + wiccFeeSM.reserved, tokenMinFee: tokenFeeSM.min,reservedCoin: wiccFeeSM.reserved)
        if cardBackView?.exModel.expendCoin == CoinType.wicc {
            walletMTopView?.rateLabel.text = "1 \(CoinType.wicc.rawValue) = "+"\(self.w2uRate)".removeEndZeros()+" "+CoinType.token.rawValue
        }else{
            walletMTopView?.rateLabel.text = "1 \(CoinType.token.rawValue) = "+"\(self.u2wRate)".removeEndZeros()+" "+CoinType.wicc.rawValue
        }
    }
    
    //设置显示的汇率
    private func setShowRate(isW2U:Bool){
        if isW2U {
            walletMTopView?.rateLabel.text = "1 \(CoinType.wicc.rawValue) = "+"\(self.w2uRate)".removeEndZeros()+" "+CoinType.token.rawValue
        }else{
            walletMTopView?.rateLabel.text = "1 \(CoinType.token.rawValue) = "+"\(self.u2wRate)".removeEndZeros()+" "+CoinType.wicc.rawValue
        }
    }
}

//MARK: - Action
extension WalletVC{
    //点击、并且检测
    func clickAndCheck() ->Bool{
        if isHavedLocalWallet == false{
            //如果本地不存在钱包,则弹出需要导入、或创建的弹框
            _ = CommonAlertView.alertAgainCreateOrImport()
            return false
        }else if OnceBackupManager.checkIfBackup() == false{
            //如果创建钱包后没有第一次备份,则出现备份弹框
            return false
        }else{
            return true
        }
    }
    
    
    
    //点击兑换按钮,弹出手续费界面
    func clickExchange(exModel:ExchangeModel){
        if clickAndCheck() == false{
            return
        }
        if ActiviteManager.checkIsActivityAndActivity(vc: self) == false{
            //如果没有激活，则提示先激活
            return
        }
        
        if exModel.expendCoin == CoinType.wicc{
            if exModel.expendAmount<limitEXMinWiccAmount{
                UILabel.showFalureHUD(text: "每次最少兑换 0.01 WICC".local)
                return
            }else if exModel.expendAmount>limitEXMaxWiccAmount{
                UILabel.showFalureHUD(text: "测试版每次只能兑换 1 WICC".local)
                return
            }
        }
       

        let model = EXDetailModel()
        model.leftName = exModel.expendCoin.rawValue
        model.leftN = exModel.expendAmount
        model.rightName = exModel.getCoin.rawValue
        model.rightN = exModel.getAmount
        model.rate = exModel.rate
 
        model.leftMaxAmount = exModel.maxAmount
        if exModel.expendCoin == CoinType.wicc {
            model.leftBalance = AccountManager.getAccount().wiccSumAmount
            model.gasMin = wiccFeeSM.min
            model.gasMax = wiccFeeSM.max
            model.reserved = wiccFeeSM.reserved
        }else{
            model.leftBalance = AccountManager.getAccount().tokenSumAmount
            model.gasMin = tokenFeeSM.min
            model.gasMax = tokenFeeSM.max
        }
        if model.leftName == CoinType.wicc.rawValue && model.rightName ==  CoinType.token.rawValue{
            model.isNeedTF = true
        }
        self.alertExchangeView(detailModel: model)
    }
    
    //开始兑换
    func startEXchange(exDetailModel:EXDetailModel){
        if clickAndCheck() == false{
            return
        }
    
        
        if exDetailModel.leftName == CoinType.wicc.rawValue&&exDetailModel.rightName == CoinType.token.rawValue {
            ExchangeManager.startWICCToWUSD(exDetailModel: exDetailModel) { (isSuccess) in
                if isSuccess{
                    self.alertLookRecord()
                    self.exDetailModel = exDetailModel
                    self.cardBackView?.reset()
                }
            }
        }else if exDetailModel.leftName == CoinType.token.rawValue&&exDetailModel.rightName == CoinType.wicc.rawValue{
            ExchangeManager.startWUSDToWICC(exDetailModel: exDetailModel) { (isSuccess) in
                if isSuccess{
                    self.alertLookRecord()
                    self.exDetailModel = exDetailModel
                    self.cardBackView?.reset()
                }
            }
        }


    }
    
    //跳转至管理钱包界面
    @objc func jumpToManageWalletVC(){
        if clickAndCheck() == false{
            return
        }
        let c = ManageWalletVC()
        c.hidesBottomBarWhenPushed = true;
        navigationController?.pushViewController(c, animated: true)
    }
    
    //跳转至扫一扫
    @objc func jumpScanVC(){
        if clickAndCheck() == false{
            return
        }
        TransferProvider.isRightCamera {
            RequestHandler.showHUD()
            let scanner =  HMScannerController.scanner(withCardName: "", avatar: UIImage.init(named: "avatar"), completion: {
                
                [weak self] (stringValue:String?) in
                if stringValue != nil{
                    let c = TransferVC()
                    c.scanAddress = stringValue!
                    c.hidesBottomBarWhenPushed = true;
                    self?.navigationController?.pushViewController(c, animated: true)
                }else{
                    UILabel.showFalureHUD(text: "无法扫描到二维码，请重试".local)
                }
                
            })
            scanner?.setTitleColor(UIColor.white, tintColor:UIColor.red)
            self.present(scanner!, animated: true, completion: {
                RequestHandler.dismissHUD()
            })
        }
    }
    
    //跳转至二维码
    @objc func jumpToCodeVC(){
        if clickAndCheck() == false{
            return
        }
        let c = QRCodeViewController()
        c.hidesBottomBarWhenPushed = true;
        navigationController?.pushViewController(c, animated: true)
        
    }
    
    //复制地址到粘贴板
    @objc func copyAddress(){
        if clickAndCheck() == false{
            return
        }
        //        alertExchangeView()
        UIPasteboard.general.string = AccountManager.getAccount().address
        
        UILabel.showSucceedHUD(text:  "地址已复制！".local )
    }
    
    //跳转至获取wicc页面
    @objc func jumpGetWicc(){
        if clickAndCheck() == false{
            return
        }
        WalletProvider.getWiccLink { (linkStr) in
            if URL(string: linkStr) != nil{
                let c = ItemsWebController()
                c.url = linkStr
                c.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(c, animated: true)
            }else{
                
            }
        }
        
    }
    
    //点击激活按钮
    @objc func clickActive(){
        if clickAndCheck() == false{
            return
        }
//        walletMTopView?.activeBtn.isEnabled = false
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+60) {
//            self.walletMTopView?.activeBtn.isEnabled = true
//        }
        ActiviteManager.checkIsActivityAndActivity(vc: self,isNeedPromptAlert: false)
    }
    
    //点击wicc
    @objc func clickWicc(){
        if clickAndCheck() == false{
            return
        }
        let next = TransferReocrdVC()
        next.coinSymbol = CoinType.wicc
        next.balanceModel = coinsInfoModel
        next.wordsArr = ["全部".local,"转账".local,"兑换".local,"激活".local]
        next.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    
    
    //点击Token
    @objc func clickToken(){
        if clickAndCheck() == false{
            return
        }
        let next = TransferReocrdVC()
        next.coinSymbol = CoinType.token
        next.balanceModel = coinsInfoModel
        next.wordsArr = ["全部".local,"投注".local,"开庄".local,"兑换".local,"系统奖励".local]
        next.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    //前往兑换记录页面
    @objc func jumpToEXRecord(){
        if clickAndCheck() == false{
            return
        }
        let c = ExchangeRecordVC()
        c.hidesBottomBarWhenPushed = true;
        navigationController?.pushViewController(c, animated: true)
    }
    
    
}

//MARK: - UI
extension WalletVC{
    private func layoutUI(){
        header?.isHidden = true
        createTop()
        createCardView()
        createBottomView()
    }
    
    //更多、扫一扫、二维码、复制、汇率
    private func createTop(){
        let btnY:CGFloat
        if UIDevice.isX(){
            btnY = 40
        }else{
            btnY = 24
        }
        let viewHeight:CGFloat = btnY + scale*36 + scale*32 + 15  + scale*35 + scale*22 + scale*38 + 14
        walletMTopView = WalletM_TopView(frame: CGRect(x: 0, y: 0, width: view.width(), height: viewHeight))
        setShowRate(isW2U: true)

        view.addSubview(walletMTopView!)
        walletMTopView?.clickBlock = {[weak self] (tag) in
            switch tag {
            case 1:
                self?.jumpToManageWalletVC()
            case 2:
                self?.jumpToCodeVC()
            case 3:
                self?.jumpScanVC()
            case 4:
                self?.copyAddress()
            case 5:
                self?.jumpGetWicc()
            case 6:
                self?.clickActive()
            default:
                break
            }
        }
        
    }
    
    //创建中间卡片区域
    private func createCardView(){

        cardBackView = WalletM_CardView(frame: CGRect(x: leftspace, y: (walletMTopView?.bottom())!+scale*10, width: view.width()-2*leftspace, height: scale*187), coinToTokenRate: 1, tokenToCoinRate: 0,coinMinFee:0,tokenMinFee:0)
        cardBackView?.exchangeBlock = {[weak self](exModel) in
            self?.clickExchange(exModel: exModel)
        }
        cardBackView?.clickRecordBlock = {[weak self]() in
            self?.jumpToEXRecord()
        }
        cardBackView?.turnOverBlock = {[weak self](isW2u) in
            self?.setShowRate(isW2U: isW2u)
        }
        view.addSubview(cardBackView!)
        
    }
    
    //wicc余额、wkd、锁仓等
    private func createBottomView(){
        bottomBackView = WalletM_BottomView(frame: CGRect(x: leftspace+scale*2, y: (cardBackView?.bottom())! + scale*20, width: view.width()-2*leftspace-scale*4, height: scale*120))

        bottomBackView?.clickBlock = {[weak self](tag) in
            switch tag {
            case 1:
                self?.clickWicc()
            case 3:
                self?.clickToken()
            default:
                break
            }
        }
        
        
        view.addSubview(bottomBackView!)
    }
}




//MARK: - Alert
extension WalletVC{
    //弹出兑换确定页面
    func alertExchangeView(detailModel:EXDetailModel){

        let v = WalletEXAlertView(exModel:detailModel,frame:self.view.bounds)
        v.confirmBlock = { [weak self](exModel) in
            self?.startEXchange(exDetailModel: exModel)
        }
        v.showAlert()
    }
    
    //弹出兑换提示页面
    func alertLookRecord(){
        let v1 = WalletPromptAlertView(title: "兑换中，请稍后".local, btnTitle: "查看兑换记录".local,isHavedCancel : true,isBold:true, frame: self.view.bounds)
        v1.clickBlock = { () in
            self.jumpToEXRecord()
        }
        v1.showAlert()
    }
    
}

