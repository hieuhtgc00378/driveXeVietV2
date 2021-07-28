//
//  PLoadingActivity.swift
//  Supership
//
//  Created by Mac on 8/9/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class PLoadingActivity {
    
    static let shared = PLoadingActivity()
    
    init() {
        NVActivityIndicatorView.DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD = 1000
    }
    
    func show(type: NVActivityIndicatorType = .ballScaleMultiple, message: String? = nil, thresholdTime: Int = 0, autoHide: Bool = true) {
        let font = UIFont.systemFont(ofSize: 15)
        let activityData = ActivityData(message: message, messageFont: font, type: type, textColor: nil)
        NVActivityIndicatorView.DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD = thresholdTime
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
        if autoHide {
            DispatchQueue.main.asyncAfter(deadline: .now() + kTimeoutRequest) {
                self.hide()
            }
        }
    }
    
    func showLoadding(type: NVActivityIndicatorType = .ballScaleMultiple, message: String? = nil, thresholdTime: Int = 0, autoHide: Bool = true, completed: ((Bool) -> Void)?) {
        let font = UIFont.systemFont(ofSize: 15)
        let activityData = ActivityData(message: message, messageFont: font, type: type, textColor: nil)
        NVActivityIndicatorView.DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD = thresholdTime
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
        if autoHide {
            DispatchQueue.main.asyncAfter(deadline: .now() + kTimeoutRequest) {
                self.hide()
                completed?(true)
            }
        }
    }
    
    func updateMessage(newMessage: String) {
        NVActivityIndicatorPresenter.sharedInstance.setMessage(newMessage)
    }
    
    func hide() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }
    
    func isLoading() -> Bool{
        return NVActivityIndicatorPresenter.sharedInstance.isAnimating
    }
    
}









