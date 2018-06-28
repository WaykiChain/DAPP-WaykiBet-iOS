

import UIKit


extension UIView {
    
    func gradientBackground(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.white,UIColor.blue,UIColor.red]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: ScreenWidth, y: ScreenHeight)
        gradientLayer.locations = [0.0,0.3,0.5]
        layer.addSublayer(gradientLayer)
    }
    
    //上下震荡
    func animationShootOut() {
        let frame = self.frame
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            
        }) { (finished) in
            UIView.animate(withDuration: 0.19, delay: 0, options: .curveEaseOut, animations: {
                self.frame.origin.y =  self.frame.origin.y - 15
            }, completion: { (finished1) in
                UIView.animate(withDuration: 0.18, delay: 0, options: .curveEaseIn, animations: {
                    self.frame = frame
                }, completion: { (finished2) in
                    UIView.animate(withDuration: 0.17, delay: 0, options: .curveEaseOut, animations: {
                        self.frame.origin.y =  self.frame.origin.y - 7.5
                    }, completion: { (finished3) in
                        UIView.animate(withDuration: 0.16, delay: 0, options: .curveEaseIn, animations: {
                            self.frame = frame
                        }, completion: nil)
                    })
                })
            })
        }
    }
    
    //放大缩小动画
    func animationBigSmall(range:CGFloat=0.15){
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = 0.6;
        var values:[NSValue] = []
        values.append(NSValue.init(caTransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0)))
        values.append(NSValue.init(caTransform3D: CATransform3DMakeScale(1.00+range, 1.00+range, 1.0)))
        values.append(NSValue.init(caTransform3D: CATransform3DMakeScale(1.00-range/2,1.00-range/2, 1.0)))
        values.append(NSValue.init(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        animation.values = values;
        self.layer.add(animation, forKey: nil)
    }
    
    //放大缩小
    func animationBigSmall(time:Double,transform3D:[CATransform3D]){
        let animation = CAKeyframeAnimation(keyPath: "transform")
        animation.duration = time;
        var values:[NSValue] = []
        for ca in transform3D {
            values.append(NSValue.init(caTransform3D: ca))
        }
        animation.values = values;
        self.layer.add(animation, forKey: nil)
    }
    
    // 重力弹跳动画效果
    func shakerAnimation (time:Double,iValue:[Float],keyTimes:[Float]){
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        let currentTx:Float = Float(self.transform.ty)
        animation.duration = time
        
        var values:[NSNumber] = []
        for f in iValue {
            values.append(NSNumber.init(value: currentTx + f))
        }
        animation.values = values

        if keyTimes.count == iValue.count{
            var keyTimeArr:[NSNumber] = []

            for t in keyTimes {
                keyTimeArr.append(NSNumber.init(value:t))
            }

             animation.keyTimes = keyTimeArr
        }
       
        self.layer.add(animation, forKey: "kViewShakerAnimationKey")

    }
    
    
    
}

class CGView:UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //设置背景色为透明，否则是黑色背景
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //获取绘图上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        //创建一个矩形，它的所有边都内缩3
        let drawingRect = self.bounds.insetBy(dx: 3, dy: 3)
        
        //创建并设置路径
        let path = CGMutablePath()
        path.move(to: CGPoint(x:drawingRect.minX, y:drawingRect.minY))
        path.addLine(to:CGPoint(x:drawingRect.maxX, y:drawingRect.minY))
        path.addLine(to:CGPoint(x:drawingRect.maxX, y:drawingRect.maxY))
        
        //添加路径到图形上下文
        context.addPath(path)
        
        //设置笔触颜色
        context.setStrokeColor(UIColor.white.cgColor)
        //设置笔触宽度
        context.setLineWidth(6)
        //绘制路径
        context.strokePath()
    }
}

//对助记词通过密码进行加解密
extension String{
    
    func encryt(password:String)->String{
        return SecurityUtil.encryptAESData(self, passWord: password)
    }
    
    func dencryt(password:String)->String{
        return SecurityUtil.decryptAESData(self, passWord: password)
    }
}


func labelHeight(text: String, font: UIFont, width: CGFloat) -> CGFloat {
    let option = NSStringDrawingOptions.usesLineFragmentOrigin
    let zsize = CGSize(width:width , height: 900)
    let rect:CGRect = text.boundingRect(with: zsize, options: option, attributes: [NSAttributedStringKey.font:font], context: nil)
    return rect.size.height
}

func labelWidth(text: String, font: UIFont, hight: CGFloat) -> CGFloat {
    let option = NSStringDrawingOptions.usesLineFragmentOrigin
    let zsize = CGSize(width:ScreenWidth , height: hight)
    let rect:CGRect = text.boundingRect(with: zsize, options: option, attributes: [NSAttributedStringKey.font:font], context: nil)
    return rect.size.width
}

extension NSObject{
     func address() -> String {
        return String.init(format: "%018p", unsafeBitCast(self, to: Int.self))
    }
}



