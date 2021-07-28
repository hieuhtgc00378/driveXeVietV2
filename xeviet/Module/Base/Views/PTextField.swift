//
//  PTextField.swift
//  Supership
//
//  Created by Mac on 8/9/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import UIKit

@IBDesignable
class PTextField: UITextField {
    
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 10.0
    @IBInspectable var rightInset: CGFloat = 10.0
    
    let bottomLineHeight: CGFloat = 1.0
    var bottomLine: CALayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.updateButtomLineLayout()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset))
    }
    
    override var intrinsicContentSize : CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        //self.showHideKeyboard()
        let textWidth = frame.size.width - (self.leftInset + self.rightInset)
        let newSize = self.text!.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font!], context: nil)
        intrinsicSuperViewContentSize.height = ceil(newSize.size.height) + self.topInset + self.bottomInset
        
        return intrinsicSuperViewContentSize
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            layer.borderWidth = borderWidth
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var cornerCircle: Bool = false {
        didSet {
            layer.cornerRadius = cornerCircle ? self.frame.size.height / 2 : 0
            layer.masksToBounds = cornerCircle
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var isShadow: Bool = false {
        didSet {
            if isShadow {
                layer.masksToBounds = false
                layer.shadowColor = UIColor.black.cgColor
                layer.shadowOpacity = 0.16
                layer.shadowRadius = 4.0
                layer.shadowOffset = CGSize(width: 0, height: 4)
                //layer.shouldRasterize = true
            }
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var bottomBorder: Bool = false {
        didSet {
            if (self.bottomLine == nil) {
                self.bottomLine = CALayer()
                self.bottomLine?.borderColor = UIColor.lightGray.cgColor
                self.bottomLine?.borderWidth = bottomLineHeight
                self.layer.addSublayer(self.bottomLine!)
            }
            self.updateButtomLineLayout()
        }
    }
    
    @IBInspectable var placeholderColor: UIColor {
        get {
            return self.attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor ?? .lightText
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [.foregroundColor: newValue])
        }
    }
    
    func updateButtomLineLayout() {
        if let line = self.bottomLine {
            let lineHeight = bottomLineHeight
            line.frame = CGRect(x: 0, y: self.frame.height - lineHeight, width: self.frame.width, height: lineHeight)
        }
    }
}






