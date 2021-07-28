//
//  NoticeButton.swift
//  bosty-ios
//
//  Created by Tran Thanh Nhien on 12/18/19.
//  Copyright © 2019 Tran Thanh Nhien. All rights reserved.
//

import Foundation
import UIKit

class NoticeButton: UIButton {
    
    var badgeLabel = PLabel()
    
    var badge: Int? {
        didSet {
            self.addBadgeToButton(badge: badge)
        }
    }
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           addBadgeToButton(badge: 0)
       }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addBadgeToButton(badge: 0)
        fatalError("init(coder:) has not been implemented")
    }
    
    func addBadgeToButton(badge: Int?) {
        self.badgeLabel = PLabel(frame: CGRect(x: 0, y: 0, width: 16, height: 16))
        self.badgeLabel.text = String(badge ?? 0)
        self.badgeLabel.textColor = .white
        self.badgeLabel.backgroundColor = .red
        self.badgeLabel.font = UIFont.systemFont(ofSize: 10)
        self.badgeLabel.sizeToFit()
        self.badgeLabel.textAlignment = .center
        self.badgeLabel.cornerCircle = true
        self.badgeLabel.layer.masksToBounds = true
        addSubview(self.badgeLabel)
        self.badgeLabel.snp.makeConstraints { (make) in
            make.width.height.equalTo(16)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(8)
        }
        self.badgeLabel.isHidden = badge == 0
    }
}
