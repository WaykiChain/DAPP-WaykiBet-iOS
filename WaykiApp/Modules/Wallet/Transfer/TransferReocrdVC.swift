//
//  TransferReocrdVC
//  WaykiApp
//
//  Created by sorath on 2018/9/6.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

class TransferReocrdVC: BaseViewController {
    public var wordsArr : [String] = []
    public var balanceModel : BalanceModel = BalanceModel()
    public var coinSymbol:CoinType = CoinType.wicc

    fileprivate var models:[TransferRecordModel] = []
    fileprivate lazy var tropMenu = ZHDropDownMenu()
    fileprivate var selectedkinds: Int = 0
    
    fileprivate let table = WaykiRecordTableView.init()

    fileprivate let totleCoinLabel = UILabel()
    fileprivate let totleMoneyLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        getDatas()
    }
    
    override func back() {
        if navigationController != nil {
            let vcs = navigationController?.viewControllers
            if (vcs?.count)!>1{
                //如果栈的下一层是二维码界面，则返回至第一个二维码界面
                let c = vcs![(vcs?.count)!-2]
                if c is QRCodeViewController{
                    var pVC = c
                    for vc in vcs!{
                        if vc is QRCodeViewController{
                            pVC = vc
                            break
                        }
                    }
                    navigationController?.popToViewController(pVC, animated: true)
                    return
                }
            }
        }
        super.back()
    }

    //获取数据
    func getDatas(){
        //记录
        TransferRecordManager.getDataModels(curPage: curPage, type: selectedkinds, coinSymbol: coinSymbol.rawValue, models: { (models,selectedkinds) in
            let isRefresh = self.curPage==1 ? true : false
            if isRefresh{
                self.models = models
            }else{
                self.models = self.models + models
            }
            self.endRefreshHearerAndFooter(isRefresh: isRefresh, addDataArrCount: models.count)
            self.table.reloadData()
        })
        
        //余额
        WalletProvider.requestAccountInfo { (model) in
            self.balanceModel = model
            self.refreshAccount()
        }
    }
    
    //结束刷新操作
    func endRefreshHearerAndFooter(isRefresh:Bool,addDataArrCount:Int){
            table.mj_header.endRefreshing()
            table.mj_footer.endRefreshing()
        if addDataArrCount%10 == 0 && addDataArrCount != 0{
            //可能还有信息,则显示刷新尾部
            table.mj_footer.isHidden = false
        }else{
            //不会有新的信息，不再允许下拉加载
           table.mj_footer.isHidden = true
        }
    }
    
}

