//
//  NoDataView.swift
//  WaykiApp
//
//  Created by sorath on 2018/10/3.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

class NoDataView: UIView {
    private var image:UIImage?
    private var reminder:String = ""
    
    private var imageView:UIImageView?
    private var reminderLabel:UILabel?
    
    init(imageNamed:String ,reminder:String ,frame:CGRect){
        super.init(frame: frame)
        self.image = UIImage(named: imageNamed)
        self.reminder = reminder
        createUI(imageNamed: imageNamed, reminder: reminder, frame: frame)
    }
    
    func setReminder(reminder:String) ->Void{
        self.reminder = reminder
        reminderLabel?.text = reminder
        reset()
    }
    
    func setReminderColor(color:UIColor){
        reminderLabel?.textColor = color
    }
    
    func reset(){
        
        let imageWidth = self.width() - 20*2
        let imageHeight = imageWidth*311/409
        
        let imageX = self.width()/2.0 - imageWidth/2.0
        let imageY = self.height()/2.0 - imageHeight/2.0
        imageView?.frame = CGRect(x: imageX, y: imageY, width: imageWidth, height: imageHeight)
        reminderLabel?.frame = CGRect(x: 0, y: (imageView?.top())!+imageWidth*180/409, width: frame.size.width, height: 20)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func getNormalView(frame:CGRect) ->NoDataView{
        let v = NoDataView(imageNamed: "no_data", reminder: "暂无数据".local, frame: frame)
        return v
    }
    
}

extension NoDataView{
    private func createUI(imageNamed:String ,reminder:String,frame:CGRect) -> Void {
        
        imageView = UIImageView()
        setImage(imageName: imageNamed)
        addSubview(imageView!)
        
        reminderLabel = UILabel()
        setReminder(reminder: reminder)
        reminderLabel?.textAlignment = .center
        reminderLabel?.font = UIFont.init(name: "PingFangSC-Regular", size: 13)
        reminderLabel?.textColor = UIColor.RGBHex(0x7285a9)
        addSubview(reminderLabel!)
    }
    
    private func setImage(imageName:String) -> Void {
        self.image = UIImage(named: imageName)
        imageView?.image = self.image
        reset()
    }
}
