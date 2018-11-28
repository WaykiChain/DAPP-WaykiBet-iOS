

import UIKit

public protocol ZHDropDownMenuDelegate: NSObjectProtocol {
    func dropDownMenu(_ menu:ZHDropDownMenu, didEdit text:String)
    func dropDownMenu(_ menu:ZHDropDownMenu, didSelect index:Int)
    func openOrClose(_ isopen:Bool)
}

@IBDesignable public class ZHDropDownMenu: UIView {
    
    public weak var delegate: ZHDropDownMenuDelegate?
    
    public var didEditHandler: ((_ text: String) -> Void)?
    
    public var didSelectHandler: ((_ index: Int) -> Void)?

    public var options = [String]() {//菜单项数据，设置后自动刷新列表
        didSet {
            reload()
        }
    }

    public var rowHeight: CGFloat { //菜单项的每一行行高，默认和本控件一样高，如果为0则和本空间初始高度一样
        get{
            if _rowHeight == 0 {
                return frame.size.height
            }
            return _rowHeight
        }
        set{
            _rowHeight = newValue
            reload()
        }
    }
    
    public var menuHeight: CGFloat {// 菜单展开的最大高度，当它为0时全部展开
        get {
            if _menuMaxHeight == 0 {
                return CGFloat(options.count) * rowHeight
            }
            return min(_menuMaxHeight, CGFloat(options.count) * rowHeight)
        }
        set {
            _menuMaxHeight = newValue
            reload()
        }
    }
    
    @IBInspectable public var editable = false { //是否允许用户编辑, 默认不允许
        didSet {
            contentTextField.isEnabled = editable
        }
    }
    
    @IBInspectable public var buttonImage: UIImage? { //下拉按钮的图片
        didSet {
            pullDownButton.setImage(buttonImage, for: UIControlState())
        }
    }
    
    @IBInspectable public var placeholder: String? { //占位符
        didSet {
            contentTextField.placeholder = placeholder
        }
    }

    @IBInspectable public var defaultValue: String? { //默认值
        didSet {
            contentTextField.text = defaultValue
        }
    }
    
    @IBInspectable public var textColor: UIColor?{ //输入框和下拉列表项中文本颜色
        didSet {
            contentTextField.textColor = textColor
        }
    }
    
    public var font: UIFont?{ //输入框和下拉列表项中字体
        didSet {
            contentTextField.font = font
        }
    }
    
    lazy var cover:UIView = {
        let v = UIView.init(frame: (UIApplication.shared.keyWindow?.frame)!)
        v.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
        v.alpha = 0
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(closeMenu))
        v.addGestureRecognizer(tap)
        return v
    }()
    
    public var showBorder = true { //是否显示边框，默认显示
        didSet {
            if showBorder {
                layer.borderColor = UIColor.lightGray.cgColor
                layer.borderWidth = 0.5
                layer.masksToBounds = true
                layer.cornerRadius = 2.5
            }else {
                layer.borderColor = UIColor.clear.cgColor
                layer.masksToBounds = false
                layer.cornerRadius = 0
                layer.borderWidth = 0
            }
        }
    }
    
    private lazy var optionsList: UITableView = { //下拉列表
        let frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y + self.frame.size.height, width: self.frame.size.width, height: 0)
        let table = UITableView(frame: frame, style: .plain)
        table.backgroundColor = UIColor.RGBHex(0xFAFBFF, alpha: 0.95)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .singleLine
        table.layer.cornerRadius = 5
        self.superview?.addSubview(table)
        return table
    }()
    
    public var contentTextField: UITextField!
    
    private var pullDownButton: UIButton!
    
    private var isShown = false

    private var _rowHeight = CGFloat(0)
    
    private var _menuMaxHeight = CGFloat(0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        contentTextField = UITextField(frame: CGRect.zero)
        contentTextField.delegate = self
        contentTextField.isEnabled = false
        contentTextField.textAlignment = .right
    
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(ZHDropDownMenu.showOrHide))
        addSubview(contentTextField)
        addGestureRecognizer(tap)
        
        
        pullDownButton = UIButton(type: .custom)
        pullDownButton.addTarget(self, action: #selector(ZHDropDownMenu.showOrHide), for: .touchUpInside)
        pullDownButton.setImage(UIImage(named: "arrow_down"), for: .normal)
        addSubview(pullDownButton)
        
        showBorder = true
        textColor = .darkGray
        
    }
    
    @objc func showOrHide() {
        if isShown {
            self.delegate?.openOrClose(false)
            UIView.animate(withDuration: 0.3, animations: {
                self.pullDownButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*2))
                self.optionsList.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y + self.frame.size.height-0.5, width: self.frame.size.width, height: 0)
            }, completion: { _ in
                self.pullDownButton.transform = CGAffineTransform(rotationAngle: 0.0)
                self.isShown = false
                
            })
        } else {
            self.delegate?.openOrClose(true)
            contentTextField.resignFirstResponder()
            optionsList.reloadData()
            UIView.animate(withDuration: 0.3, animations: {
                self.pullDownButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                self.optionsList.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y + self.frame.size.height-0.5, width: self.frame.size.width, height:self.menuHeight)
            }, completion: { _ in
                self.isShown = true
            })
        }
    }
    
    func reload() {
        guard self.isShown else {
            return
        }
        optionsList.reloadData()
        UIView.animate(withDuration: 0.3) {
            self.pullDownButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            self.optionsList.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y + self.frame.size.height-0.5, width: self.frame.size.width, height:self.menuHeight)
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        contentTextField.frame = CGRect(x: 0, y: 5, width: frame.size.width - 25, height: frame.size.height - 10)
        pullDownButton.frame = CGRect(x: frame.size.width - 30, y: 0, width: 30, height: 30)
    }
    
    @objc func closeMenu(){
        showOrHide()
    }
}

extension ZHDropDownMenu: UITextFieldDelegate {
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text {
            self.delegate?.dropDownMenu(self, didEdit: text)
            self.didEditHandler?(text)
        }
        return true
    }
    
    
    
}

extension ZHDropDownMenu: UITableViewDelegate, UITableViewDataSource {
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "")
        cell.textLabel?.text = options[indexPath.row]
        cell.textLabel?.font = UIFont.init(name: "PingFangSC-Regular", size: 14)
        cell.selectionStyle = .none
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = UIColor.RGBHex(0x566488)
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.rowHeight
    }
    
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contentTextField.text = options[indexPath.row]
        delegate?.dropDownMenu(self, didSelect:indexPath.row)
        didSelectHandler?(indexPath.row)
        showOrHide()
    }
}
