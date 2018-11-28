//
//  WaykiRecordTableView.swift
//  WaykiApp
//
//  Created by sorath on 2018/10/8.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

class WaykiRecordTableView: UITableView {
    var noDataView:NoDataView?
    
    func createNoDataView() {
        noDataView = NoDataView.getNormalView(frame:self.bounds)
        self.addSubview(noDataView!)
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        createNoDataView()
        self.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if self.contentSize.height>0{
            noDataView?.isHidden = true
        }else{
            if noDataView?.frame == CGRect(x: 0, y: 0, width: 0, height: 0){
                noDataView?.frame = self.bounds
                noDataView?.reset()
            }
            noDataView?.isHidden = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "contentSize")
    }

}
