//
//  WNoticeViews.swift
//  WeWorld
//
//  Created by NhatQuang on 12/11/17.
//  Copyright © 2017 Paditech. All rights reserved.
//

import Foundation
import UIKit
import SwiftMessages

class WNoticeViews: UIView, Identifiable {
	
	@IBOutlet var content: UIView!
	
    @IBOutlet weak var noticeTitle: UILabel!
    @IBOutlet weak var noticeMessage: UILabel!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!

    @IBOutlet weak var contentView: FView! {
        didSet {
            let layer = contentView.layer
            layer.shadowColor = UIColor.gray.cgColor
            layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            layer.shadowRadius = 6.0
            layer.shadowOpacity = 0.4
            layer.masksToBounds = false
        }
    }
	
	var id: String = String(Date().timeIntervalSince1970)
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	private func setup() {
		Bundle.main.loadNibNamed("WNoticeViews", owner: self, options: nil)
		addSubview(content)
		content.frame = self.bounds
	}
}


// MARK: - Setup
extension WNoticeViews {
	func config(viewModel: WNoticeViewModel) {
		self.noticeTitle.text = viewModel.title
		self.noticeMessage.text = viewModel.message
        
        self.noticeTitle.isHidden = viewModel.title.isEmpty
        self.noticeMessage.isHidden = viewModel.message.isEmpty
        
		self.leftButton.setTitle(viewModel.leftButton, for: .normal)
		self.rightButton.setTitle(viewModel.rightButton, for: .normal)
		self.rightButton.isHidden = viewModel.rightButtonAction == nil
		self.leftButton.isHidden = viewModel.leftButtonAction == nil
		self.rightButton.addTargetClosure { (_) in
			viewModel.rightButtonAction?()
		}
		self.leftButton.addTargetClosure { (_) in
			viewModel.leftButtonAction?()
		}
	}
}



