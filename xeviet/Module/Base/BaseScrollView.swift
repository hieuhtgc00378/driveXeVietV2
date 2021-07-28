//
//  BaseScrollView.swift
//  Stamp
//
//  Created by nhatquangz on 4/9/19.
//

import Foundation
import UIKit
import SnapKit

class BaseScrollView: UIScrollView {
    
	convenience init(contentView: UIView, axis: NSLayoutConstraint.Axis = .vertical) {
        self.init()
		self.layout(contentView: contentView, axis: axis)
		setContentCompressionResistancePriority(UILayoutPriority(rawValue: 999), for: .vertical)
    }
	
	override func layoutSubviews() {
		super.layoutSubviews()
		invalidateIntrinsicContentSize()
	}
	
	override var intrinsicContentSize: CGSize {
		let width = SCREEN_WIDTH
		let maxHeight = SCREEN_HEIGHT * 0.35 + 100
		let height = self.contentSize.height > maxHeight ? maxHeight : self.contentSize.height
//		print("New size: \(CGSize(width: width, height: height))")
		return CGSize(width: width, height: height)
	}
	
    func layout(contentView: UIView,
				axis: NSLayoutConstraint.Axis = .vertical,
				customLayout: ((ConstraintMaker) -> Void)? = nil) {
		self.clipsToBounds = true
        let containerView = UIView()
        self.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            if axis == .vertical {
                $0.width.equalToSuperview()
				$0.height.greaterThanOrEqualToSuperview()
            } else {
                $0.height.equalToSuperview()
            }
        }
        containerView.addSubview(contentView)
        contentView.snp.makeConstraints {
			if let customLayout = customLayout {
				customLayout($0)
			} else {
				$0.edges.equalToSuperview()
			}
        }
    }
}
