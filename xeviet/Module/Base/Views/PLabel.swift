//
//  PLabel.swift
//  Supership
//
//  Created by Mac on 8/9/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import UIKit

@IBDesignable
class PLabel: UILabel {
    
    let bottomLineHeight: CGFloat = 1.0
    var bottomLine: CALayer?
    
    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 2.0
    @IBInspectable var rightInset: CGFloat = 2.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override var intrinsicContentSize : CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        
        if let _ = self.text {
            let textWidth = frame.size.width - (self.leftInset + self.rightInset)
            let newSize = self.text!.boundingRect(with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font], context: nil)
            intrinsicSuperViewContentSize.height = ceil(newSize.size.height) + self.topInset + self.bottomInset
        }
        
        return intrinsicSuperViewContentSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.updateButtomLineLayout()
    }
    
    @IBInspectable var bottomBorder: Bool = false {
        didSet {
            if (self.bottomLine == nil) {
                self.bottomLine = CALayer()
                self.bottomLine?.borderColor = UIColor.lightGray.cgColor
                self.bottomLine?.borderWidth = bottomLineHeight
                layer.addSublayer(self.bottomLine!)
            }
            
            self.updateButtomLineLayout()
        }
    }
    
    func updateButtomLineLayout() {
        if let line = self.bottomLine {
            let lineHeight = bottomLineHeight
            line.frame = CGRect(x: 0, y: self.frame.height - lineHeight, width: self.frame.width, height: lineHeight)
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var cornerCircle: Bool = false {
        didSet {
            layer.cornerRadius = cornerCircle ? self.frame.size.height / 2 : 0
            layer.masksToBounds = true
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
            setNeedsDisplay()
        }
    }
}







