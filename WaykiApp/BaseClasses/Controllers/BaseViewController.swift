//
//  BaseViewController.swift
//  WaykiApp
//
//  Created by louis on 2018/8/24.
//  Copyright © 2018年 WaykiChain. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    enum load_Way {
        case refresh
        case loadmore
    }
    var curPage: Int = 1
    var loadWay:load_Way = .refresh
    
    var backgroundImageView:UIImageView?
    var header:UIView?
    var titleLabel:UILabel?
    var leftItem:UIButton?
    var showImageView:UIImageView?
    var rightBtn:UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()

        addHeader()
        view.backgroundColor = UIColor.bgColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

// 添加提示器
extension BaseViewController{
    
    func addTextHUD(text:String,type:Int = 0){
        switch type {
        case 0:
            
            HUD.flash(.label(text), onView: self.view, delay: 1.6, completion: nil)
            break
        case 1:
            HUD.flash(.labeledSuccess(title: text, subtitle: ""))
            break
        default:
            HUD.flash(.label(text), onView: self.view, delay: 1.6, completion: nil)
        }
    }
}

extension BaseViewController {
    
    private func addHeader(){
        header = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.width(), height: UIScreen.naviBarHeight()))
        
        let headImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.width(), height: UIScreen.naviBarHeight()))
        headImageView.image = UIImage(named: "")
        header?.addSubview(headImageView)
        headImageView.backgroundColor = UIColor.bgColor()
        createLeftItem()
        createTitleLabel()
        self.view.addSubview(header!)
    }
    
    private func createLeftItem(){
        leftItem = UIButton(frame: CGRect(x: 10, y: UIScreen.naviBarHeight()-43, width: 36, height: 36))
        leftItem?.addTarget(self, action: #selector(back), for: .touchUpInside)
        leftItem?.setImage(UIImage(named:"arrow_left"), for: .normal)
        header?.addSubview(leftItem!)
    }
    private func createTitleLabel(){
        titleLabel = UILabel(frame: CGRect(x: 60, y: UIScreen.naviBarHeight()-40, width: UIScreen.width()-120, height: 30))
        titleLabel?.font = UIFont.init(name: "PingFangSC-Semibold", size: 20)
        titleLabel?.textColor = UIColor.white
        titleLabel?.textAlignment = .center
        header?.addSubview(titleLabel!)
    }
    
    //添加上半部分显示视图
    func addUpperBackShowImageView(imageName:String) {
        let showImage = UIImage(named: imageName)
        var size = CGSize(width: 0, height: 0)
        if let s = showImage?.size{
            size = s
            
        }
        
        var imageHeight = UIScreen.width()*(size.height)/(size.width)
        if size.height == 0{
            imageHeight = 0
        }
        if UIDevice.isX() {
            imageHeight = imageHeight + 24
        }
        if showImageView==nil{
            showImageView = UIImageView()
        }
        
        showImageView?.frame = CGRect(x: 0, y: 0, width: UIScreen.width(), height: imageHeight)
        showImageView?.image = showImage
        if showImageView?.superview != self.view {
            self.view.addSubview(showImageView!)
        }
    }
    //添加右上角按钮
    func addRightBtn(title:String){
        if title.count>0 {
            let rightSpace = scale*24
            let lSize = (title as NSString).boundingRect(with: CGSize(width: 100, height: 30), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14)], context: nil).size
            let btnWidth:CGFloat = lSize.width + 10
            let btnX = UIScreen.width() - rightSpace - btnWidth
            let btnHeight:CGFloat = 30
            let btnY = UIScreen.naviBarHeight()-40
            rightBtn = UIButton(type: .custom)
            rightBtn?.frame = CGRect(x: btnX, y: btnY, width: btnWidth, height: btnHeight)
            rightBtn?.setTitle(title, for: .normal)
            rightBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            rightBtn?.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
            rightBtn?.titleEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
            header?.addSubview(rightBtn!)
        }
    }

    
}

extension BaseViewController{
    @objc internal func back(){
        if navigationController != nil {
            navigationController?.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}
