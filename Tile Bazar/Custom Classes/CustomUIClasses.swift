//
//  CustomUIClasses.swift
//  Tile Bazar
//
//  Created by Apple on 8/13/22.
//

import UIKit

// MARK:- ConerButton Class
class CornerButton : UIButton{
    override func awakeFromNib() {
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
}
// MARK:- CornerLabel Class
class CornerLabel : UILabel{
    override func awakeFromNib() {
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
}
// MARK:- ConerView Class
class ConerView : UIView{
    override func awakeFromNib() {
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
}
// MARK:- ERLFieldViews Class
class ERLFieldViews : UIView{
    override func awakeFromNib() {
        self.layer.cornerRadius = 2.5
        self.layer.borderColor = #colorLiteral(red: 0.7215686275, green: 0.7333333333, blue: 0.7647058824, alpha: 1)
        self.layer.borderWidth = 1
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
}
//MARK:- ERLSquareTextField Class
class ERLSquareTextField : UITextField{
    override func awakeFromNib() {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 0.5
        self.tintColor = .black
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
}
// MARK:- ConerTextview Class
class CornerTextView : UITextView{
    override func awakeFromNib() {
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
    }
}
// MARK:- CustomLabel Class For padding in Label
class CustomUILabel: UILabel {
    let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
    override var intrinsicContentSize: CGSize{
        var contentSize = super.intrinsicContentSize
        contentSize.height += insets.top + insets.bottom
        contentSize.width += insets.left + insets.right
        let maxvalue = max(contentSize.height, contentSize.width)
        return CGSize(width: maxvalue, height: maxvalue)
    }
}
// MARK:- RoundView Class
class RoundView : UIView{
    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
}
// MARK:- BorderView Class
class BorderView : UIView{
    override func awakeFromNib() {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.black.cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
}
// MARK:- RoundViewWithBorder Class
class RoundViewWithBorder : UIView{
    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.white.cgColor
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
}
// MARK:- RoundLabel Class
class RoundLabel : UILabel{
    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
}
// MARK:- ERLBGView Class
class ERLBGView : UIView{
    override func awakeFromNib() {
        self.layer.backgroundColor = UIColor.white.cgColor
    }
}
// MARK:- RoundImageView Class
class RoundImageView : UIImageView{
    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
}
//// MARK:- RoundView Class
//class ERLRoundImageView : UIImageView{
//    override func awakeFromNib() {
//        self.layer.borderWidth = 0.0
//        self.layer.cornerRadius = self.frame.size.height/2
//        self.layer.masksToBounds = true
//        self.layer.borderColor = UIColor(red: 33.0/255.0, green: 37.0/255.0, blue: 46.0/255.0, alpha: 1.0).cgColor
//    }
//}
// MARK:- RoundView Class
class ERLButton : UIButton{
    override func awakeFromNib() {
        self.layer.borderWidth = 4.0
        self.layer.cornerRadius = self.frame.height/2
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor(red: 33.0/255.0, green: 37.0/255.0, blue: 46.0/255.0, alpha: 1.0).cgColor
    }
}
// MARK:- RoundButton Class
class RoundButton : UIButton{
    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.borderWidth = 0.0
        self.layer.borderColor = UIColor.clear.cgColor
    }
}
// MARK:- ERLLoginFields TextField Class
class ERLLoginFields : UITextField{
    override func awakeFromNib() {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
        self.tintColor = UIColor.black
        self.textColor = UIColor.black
        self.backgroundColor = UIColor.white
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
}
class ERLLoginFieldsLessCorner : UITextField{
    override func awakeFromNib() {
        self.layer.cornerRadius = 3
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.black.cgColor
        self.tintColor = UIColor.black
        self.textColor = UIColor.black
        self.backgroundColor = UIColor.white
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
}
class ChatTextFieldContainerView : UIView{
    override func awakeFromNib() {
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
}
class AddItemButton : UIButton{
    override func awakeFromNib() {
        self.layer.cornerRadius = 13
        self.clipsToBounds = true
        self.layer.borderWidth = 0.5
        self.layer.borderColor = #colorLiteral(red: 0.8903859258, green: 0.6796250939, blue: 0.3932918608, alpha: 1)
        self.layer.masksToBounds = true
    }
}
