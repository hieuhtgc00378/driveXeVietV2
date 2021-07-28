//
//  DQView.swift
//  DQ_User
//
//  Created by datxqv on 2/23/17.
//  Copyright © 2017 Paditech Inc. All rights reserved.
//

import UIKit

@IBDesignable
class FView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = true
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        
        didSet {
            self.layer.borderColor = borderColor.cgColor
            self.layer.masksToBounds = true
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        
        didSet {
            self.layer.borderWidth = borderWidth
            self.layer.masksToBounds = true
            setNeedsDisplay()
        }
    }
    
}

extension UIView {
    
    internal func createOval(radius: CGFloat, startPosition: CGFloat = 20.0, distance: CGFloat = 20.0) {
        
        var deltaX: CGFloat = startPosition
        let path = CGMutablePath()
        
        while deltaX < self.frame.size.width {
            
            path.addArc(center: CGPoint(x: deltaX, y: 0), radius: radius, startAngle: 0.0, endAngle: 2 * 3.14, clockwise: false)
            deltaX = deltaX + 2*radius + distance
        }
        path.addRect(CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        self.layer.mask = maskLayer
        self.clipsToBounds = true
        
        setNeedsDisplay()
    }
    
    internal func createOvalDefault() {
    
        let distance: CGFloat = 15.0
        let numberOval: CGFloat = 19.0
        let rate: CGFloat = 0.8
        let div: CGFloat = (numberOval - 1 + (numberOval-1)*rate)
        let radius: CGFloat = (self.frame.size.width - 2*distance)/div
        let distanceMid: CGFloat = radius*rate
        var deltaX: CGFloat = distance
        let path = CGMutablePath()
        for _ in 1...Int(numberOval) {
            path.addArc(center: CGPoint(x: deltaX, y: 1), radius: radius/2.0, startAngle: 0.0, endAngle: 2 * 3.14, clockwise: false)
            deltaX = deltaX + radius + distanceMid
        }
        
        path.addRect(CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        
        self.layer.mask = maskLayer
        self.clipsToBounds = true
        
    }
}





extension UIView {
    
    func pulsate() {
        
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 6, options: [.allowUserInteraction, .curveEaseInOut], animations: {
                            self.transform = CGAffineTransform.identity
                        }, completion: nil)
        })
    }
}


// MARK: - Tap gesture closure

extension UIView {
	
	// In order to create computed properties for extensions, we need a key to
	// store and access the stored property
	fileprivate struct AssociatedObjectKeys {
		static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
	}
	
	fileprivate typealias Action = (() -> Void)?
	
	// Set our computed property type to a closure
	fileprivate var tapGestureRecognizerAction: Action? {
		set {
			if let newValue = newValue {
				// Computed properties get stored as associated objects
				objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
			}
		}
		get {
			let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
			return tapGestureRecognizerActionInstance
		}
	}
	
	// This is the meat of the sauce, here we create the tap gesture recognizer and
	// store the closure the user passed to us in the associated object we declared above
	public func addTapGestureRecognizer(action: (() -> Void)?) {
		self.isUserInteractionEnabled = true
		self.tapGestureRecognizerAction = action
		let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
		self.addGestureRecognizer(tapGestureRecognizer)
	}
	
	// Every time the user taps on the UIImageView, this function gets called,
	// which triggers the closure we stored
	@objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
		if let action = self.tapGestureRecognizerAction {
			action?()
		} else {
			print("no action")
		}
	}
	
}









