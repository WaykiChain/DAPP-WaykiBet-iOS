

import UIKit

class MakeSureWordsView: UIView {
    var wordMuArray:[String]?//数据源、助记词拆分后的数组
    var markSureMuArray:[String]?
    var markSureTagMuArray:[String]?
    var refreshBlock:((String) ->Void)?
    
    var selectedColor:UIColor?
    var normalColor:UIColor?
    init(frame: CGRect,data:[String]) {
        super.init(frame: frame)
        normalColor = UIColor.RGBHex(0x7690c3, alpha: 1)
        selectedColor = UIColor.RGBHex(0x7690c3, alpha: 0.3)

        wordMuArray = []
        markSureMuArray = []
        markSureTagMuArray = []
        wordMuArray = data
        
        self.frame.size.height = createWordsAndReturnHeight()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func createWordsAndReturnHeight() ->CGFloat{
        let btnHeight = scale*40.0
        var startX:CGFloat = 0
        var startY:CGFloat = 0
        let buttonHeight:CGFloat = scale*40.0
        let spaceWidth:CGFloat = 10
        let spaceHeight:CGFloat = 10
        var backHeight:CGFloat = 0
        for (i,word) in (wordMuArray?.enumerated())! {
            let btn = UIButton(type:.custom)
            btn.tag = 1000+i
            btn.backgroundColor = UIColor.clear
            btn.layer.borderWidth = 1
            btn.layer.opacity = 0.5
            btn.layer.borderColor = selectedColor?.cgColor
            btn.setTitle(word, for: .normal)
            btn.setTitleColor(UIColor.white, for: .normal)//RGB(r: 175, g: 166, b: 169)
            btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)

            btn.layer.cornerRadius = btnHeight/2.0
            btn.addTarget(self, action: #selector(clickWord(btn:)), for: .touchUpInside)
            self.addSubview(btn)
            
            let word1 = word as NSString
            var titleSize = word1.size(withAttributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 17)])
            titleSize.height = 10
            titleSize.width =  titleSize.width + spaceWidth*4
            
            if (startX + titleSize.width > self.bounds.size.width){
                startX = 0
                startY = startY + buttonHeight + spaceHeight
            }
            btn.frame = CGRect(x: startX, y: startY, width: titleSize.width, height: buttonHeight)
            startX = btn.right() + spaceWidth
            
            if i == (wordMuArray?.count)! - 1{
                backHeight = startY + buttonHeight
            }
            
        }
        return backHeight
    }
}

extension MakeSureWordsView{
    @objc func clickWord(btn:UIButton) {
        if (btn.isSelected == false) {
            let word = wordMuArray![btn.tag - 1000]
            markSureMuArray?.append(word)
            
            markSureTagMuArray?.append(String.init(format: "%@_0x000000010afe712b_%ld", word,btn.tag-1000))
            btn.backgroundColor = selectedColor
        }else{
            let tag = btn.tag-1000
            let word = wordMuArray![tag]
            let word1 = String.init(format: "%@_0x000000010afe712b_%ld", word,btn.tag-1000)
            let wordIndex = markSureTagMuArray?.index(of: word1)
            markSureTagMuArray?.remove(at: wordIndex!)
            markSureMuArray?.remove(at: wordIndex!)
            btn.backgroundColor = UIColor.clear

        }
        
        
        btn.isSelected = !btn.isSelected;
        refreshShowLabel()
    }
    
    func refreshShowLabel(){
        var showWord = ""
        for word in markSureMuArray! {
            showWord = showWord + " " + word
        }
        if  refreshBlock != nil {
            refreshBlock!(showWord)
        }
    }
}
