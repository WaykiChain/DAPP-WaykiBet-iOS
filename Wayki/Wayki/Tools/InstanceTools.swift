
import UIKit


class InstanceTools: NSObject {
    static let instance:InstanceTools = InstanceTools()
    
    var dateFormatter:DateFormatter?
    var ymdDateFormatter:DateFormatter?
    var timer:Timer?
    private var timerDic:[UIView:String] = [:]
    override init() {
        super.init()
        setGMT8DateFormatter()
        setTimer()
        setYMDDateFormatter()
    }
    
    
    
}

//MARK: - set
extension InstanceTools{
    //设置东八区时间
    private func setGMT8DateFormatter(){
        let timeZ = TimeZone.init(abbreviation: "GMT+0800")
        dateFormatter = DateFormatter()
        dateFormatter?.timeZone = timeZ
        dateFormatter?.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    
    private func setTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(repeats), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
        timer?.fire()
        
    }
    
    private func setYMDDateFormatter(){
        ymdDateFormatter = DateFormatter()
        ymdDateFormatter?.dateFormat = "yyyy-MM-dd"
    }
    
    func setTimerWithView(vi:UIView,selStr:String){
        //保存对应的vi和sel
        timerDic[vi] = selStr
    }
    
    @objc func repeats(){
        //遍历字典，调用能响应的方法
        if timerDic.count>0 {
            for (vi,selStr) in timerDic {
                if vi.superview != nil{
                    if let sel:Selector =  NSSelectorFromString(selStr){
                        if vi.responds(to: sel){
                            vi.perform(sel)
                        }
                    }
                }
            }
        }
    }
}
