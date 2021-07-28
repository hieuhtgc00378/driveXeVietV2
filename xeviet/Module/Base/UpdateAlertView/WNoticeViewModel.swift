//
//  WNoticeViewModel.swift
//  Paditech
//
//  Created by nhatquangz on 6/17/19.
//  Copyright © 2019 paditech. All rights reserved.
//

import Foundation
import UIKit
import SwiftMessages

class WNoticeViewModel {
	
	enum NoticeType: Int {
		case recommendUpdate = 1
		case update = 2
	}
	
	var title: String = ""
	var message: String = ""
    var leftButton: String = "Cancel".localized()
    var rightButton: String = "OK".localized()
	
	var leftButtonAction: Action?
	var rightButtonAction: Action?
	
	init(type: NoticeType) {
		title = "お願い"
		message = {
			switch type {
			case .recommendUpdate:
				return "ご利用のアプリは古いバージョンです。最新版にバージョンアップすることを強く推奨します。アップデートしますか？"
			case .update:
				return "ご利用のアプリは古いバージョンです。最新版にバージョンアップしてください。"
			}
		}()
		if type == .recommendUpdate {
			leftButtonAction = {
				SwiftMessages.sharedInstance.hide()
			}
		}
		rightButtonAction = {
			// Go to store
			ExtentApplication.shared.openStore()
		}
	}
	
	init(title: String, message: String, buttons: [String], actions: [Action]) {
		self.title = title
		self.message = message
        leftButton = buttons[0]
        //rightButton = buttons[1]
        leftButtonAction = actions[0]
        //rightButtonAction = actions[1]
        
        if buttons.count == 1 && actions.count == 0 {
            leftButtonAction = {
                SwiftMessages.sharedInstance.hide()
            }
        }
	}
	
}
