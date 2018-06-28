

import UIKit


// MARK:- 语言本地化
extension String {
    var local: String {
        return NSLocalizedString(self, comment: self)
    }
    
    func localS() -> String {
        return NSLocalizedString(self, comment: self)
    }
    
    func underLine()->NSAttributedString {
        let attrs = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 13) as Any,
                     NSAttributedStringKey.foregroundColor:UIColor.white,
                     NSAttributedStringKey.underlineStyle:1] as [NSAttributedStringKey : Any]
        return NSAttributedString(string: self, attributes: attrs)
    }
    
    //MARK:- 去除字符串两端的空白字符
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    //MARK:- 字符串长度
    func length() -> Int {
        return self.characters.count
    }
    
    func indexOf(_ target: Character) -> Int? {
        return self.index(of: target)?.encodedOffset
    }
    
    func subString(to: Int) -> String {
        let endIndex = String.Index.init(encodedOffset: to)
        let subStr = self[self.startIndex..<endIndex]
        return String(subStr)
    }
    
    func subString(from: Int) -> String {
        let startIndex = String.Index.init(encodedOffset: from)
        let subStr = self[startIndex..<self.endIndex]
        return String(subStr)
    }
    
    func subString(start: Int, end: Int) -> String {
        let startIndex = String.Index.init(encodedOffset: start)
        let endIndex = String.Index.init(encodedOffset: end)
        return String(self[startIndex..<endIndex])
    }
    
    func subString(range: Range<String.Index>) -> String {
        return String(self[range.lowerBound..<range.upperBound])
    }
    
    func removeLost0() ->String{
        let testNumber = self
        var outNumber = testNumber
        var i = 1
        if testNumber.contains("."){
            while i < testNumber.count{
                if outNumber.last == "0"{
                    outNumber.removeLast()
                    i = i + 1
                }else{
                    break
                }
            }
            if outNumber.hasSuffix("."){
                outNumber.removeLast()
            }
            return outNumber
        }
        else{
            return testNumber
        }
    }
    
    
    func toFloat()->(CGFloat){
        let string = self
        var cgFloat: CGFloat = 0
        if let doubleValue = Double(string){
            cgFloat = CGFloat(doubleValue)
        }
        return cgFloat
    }
    
    
    func toInt()->(Int){
        let string = self
        var int: Int?
        if let doubleValue = Int(string) {
            int = Int(doubleValue)
        }
        
        if int == nil{ return 0}
        return int!
    }
    
    func formartInputMoney(inputMoney:String,inputCharacter:String) -> Bool {
        let characters = ".0123456789"
        if (characters.range(of: inputCharacter) != nil)||(inputCharacter == "") {
            if (inputMoney.contains("."))&&(inputCharacter.contains(".")) {
                
                return false
            }
            
            return true
        }else{
            return false
        }
        
    }

    
}


// MARK:- 设备判断器
extension UIDevice {
    
    class func isX() -> Bool {
        if UIScreen.main.bounds.height == 812 {return true}
        return false
    }
    
    /** 返回：5，6，p,x */
    class func model() -> String{
        switch UIScreen.main.bounds.size.width {
        case 320:
            return "5"
        case 375:
            if UIScreen.main.bounds.height == 812 {return "x"}
            return "6"
        case 414:
            return "p"
        default:
            return "x"
        }
    }
    
}

// MARK:- 颜色
extension UIColor {
    
    class func RGBHex(_ rgbValue:Int,alpha:CGFloat=1.0) ->(UIColor){
        return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0,blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0,alpha: alpha)
    }
    
    class func RGB(r:CGFloat,g:CGFloat,b:CGFloat,alpha:CGFloat=1.0) ->UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
    }
    
    class func grayColor(v:CGFloat)->UIColor{
        return UIColor(red: v/255.0, green: v/255.0, blue: v/255.0, alpha: 1.0)
    }
    
    /* 绿色字体 */
    class func green_deep()->UIColor{return RGBHex(0x0eb856)}
    /* 新版红色 */
    class func red_new()->UIColor{return RGBHex(0xef3f50)}
    
    class func lightGray() ->UIColor{return RGBHex(0xb2b2b2)}
}

// MARK:- 日期
extension Date{
    
    static func year()->String{
        return String(describing:  self.calender().year!)
    }
    
    static func month()->String{
        return String(describing:  self.calender().month!)
    }
    
    static func day()->String{
        return String(describing: self.calender().day!)
    }
    
    static func hour()->String{
        return String(describing: self.calender().hour!)
    }
    
    static func min()->String{
        return String(describing: self.calender().minute!)
    }
    
    private static func calender()->DateComponents{
        let calendar = Calendar(identifier: .gregorian)
        var comps: DateComponents = DateComponents()
        comps = calendar.dateComponents([.year,.month,.day, .weekday, .hour, .minute,.second], from: Date())
        return comps
    }
    func dateString()->String {
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd HH:mm"
        return formater.string(from: self)
    }
    func hourString()->String {
        let formater = DateFormatter()
        formater.dateFormat = "HH:mm:ss"
        return formater.string(from: self)
    }
    func dayString()->String {
        let formater = DateFormatter()
        formater.dateFormat = "MM-dd HH:mm"
        return formater.string(from: self)
    }
    
    //获取东八区时间
    static func gUTCFormatDate(date:Date) ->Date{
    
        let dateFormatter = InstanceTools.instance.dateFormatter
        let datestr = dateFormatter?.string(from: date)
    
        return dateFormatter!.date(from: datestr!)!
    }
    
    
}


//MARK: - Array
extension Array where Element: Equatable {
    mutating func remove(_ object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

import SVProgressHUD

extension UILabel {
    
    class func showSucceedHUD(text:String){
        SVProgressHUD.setMinimumDismissTimeInterval(0.5)
        SVProgressHUD.showSuccess(withStatus: text)
    }
   
    class func showFalureHUD(text:String){
        SVProgressHUD.setMinimumDismissTimeInterval(0.5)
        SVProgressHUD.showError(withStatus: text)
    }
}


