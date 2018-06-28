

import UIKit

class NavBaseVC: UIViewController {
    
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
    var bgdView:UIView!
    var rightBtn:UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        addBackgroundImageView()
        addBgdView()
        addUpperBackShowImageView(imageName: "wallet_header_bgd_long")
        addHeader()
    }

}

extension NavBaseVC {
    
    private func addBackgroundImageView(){
        backgroundImageView = UIImageView(frame: CGRect(x: -1, y: -1, width: ScreenWidth+2, height: ScreenHeight+2))
        backgroundImageView?.image = UIImage(named: "wallet_bgd")
        self.view.addSubview(backgroundImageView!)
    }
    
    private func addHeader(){
        header = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: naviHeight))
        
        let headImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: naviHeight))
        headImageView.image = UIImage(named: "")
        header?.addSubview(headImageView)
        
        createLeftItem()
        createTitleLabel()
        self.view.addSubview(header!)
    }
    
    private func createLeftItem(){
        leftItem = UIButton(frame: CGRect(x: 6, y: naviHeight-40, width: 30, height: 30))
        leftItem?.addTarget(self, action: #selector(back), for: .touchUpInside)
        leftItem?.setImage(UIImage(named:"main_back"), for: .normal)
        header?.addSubview(leftItem!)
    }
    private func createTitleLabel(){
        titleLabel = UILabel(frame: CGRect(x: 0, y: naviHeight-40, width: ScreenWidth, height: 30))
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel?.textColor = UIColor.white
        titleLabel?.textAlignment = .center
        header?.addSubview(titleLabel!)
    }
    
    private func addBgdView(){
        bgdView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        view.addSubview(bgdView)
    }
    
    //添加上半部分显示视图
    func addUpperBackShowImageView(imageName:String) {
        let showImage = UIImage(named: imageName)
        var size = CGSize(width: 0, height: 0)
        if let s = showImage?.size{
            size = s
            
        }
        
        var imageHeight = ScreenWidth*(size.height)/(size.width)
        if size.height == 0{
            imageHeight = 0
        }
        if UIDevice.isX() {
            imageHeight = imageHeight + 24
        }
        if showImageView==nil{
            showImageView = UIImageView()
        }
        
        showImageView?.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: imageHeight)
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
            let btnX = ScreenWidth - rightSpace - btnWidth
            let btnHeight:CGFloat = 30
            let btnY = naviHeight-40
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

extension NavBaseVC{
    @objc internal func back(){
        navigationController?.popViewController(animated: true)
    }
    
    
}

