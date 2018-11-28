

import UIKit

class WalletMarkSureBackupVC: BaseViewController {
    var isFromCreate:Bool = false

    var helpStr:String?
    var words:[String]?
    var firstTopLabel:UILabel?
    var secondTopLabel:UILabel?
    
    var mnBackView:UIView?
    var showMnemonicsLabel:UILabel?
    
    var wordsSelectView:MakeSureWordsView?
    
    var determineBtn:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let helpwords = Bridge.getWalletHelpCodes(from: helpStr)
        words = Bridge.getRamdomArray(with: helpwords) as? [String]
        layoutUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func back() {
        self.dismiss(animated: true, completion: nil)
    }
    
}


//MARK: - UI
extension WalletMarkSureBackupVC{
    func layoutUI(){
        titleLabel?.text = NSLocalizedString("备份助记词", comment: "")
        addUpperBackShowImageView(imageName: "wallet_header_bgd_short")
        
        addTopSHowView()
        addShowLabel()
        addWordsView()
        addDetermineBtn()
    }
    
    
    func addTopSHowView(){
        let xSpace = scale*24.0
        let lWidth = view.width() - 2*xSpace
        let firstTop = scale*80.0
        
        firstTopLabel = UILabel(frame: CGRect(x: xSpace, y: firstTop, width: lWidth, height: scale*18.0))
        firstTopLabel?.text = NSLocalizedString("确认钱包助记词", comment: "")
        firstTopLabel?.textColor = UIColor.amountColor()
        firstTopLabel?.backgroundColor = UIColor.clear
        firstTopLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        firstTopLabel?.textAlignment = .left
        self.view.addSubview(firstTopLabel!)
        
        
        secondTopLabel = UILabel(frame: CGRect(x: xSpace, y: scale*108.0 , width: lWidth, height: scale*36.0))
        secondTopLabel?.text = NSLocalizedString("请按顺序点击助记词，以确认你已备份", comment: "")
        secondTopLabel?.textColor = UIColor.RGBHex(0x7690c3)
        secondTopLabel?.numberOfLines = 0
        secondTopLabel?.backgroundColor = UIColor.clear
        secondTopLabel?.alpha = 0.8
        secondTopLabel?.font = UIFont.systemFont(ofSize: 13)
        secondTopLabel?.textAlignment = .left
        self.view.addSubview(secondTopLabel!)
        secondTopLabel?.sizeToFit()
    }
    
    
    func addShowLabel(){
        let xSpace = scale*24.0
        let mnWidth = view.width() - 2*xSpace
        let mnHeight = mnWidth*110.0/327.0
        mnBackView = UIView(frame: CGRect(x: xSpace, y: scale*145.0, width: mnWidth, height: mnHeight))
        mnBackView?.backgroundColor = UIColor.RGBHex(0x101b36)
        mnBackView?.layer.cornerRadius = 6
        self.view.addSubview(mnBackView!)
        
        let spaceToLeft = scale*16.0
        showMnemonicsLabel = UILabel(frame: CGRect(x: spaceToLeft, y: spaceToLeft, width: mnWidth - 2*spaceToLeft, height: mnHeight - 2*spaceToLeft))
        showMnemonicsLabel?.textAlignment = .left
        showMnemonicsLabel?.numberOfLines = 0
        showMnemonicsLabel?.textColor = UIColor.white
        showMnemonicsLabel?.font = UIFont.systemFont(ofSize: 16)
        mnBackView?.addSubview(showMnemonicsLabel!)
    }
    
    func addWordsView(){
        let xSpace = scale*24.0

        wordsSelectView = MakeSureWordsView(frame: CGRect(x: xSpace, y:(mnBackView?.bottom())! + scale*30.0, width: view.width() - 2*xSpace, height: scale*190.0), data: words!)
        wordsSelectView?.refreshBlock = { [weak self] (str) in
           self?.giveShowLabelText(str: str)
            
        }
        self.view.addSubview(wordsSelectView!)
        
    }
    
    func addDetermineBtn(){
        let btnWidth = scale*327.0
        let btnHeight = btnWidth*44.0/327.0
        let btnTop = view.height() - btnHeight - scale*24.0
        determineBtn = UIButton(type: .custom)
        determineBtn?.frame = CGRect(x: (view.width() - btnWidth)/2.0, y: btnTop, width: btnWidth, height: btnHeight)
        determineBtn?.setTitle(NSLocalizedString("确认", comment: ""), for: .normal)
        determineBtn?.setBackgroundImage(UIImage(named: "btn_normal"), for: .normal)
        determineBtn?.addTarget(self, action: #selector(complete), for: .touchUpInside)
        self.view.addSubview(determineBtn!)
    }
}

//MARK: - event
extension WalletMarkSureBackupVC{
    
    func giveShowLabelText(str:String){
        showMnemonicsLabel?.text = str
        //showMnemonicsLabel?.sizeToFit()
    }
    
    @objc func complete(){
        
        clickEvent()
    }
    
    func clickEvent(){
        
        let selectString = Bridge.getWaletHelpString(withCodes: wordsSelectView?.markSureMuArray!)
        if selectString == helpStr{
//            UmengEvent.eventWithDic(name: "backUp_success")
            let alertStr = "使用助记词可以恢复您的钱包，请妥善保存，不要与他人分享助记词".local
            let alert = UIAlertController(title: "提示".local, message: alertStr, preferredStyle: .alert)
            let action = UIAlertAction(title: "确定".local, style: .cancel) { (action) in
 
                //self.navigationController?.popToRootViewController(animated: true)
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        }else{
            UILabel.showFalureHUD(text: "助记词验证失败，请检查备份")
        }
        
    }
}
