
import UIKit

class FoundationV: UIView {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildView(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func buildView(frame: CGRect){ }
}

// MARK:- 控制器
class FoundationC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = String.init(utf8String: object_getClassName(self))!
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}


// MARK:- 单元格
typealias CellClosure = (Int,Int,Int,[String]) -> Void

class FoundationCell: UITableViewCell {
    var cellClosure:CellClosure?
    var cellIndexPath:IndexPath?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.white
        self.selectionStyle = .none
        buildCell(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented") }
    
    func buildCell(frame:CGRect=CGRect.zero) { }
}

