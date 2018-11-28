

import UIKit

class WalletBackupVC: BaseViewController {
    var isFromCreate:Bool = false
    var password:String = ""
    var firstTopLabel:UILabel?
    var secondTopLabel:UILabel?
    
    var mnBackView:UIView?
    var showMnemonicsLabel:UILabel?
    
    var remarkLabel1:UILabel?
    var remarkLabel2:UILabel?
    
    var startBtn:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
extension WalletBackupVC{
    func layoutUI(){
        titleLabel?.text = NSLocalizedString("备份助记词", comment: "")
        addTopSHowView()
        addShowLabel()
        addRemarkView()
        addStartBtn()
        
        showMnemonicsLabel?.text = AccountManager.getAccount().getHelpString(password: password)
        showMnemonicsLabel?.sizeToFit()
        remarkLabel2?.sizeToFit()

    }
    
    func addTopSHowView(){
        let xSpace = scale*24
        let lWidth = view.width() - 2*xSpace
        let firstTop = scale*80
        
        firstTopLabel = UILabel(frame: CGRect(x: xSpace, y: firstTop, width: lWidth, height: scale*18))
        firstTopLabel?.text = NSLocalizedString("请抄下助记词", comment: "")
        firstTopLabel?.textColor = UIColor.amountColor()
        firstTopLabel?.backgroundColor = UIColor.clear
        firstTopLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        firstTopLabel?.textAlignment = .left
        self.view.addSubview(firstTopLabel!)
        
        
        secondTopLabel = UILabel(frame: CGRect(x: xSpace, y: scale*108 , width: lWidth, height: scale*36))
        secondTopLabel?.text = NSLocalizedString("助记词用于恢复钱包或重置钱包密码，请将它准确的抄写到纸上，并存放在只有您自己知道的安全地方。", comment: "")
        secondTopLabel?.textColor = UIColor.RGBHex(0x7690c3)
        secondTopLabel?.numberOfLines = 0
        secondTopLabel?.backgroundColor = UIColor.clear
        secondTopLabel?.alpha = 0.8
        secondTopLabel?.font = UIFont.systemFont(ofSize: 13)
        secondTopLabel?.textAlignment = .left
        self.view.addSubview(secondTopLabel!)
    }
    
    
    func addShowLabel(){
        let xSpace = scale*24
        let mnWidth = view.width() - 2*xSpace
        let mnHeight = mnWidth*110.0/327.0
        mnBackView = UIView(frame: CGRect(x: xSpace, y: scale*164, width: mnWidth, height: mnHeight))
        mnBackView?.backgroundColor = UIColor.RGBHex(0x101b36)
        mnBackView?.layer.cornerRadius = 6
        self.view.addSubview(mnBackView!)
        
        let spaceToLeft = scale*16
        showMnemonicsLabel = UILabel(frame: CGRect(x: spaceToLeft, y: spaceToLeft, width: mnWidth - 2*spaceToLeft, height: mnHeight - 2*spaceToLeft))
        showMnemonicsLabel?.textAlignment = .left
        showMnemonicsLabel?.numberOfLines = 0
        showMnemonicsLabel?.textColor = UIColor.white
        showMnemonicsLabel?.font = UIFont.systemFont(ofSize: 16)
        mnBackView?.addSubview(showMnemonicsLabel!)
    }
    
    func addRemarkView(){
        let top = scale*20.0
        let xSpace = scale*24.0
        let rWidth = view.width() - 2*xSpace
        remarkLabel1 = UILabel(frame: CGRect(x: xSpace, y: (mnBackView?.bottom())!+top, width: rWidth, height: scale*17.0))
        remarkLabel1?.textAlignment = .left
        remarkLabel1?.text = "特别提醒：".local
        remarkLabel1?.textColor = UIColor.white
        remarkLabel1?.font = UIFont.systemFont(ofSize: 12)
        remarkLabel1?.backgroundColor = UIColor.clear
        self.view.addSubview(remarkLabel1!)
        
        remarkLabel2 = UILabel(frame: CGRect(x: xSpace, y: (remarkLabel1?.bottom())! + scale*8.0, width: rWidth, height: scale*32.0))
        remarkLabel2?.textAlignment = .left
        remarkLabel2?.text = "助记词非常重要！不要丢失或泄漏，如果有人获取您的助记词将直接获取您的资产！".local
        remarkLabel2?.numberOfLines = 0
        remarkLabel2?.alpha = 0.5
        remarkLabel2?.backgroundColor = UIColor.clear
        remarkLabel2?.textColor = UIColor.white
        remarkLabel2?.font = UIFont.systemFont(ofSize: 11)
        self.view.addSubview(remarkLabel2!)

    }
    
    func addStartBtn(){
        let btnWidth = scale*327.0
        let btnHeight = btnWidth*44.0/327.0
        let btnTop = (remarkLabel2?.bottom())! + scale*30.0
        startBtn = UIButton(type: .custom)
        startBtn?.frame = CGRect(x: (view.width() - btnWidth)/2.0, y: btnTop, width: btnWidth, height: btnHeight)
        startBtn?.setTitle(NSLocalizedString("开始备份", comment: ""), for: .normal)
        startBtn?.setBackgroundImage(UIImage(named: "btn_normal"), for: .normal)
        startBtn?.addTarget(self, action: #selector(startBackup), for: .touchUpInside)
        
        self.view.addSubview(startBtn!)
    }
}

extension WalletBackupVC {
    @objc func startBackup(){
        let c =  WalletMarkSureBackupVC()
        c.helpStr = showMnemonicsLabel?.text
        c.isFromCreate = isFromCreate
        self.present(c, animated: true, completion: nil)
    }
}