//MARK: - UI
extension TransferReocrdVC{
    private func layoutUI(){
        
        titleLabel?.text = coinSymbol.rawValue
        view.backgroundColor = UIColor.bgColor()
        totleCoinLabel.frame = CGRect(x: 0, y: (header?.bottom())! + scale*22, width:UIScreen.width(), height: scale*22)
        totleCoinLabel.font = UIFont.boldSystemFont(ofSize: 22)
        totleCoinLabel.textColor = UIColor.RGBHex(0xDEE7FF)
        totleCoinLabel.textAlignment = .center
        view.addSubview(totleCoinLabel)
        
        totleMoneyLabel.frame =  CGRect(x: 0, y: totleCoinLabel.bottom()+scale*4, width:UIScreen.width(), height: scale*14)
        totleMoneyLabel.font = UIFont.systemFont(ofSize: 12)
        totleMoneyLabel.textColor = UIColor.RGBHex(0x66749C)
        totleMoneyLabel.textAlignment = .center
        if (coinSymbol == CoinType.wicc){
            view.addSubview(totleMoneyLabel)
        }
        refreshAccount()
        
        let headToolBar = UIView.init(frame:CGRect(x: 0, y: totleMoneyLabel.bottom()+scale*20, width: UIScreen.width(), height: 30))
        view.addSubview(headToolBar)
        
        let textLabel = UILabel.init(frame: CGRect(x: 20, y: 0, width: 120, height: headToolBar.height()))
        textLabel.text = "最近交易记录".local
        textLabel.font = UIFont.systemFont(ofSize: 12)
        textLabel.textColor = UIColor.RGBHex(0x66749C)
        headToolBar.addSubview(textLabel)
        
        
        var tableHeight = UIScreen.height()-headToolBar.bottom()-64
        if coinSymbol == CoinType.wicc{
            let bottomBar = UIView.init(frame: CGRect(x: 0, y: UIScreen.height()-65, width: UIScreen.width(), height: 65))
            bottomBar.backgroundColor = UIColor.clear
            
            let incomMoneyBtn = UIButton.init(frame: CGRect(x: 20, y: 0, width: UIScreen.width()/2-25, height: 45))
            incomMoneyBtn.backgroundColor = UIColor.white
            incomMoneyBtn.setTitle("收款".local, for: .normal)
            incomMoneyBtn.setImage(UIImage(named: "btn_shoukuan"), for: .normal)
            incomMoneyBtn.setIconInRight()
            incomMoneyBtn.setTitleColor(UIColor.RGBHex(0x2C84FF), for: .normal)
            incomMoneyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            incomMoneyBtn.layer.cornerRadius = 5
            incomMoneyBtn.addTarget(self, action: #selector(jumpToQrCode), for: .touchUpInside)
            bottomBar.addSubview(incomMoneyBtn)
            
            let outMoneyBtn = UIButton.init(frame: CGRect(x: UIScreen.width()/2+5, y: 0, width: UIScreen.width()/2-25, height: 45))
            outMoneyBtn.backgroundColor = UIColor.RGBHex(0x2E86FF)
            outMoneyBtn.setTitle("转账".local, for: .normal)
            outMoneyBtn.setImage(UIImage(named: "btn_turn"), for: .normal)
            outMoneyBtn.setIconInRight()
            outMoneyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            outMoneyBtn.layer.cornerRadius = 5
            outMoneyBtn.addTarget(self, action: #selector(jumpToTransfer), for: .touchUpInside)
            bottomBar.addSubview(outMoneyBtn)
            view.addSubview(bottomBar)
        }else{
            tableHeight = UIScreen.height()-headToolBar.bottom()
        }
        
        table.frame = CGRect(x: 0, y: headToolBar.bottom(), width: UIScreen.width(), height: tableHeight)
        table.backgroundColor = .clear
        table.register(TS_RecordCell.self, forCellReuseIdentifier: "tscell")
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        view.insertSubview(table, belowSubview: headToolBar)
        addRefreshHeaderAndFooter()
        
        tropMenu.frame = CGRect(x: UIScreen.width()-130, y: headToolBar.top(), width: 120, height: 30)
        tropMenu.options = wordsArr
        tropMenu.defaultValue = wordsArr.first
        tropMenu.textColor = UIColor.amountColor()
        tropMenu.backgroundColor = UIColor.clear
        tropMenu.showBorder = false
        tropMenu.delegate = self
        tropMenu.rowHeight = 40
        tropMenu.contentTextField.font = UIFont.systemFont(ofSize: 12)
        view.addSubview(tropMenu)
        
    }
    
    private func addRefreshHeaderAndFooter(){
        let refreshHeader = MJRefreshNormalHeader.init {[weak self] in
            self?.curPage = 1
            self?.getDatas()
        }
        table.mj_header = refreshHeader
        
        let refreshFotter = MJRefreshAutoNormalFooter.init {[weak self] in
            self?.curPage = (self?.curPage)! + 1
            self?.getDatas()
        }
        
        table.mj_footer = refreshFotter
        table.mj_footer.isHidden = true
    }
    
    //刷新账户（头部信息）
    private func refreshAccount(){
        var balanceAmount:Double = 0
        var balancePrice:String = ""
        if coinSymbol == CoinType.wicc{
            balanceAmount = balanceModel.wiccModel.balanceAvailable
            balancePrice = String.init(format: "%.2f", balanceAmount*balanceModel.wiccModel.priceCNY)
        }else{
            balanceAmount = balanceModel.tokenModel.balanceAvailable
        }
        titleLabel?.text = coinSymbol.rawValue
        totleCoinLabel.text = "\(balanceAmount)".removeEndZeros()
        totleMoneyLabel.text = "≈ \(balancePrice)(CNY)"
    }
}


//MARK: - action
extension TransferReocrdVC{
    @objc func jumpToQrCode(){
        let c = QRCodeViewController()
        navigationController?.pushViewController(c, animated: true)
    }
    
    @objc func jumpToTransfer(){
        let c = TransferVC()
        navigationController?.pushViewController(c, animated: true)
    }
}
//MARK: - ZHDropDownMenuDelegate
extension TransferReocrdVC:ZHDropDownMenuDelegate{
    func dropDownMenu(_ menu: ZHDropDownMenu, didEdit text: String) {
        
    }
    
    func dropDownMenu(_ menu: ZHDropDownMenu, didSelect index: Int) {
        menu.contentTextField.text = wordsArr[index]
        if selectedkinds != index{
            selectedkinds = index
            curPage = 1//切换时，页码归1
            models.removeAll()
            getDatas()
        }
    }
    
    func openOrClose(_ isopen: Bool) {
        if isopen{
            UIView.animate(withDuration: 0.3, animations: {
                self.tropMenu.cover.alpha = 0.8
            }) { (finish) in
                self.view.insertSubview(self.tropMenu.cover, belowSubview: self.tropMenu)
            }

        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.tropMenu.cover.alpha = 0
            }) { (finish) in
                self.tropMenu.cover.removeFromSuperview()
            }

        }

    }
    
}

