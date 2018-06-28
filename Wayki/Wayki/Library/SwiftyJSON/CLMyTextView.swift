
import UIKit

class CLMyTextView: UITextView {

    var placeHolder:NSString = ""
    var placeHolderColor:UIColor = UIColor.init(white: 0.77, alpha: 1)

    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        if self.text == "" {
            
            var placeholderRect = CGRect.init()
            placeholderRect.origin.y = 8;
            placeholderRect.size.height = self.frame.height
            placeholderRect.origin.x = 5
            placeholderRect.size.width = self.frame.width
            let style = NSMutableParagraphStyle.init()
            style.lineBreakMode = .byWordWrapping
            style.alignment = .left
            self.placeHolder.draw(in: placeholderRect, withAttributes: [NSAttributedStringKey.font:self.font ?? UIFont.systemFont(ofSize: 16),NSAttributedStringKey.paragraphStyle:style,NSAttributedStringKey.foregroundColor:placeHolderColor])
            
        }
    }
    
    @objc func textChanged(){
        self.setNeedsDisplay()
    }
    
}
