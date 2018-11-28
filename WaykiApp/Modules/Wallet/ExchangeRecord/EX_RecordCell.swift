//
//  EX_RecordCell.swift
//  WaykiApp
//
//  Created by sorath on 2018/9/5.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit
import Kingfisher

class EX_RecordCell: UITableViewCell {
    @IBOutlet weak var leftIconImageView: UIImageView!
    @IBOutlet weak var rightIconImageView: UIImageView!
    
    @IBOutlet weak var leftNumLabel: UILabel!
    @IBOutlet weak var rightNumLabel: UILabel!
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK: - Data
extension EX_RecordCell{
    func layoutWithData(data:EX_RecordModel){
        leftNumLabel.text = data.leftNum
        rightNumLabel.text = data.rightNum
        leftIconImageView.image = UIImage(named: String.init(format: "icon_%@", data.leftName))
        rightIconImageView.image = UIImage(named: String.init(format: "icon_%@", data.rightName))
        
        rateLabel.text = "兑换汇率：".local + data.rate
        timeLabel.text = "兑换时间：".local + data.time
        statusLabel.textColor = UIColor.amountColor()
        statusLabel.text = data.statusStr

        if data.status != 900{
            statusLabel.textColor = UIColor.amountColor()
        }else{
            statusLabel.textColor = UIColor.RGBHex(0xFF5D5D)
        }
    
    }
}
