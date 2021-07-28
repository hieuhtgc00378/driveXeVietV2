//
//  PBarButtonItem.swift
//  Supership
//
//  Created by Mac on 8/9/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import UIKit

extension UIView {
    
    func activeConstraint(_ format: String, options: NSLayoutConstraint.FormatOptions = [], metrics: [String : Any]? = nil, views: [String : Any]) {
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: format,
                                                         options: options,
                                                         metrics: metrics,
                                                         views: views)
        self.addConstraints(constraints)
    }
}

class PBarButtonItem: UIBarButtonItem {
    
    var badger: String?
    var badgeLabel: UILabel?
    var touchDown: ((_ buttonItem: UIBarButtonItem) -> ())?
    
    convenience init(title: String?, style: UIBarButtonItem.Style, actionHandler: ((_ buttonItem: UIBarButtonItem) -> ())?) {
        self.init(title: title, style: style, target: nil, action: nil)
        
        self.target = self
        self.action = #selector(touchDown(sender:))
        self.touchDown = actionHandler
    }
    
    func setBadge(_ number: Int) {
        guard let customView = self.customView else { return }
        
        if badgeLabel == nil {
            badgeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            badgeLabel?.layer.cornerRadius = 10
            badgeLabel?.layer.masksToBounds = true
            badgeLabel?.isUserInteractionEnabled = false
            badgeLabel?.backgroundColor = .red
            badgeLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            badgeLabel?.textAlignment = .center
            badgeLabel?.textColor = .white
            badgeLabel?.text = nil
            badgeLabel?.translatesAutoresizingMaskIntoConstraints = false
            badgeLabel?.minimumScaleFactor = 0.7
            badgeLabel?.adjustsFontSizeToFitWidth = true
            
            customView.addSubview(badgeLabel!)
            
            customView.activeConstraint("H:[badge(20)]-(-17)-|", views: [ "badge": badgeLabel! ])
            customView.activeConstraint("V:|-(-8)-[badge(20)]", views: [ "badge": badgeLabel! ])
        }
        
        if number > 99 {
            badgeLabel?.text = " \(99)+ "
        } else if number > 0 {
            badgeLabel?.text = "\(number)"
        } else {
            badgeLabel?.text = nil
        }
        
        badgeLabel?.isHidden = badgeLabel?.text == nil
    }
    
    // MARK: - Actions methods
    
    @objc func touchDown(sender: UIBarButtonItem) {
        touchDown?(sender)
    }
}
