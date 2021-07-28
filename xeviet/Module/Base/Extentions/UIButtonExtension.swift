//
//  UIButtonExtension.swift
//  LianChat
//
//  Created by Mac on 1/13/19.
//  Copyright © 2019 Padi. All rights reserved.
//

import UIKit

// MARK: - PGradientView

@IBDesignable
class PGradientButton: UIButton {
    
    @IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    @IBInspectable var selectedStateMode: Bool =  true { didSet { updateColors() }}
    
    override class var layerClass: AnyClass { return CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }
    
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
        }
    }
    
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    
    func updateColors() {
        let bgColor = backgroundColor ?? UIColor.lightText
        gradientLayer.colors = selectedStateMode ? [startColor.cgColor, endColor.cgColor] : [bgColor.cgColor, bgColor.cgColor]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        updateLocations()
        updateColors()
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
                layer.shadowColor = UIColor(hexString: "FF6B23")?.cgColor
                layer.shadowOpacity = 0.16
                layer.shadowRadius = 10.0
                layer.shadowOffset = CGSize(width: 0, height: 4)
                layer.masksToBounds = false
                //layer.shouldRasterize = true
            }
            setNeedsDisplay()
        }
    }
}









