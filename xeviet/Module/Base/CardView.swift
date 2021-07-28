//
//  CardView.swift
//  htxviet
//
//  Created by NhatQuang on 8/3/18.
//  Copyright © 2018 nhatquang. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CardView: UIView {
	
	@IBInspectable var cornerRadius: CGFloat = 10
	@IBInspectable var shadowOffsetWidth: Int = 0
	@IBInspectable var shadowOffsetHeight: Int = 0
	@IBInspectable var shadowColor: UIColor? = .gray
	@IBInspectable var shadowOpacity: Float = 0.3
	
	override func layoutSubviews() {
		layer.cornerRadius = cornerRadius
		let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
		
		layer.masksToBounds = false
		layer.shadowColor = shadowColor?.cgColor
		layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
		layer.shadowOpacity = shadowOpacity
		layer.shadowPath = shadowPath.cgPath
		layer.shadowRadius = 2
	}
	
	func active(color: UIColor) {
		self.shadowOpacity = 0.7
		self.shadowColor = color
		self.layoutSubviews()
	}
	
	func inactive(color: UIColor) {
		self.shadowOpacity = 0.3
		self.shadowColor = color
		self.layoutSubviews()
	}
}

@IBDesignable
class CardButtonView: UIButton {
	
	@IBInspectable var cornerRadius: CGFloat = 10
	@IBInspectable var shadowOffsetWidth: Int = 0
	@IBInspectable var shadowOffsetHeight: Int = 0
	@IBInspectable var shadowColor: UIColor? = .gray
	@IBInspectable var shadowOpacity: Float = 0.3
	
	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = cornerRadius
		let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
		layer.masksToBounds = false
		layer.shadowColor = shadowColor?.cgColor
		layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
		layer.shadowOpacity = shadowOpacity
		layer.shadowPath = shadowPath.cgPath
		layer.shadowRadius = 5
	}
}
