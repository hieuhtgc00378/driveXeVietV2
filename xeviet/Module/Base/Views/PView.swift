//
//  PView.swift
//  Supership
//
//  Created by Mac on 8/9/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import UIKit

@IBDesignable
class PView: UIView {
    
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
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var colorOpacity: CGFloat = 0 {
        didSet {
            backgroundColor = backgroundColor?.withAlphaComponent(colorOpacity)
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var isShadow: Bool = false {
        didSet {
            if isShadow {
                layer.shadowColor = UIColor.black.cgColor
                layer.shadowOpacity = 0.16
                layer.shadowRadius = 4.0
                layer.shadowOffset = CGSize(width: 1, height: 3)
                layer.masksToBounds = false
                //layer.shouldRasterize = true
            }
            setNeedsDisplay()
        }
    }
    
    /// SwifterSwift: Shadow color of view; also inspectable from Storyboard.
    @IBInspectable public var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    /// SwifterSwift: Shadow offset of view; also inspectable from Storyboard.
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    /// SwifterSwift: Shadow opacity of view; also inspectable from Storyboard.
    @IBInspectable public var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    /// SwifterSwift: Shadow radius of view; also inspectable from Storyboard.
    @IBInspectable public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
}







