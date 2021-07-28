//
//  PTextView.swift
//  Supership
//
//  Created by Mac on 8/9/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import UIKit

@IBDesignable
open class PTextView: UITextView {
    
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
            layer.masksToBounds = cornerRadius > 0
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
}







