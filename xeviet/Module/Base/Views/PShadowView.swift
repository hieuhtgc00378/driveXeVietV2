//
//  PShadowView.swift
//  Supership
//
//  Created by Mac on 9/19/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import UIKit

class PShadowView: UIView {
    
    var shadowView: UIView?
    var shadowRadius: CGFloat = 0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update shadowView frame when view layout
        if let shadowView = self.shadowView {
            if !shadowView.frame.equalTo(self.frame) {
                shadowView.frame = self.frame
                shadowView.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.shadowRadius).cgPath
            }
        }
    }
    
    func setRoundedShadow(radius: CGFloat) {
        // Check view can add shadow
        guard let mySupper = self.superview else { return }
        guard radius > 0 else { return }
        
        self.shadowRadius = radius
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = radius > 0
        
        // Init & config shadow
        self.shadowView = UIView()
        self.shadowView?.isUserInteractionEnabled = false
        self.shadowView?.layer.shadowColor = UIColor.black.cgColor
        self.shadowView?.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        self.shadowView?.layer.shadowOpacity = 0.16
        self.shadowView?.layer.shadowRadius = 4
        self.shadowView?.layer.shouldRasterize = true
        
        // Attach shadowView below current view if available
        mySupper.insertSubview(shadowView!, belowSubview: self)
    }
}




