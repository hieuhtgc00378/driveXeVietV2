//
//  PPaddingLabel.swift
//  Supership
//
//  Created by Mac on 8/9/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import UIKit

@IBDesignable
class PPaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 10.0
    @IBInspectable var bottomInset: CGFloat = 10.0
    @IBInspectable var leftInset: CGFloat = -62.0
    @IBInspectable var rightInset: CGFloat = 10.0
    
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
}









