//
//  PCollectionView.swift
//  LianChat
//
//  Created by Mac on 1/27/19.
//  Copyright © 2019 Padi. All rights reserved.
//

import UIKit

@IBDesignable
class PCollectionView: UICollectionView {
    
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
                layer.shadowOffset = CGSize(width: 0, height: 0)
                layer.masksToBounds = false
                //layer.shouldRasterize = true
            }
            setNeedsDisplay()
        }
    }
}