//MARK: - UITableViewDelegate,UITableViewDataSource
extension TransferReocrdVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TS_RecordCell.getCell(table: tableView)
        if indexPath.row <= models.count{
            let model = models[indexPath.row]
            cell.setData(model: model)
        }

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = models[indexPath.row]
        TransferRecordManager.alertDetailView(m: model)
    }
}
////cell
class TS_RecordCell: UITableViewCell {
    
    var stateImg = UIImageView()
    var typeTitle = UILabel()
    var dealNum = UILabel()
    var time = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupview()
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func getCell(table:UITableView,id:String="TS_RecordCell")->TS_RecordCell{
        var cell = table.dequeueReusableCell(withIdentifier: id)
        if cell == nil{ cell = TS_RecordCell() }
        return cell as! TS_RecordCell
    }
    func setupview(){
        self.backgroundColor = UIColor.clear
        stateImg.frame = CGRect(x: 20, y: 15, width: 33, height: 33)
        stateImg.layer.cornerRadius = 15.5
        addSubview(stateImg)
        
        typeTitle.frame = CGRect(x: stateImg.right()+8, y: 20, width: 100, height: 21)
        typeTitle.textColor = UIColor.amountColor()
        typeTitle.font = UIFont.systemFont(ofSize: 15)
        addSubview(typeTitle)
        
        dealNum.frame = CGRect(x: UIScreen.width()/2, y: 15, width: UIScreen.width()/2-20, height: 15)
        dealNum.textColor = UIColor.RGBHex(0x37C98F)
        dealNum.font = UIFont.systemFont(ofSize: 13)
        dealNum.textAlignment = .right
        addSubview(dealNum)
        
        time.frame = CGRect(x: UIScreen.width()/2, y: dealNum.bottom()+2, width: UIScreen.width()/2-20, height: 15)
        time.textColor = UIColor.RGBHex(0x66749C)
        time.font = UIFont.systemFont(ofSize: 10)
        time.textAlignment = .right
        addSubview(time)
        
        let line = UIView.init(frame:CGRect(x: 20, y: 60.5, width: UIScreen.width()-40, height: 0.5))
        line.backgroundColor = UIColor.RGBHex(0x323F64)
        addSubview(line)
    }
    
    
    func setData(model:TransferRecordModel){
        var imageStr = ""
        if model.amount < 0{
            imageStr = "record_reduce"
        }else{
            imageStr = "record_increase_success"
        }
        stateImg.image = UIImage(named: imageStr)
        typeTitle.text = TransferRecordModel.getChineseType(type: model.type)
        let amount = Double(Int(100000000*model.amount))/100000000
        let dealNumStr = "\(amount)".removeEndZeros() + " " + model.coinSymbol
        if model.amount>0{
            dealNum.textColor = UIColor.RGBHex(0x37C98F)
            dealNum.text = "+" + dealNumStr
        }else{
            dealNum.textColor = UIColor.amountColor()
            dealNum.text = dealNumStr
        }
        
        if model.confirmTime == ""{
            time.text = "确认中".local
        }else{
            time.text = model.confirmTime
        }
        
        if model.status == 880{
            time.text = model.confirmTime
        }else if model.status == 900{
            time.text = model.confirmTime
        }else{
            //<880
            time.text = "确认中".local
        }
        
    }
}
