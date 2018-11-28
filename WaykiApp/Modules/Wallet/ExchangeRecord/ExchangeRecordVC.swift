//
//  ExchangeRecordVC.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/5.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

class ExchangeRecordVC: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    let rowHeight:CGFloat = scale * 61 + 85
    let csPhone:String = "WaykichainHelen"
    var bottomView:UIView?
    var tableView:WaykiRecordTableView?
    var dataArray:[EX_RecordModel] = []
    let pageSize = 10//每页的读取数量
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutUI()
        getData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

//MARK: - DataSource/logic
extension ExchangeRecordVC{
    @objc func getData(){
        let path = httpPath(path: .获取兑换记录_P)
        let para = ["pageNumber": curPage,
                    "pageSize": pageSize,
                    "walletAddress": AccountManager.getAccount().address
            ] as [String : Any]
        let isRefresh = self.curPage==1 ? true : false
        RequestHandler.showHUD()
        RequestHandler.post(url: path, parameters: para, success: { (json) in
            RequestHandler.dismissHUD()
            if let dic = JSON(json).dictionary{
                if let dataArr = dic["data"]?.arrayValue{
                        let dataArr = EX_RecordModel.getModels(arr: dataArr)
                        if isRefresh{
                            self.dataArray = dataArr
                        }else{
                            self.dataArray = self.dataArray + dataArr
                        }
                        self.endRefreshHearerAndFooter(isRefresh: isRefresh, addDataArrCount: dataArr.count)
                        self.tableView?.reloadData()
                        return
                }
            }
            self.endRefreshHearerAndFooter(isRefresh: isRefresh, addDataArrCount: 1)
        }) { (error) in
            self.endRefreshHearerAndFooter(isRefresh: isRefresh, addDataArrCount: 1)
            RequestHandler.dismissHUD()
            UILabel.showFalureHUD(text: error)
        }
        
        tableView?.reloadData()
    }
    
    
    //结束刷新操作
    func endRefreshHearerAndFooter(isRefresh:Bool,addDataArrCount:Int){
        if isRefresh {
            tableView?.mj_header.endRefreshing()
        }else{
            tableView?.mj_footer.endRefreshing()

        }
        if addDataArrCount%pageSize == 0 && addDataArrCount != 0{
            //可能还有信息,则显示刷新尾部
            tableView?.mj_footer.isHidden = false
        }else{
            //不会有新的信息，不再允许下拉加载
            tableView?.mj_footer.isHidden = true
        }
    }
}

//MARK: - UI
extension ExchangeRecordVC{
    private func layoutUI(){
        titleLabel?.text = "兑换记录".local
    
        view.backgroundColor = UIColor.bgColor()
        addBottomView()
        addTableView()
        
    }
    
    private func addTableView(){
        tableView = WaykiRecordTableView(frame: CGRect(x: 0, y: (header?.bottom())!, width: view.width(), height: (bottomView?.y())!-(header?.bottom())!), style: UITableViewStyle.plain)
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.tableFooterView = UIView()
        tableView?.rowHeight = rowHeight
        tableView?.backgroundColor = UIColor.clear
        tableView?.separatorStyle = .none
        tableView?.register(UINib.init(nibName: "EX_RecordCell", bundle: nil), forCellReuseIdentifier: "EX_RecordCell")
        view.addSubview(tableView!)
        addRefreshHeaderAndFooter()
    }
    
    private func addRefreshHeaderAndFooter(){
        let refreshHeader = MJRefreshNormalHeader.init {[weak self] in
            self?.curPage = 1
            self?.getData()
        }
        tableView?.mj_header = refreshHeader
        
        let refreshFotter = MJRefreshAutoNormalFooter.init {[weak self] in
            self?.curPage = (self?.curPage)! + 1
            self?.getData()
        }
        
        tableView?.mj_footer = refreshFotter
        tableView?.mj_footer.isHidden = true
    }
    
    
    
    private func addBottomView(){
        var viewHeight = scale*32
        let labelHeight = scale*32
        if UIDevice.isX() {
            viewHeight = scale*32 + 15
        }
        bottomView = UIView(frame: CGRect(x: 0, y: UIScreen.height()-viewHeight, width: UIScreen.width(), height: viewHeight))
        bottomView?.backgroundColor = UIColor.RGBHex(0x25345c)
        view.addSubview(bottomView!)
        
        let showLabel = UILabel(frame: CGRect(x: 0, y: 0, width: (bottomView?.width())!, height:labelHeight))
        showLabel.textColor = UIColor.RGBHex(0xd0ddff)
        showLabel.textAlignment = .center
        showLabel.font = UIFont.init(name: "Helvetica", size: 13)
        showLabel.alpha = 0.5
        showLabel.text = "客服微信号：".local + csPhone
        bottomView?.addSubview(showLabel)
    }
}

//MARK: - delegate
extension ExchangeRecordVC{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "EX_RecordCell") as! EX_RecordCell
        let model = dataArray[indexPath.row]
        cell.layoutWithData(data: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
