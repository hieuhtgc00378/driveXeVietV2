//
//  NotificationHandle.swift
//  Paditech
//
//  Created by nhatquangz on 11/5/18.
//  Copyright © 2018 paditech. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SwiftMessages

typealias Action = () -> Void

class NotificationHandle {
    
    static let shared = NotificationHandle()
    
    private var notificationQueue: [[AnyHashable: Any]] = []
    
}


// MARK: - Control API
extension NotificationHandle {
    func process(userInfo: [AnyHashable : Any]) {
        self.handleNotification(userInfo: userInfo)
    }
    
    func processUserResponse(userInfo: [AnyHashable : Any]) {
        self.notificationQueue = [userInfo]
        /**
         Notify that there is a new notification
         If TabBarViewController was created, it would process the queued notification
         Else do nothing because user may be in splash screen
         **/
        NotificationCenter.default.post(name: .processQueueNotification, object: nil)
    }
    
    func processQueueNotification() {
        if let userInfo = notificationQueue.last {
            notificationQueue = []
            /**
             Handle navigate between viewcontrollers in app
             **/
            let data = JSON(userInfo)["custom"]["a"]
            let actionID = data["action_id"].intValue
            guard let notificationType = NotificationActionType(rawValue: actionID) else { return }
            switch notificationType {
            case .ACTION_NEW_COUPON:
                //AppCoordinator.shared.handle(target: "f_coupon")
                break
            default:
                break
            }
        }
    }
}



// MARK: - // MARK: - Palm Gate Process
extension NotificationHandle {
    enum NotificationActionType: Int {
        case UNKNOWN = 0
        
        case CANCEL = 3
        case AIRPOST = 1
        case BOOKING_FAST = 7
        case ACTION_NEW_COUPON = 70
        case BOOKING_FAST_END = 4
        case BOOKING_FAST_CANCEL = 6
    }
}

extension NotificationHandle {
    private func handleNotification(userInfo: [AnyHashable : Any]) {
        let data = JSON(userInfo)
        let actionID = data["custom"]["a"]["type"].intValue
        
        let notificationType = NotificationActionType(rawValue: actionID)
        
        /*
         guard let notificationType = NotificationActionType(rawValue: actionID) else {
         return
         }
         */
        
        switch notificationType {
        case .UNKNOWN:
            displayAlert(title: data["custom"]["a"]["title"].stringValue, message: data["custom"]["a"]["message"].stringValue, target: "", buttons: [ "OK" ])
            
            // show new booking
            // update state
            
            //            for i in AppCoordinator.shared.tabbarView.tabs {
            //                i.state.value = .inactive
            //            }
            //            AppCoordinator.shared.tabbarView.tabs[0].state.value = .active
            //
            //            if let tabbar = AppCoordinator.shared.navigationController.viewControllers[0] as? TabBarController {
            //                tabbar.selectedIndex = 0
            //            }
            
        case .AIRPOST:
            displayAlert(title: data["custom"]["a"]["title"].stringValue, message: data["custom"]["a"]["message"].stringValue, target: "", buttons: [ "OK" ])
            
        case .CANCEL:
            NotificationCenter.default.post(name: .bookingFastCancel, object: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.displayAlert(title: data["custom"]["a"]["title"].stringValue, message: data["custom"]["a"]["message"].stringValue, target: "", buttons: [ "OK" ])
            }
            
        case .ACTION_NEW_COUPON:
            NotificationCenter.default.post(name: .badgeUpdate, object: nil, userInfo: ["target": "f_coupon",
                                                                                        "state": true])
            NotificationCenter.default.post(name: .newCoupon, object: nil)
            displayAlert(title: data["custom"]["a"]["title"].stringValue, message: data["custom"]["a"]["message"].stringValue, target: "f_coupon", buttons: ["いいえ","はい"])
        case .BOOKING_FAST:
            let driverModel = DriverModel(fromJson: data["custom"]["a"]["driver"])
            AppCoordinator.shared.driverInfo.accept(driverModel)
        case .BOOKING_FAST_END:
            NotificationCenter.default.post(name: .bookingFastEnd, object: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.displayAlert(title: data["custom"]["a"]["title"].stringValue, message: data["custom"]["a"]["message"].stringValue, target: "", buttons: [ "OK" ])
            }
        default:
            displayAlert(title: data["custom"]["a"]["title"].stringValue, message: data["custom"]["a"]["message"].stringValue, target: "", buttons: [ "OK" ])
        }
    }
    
    
    /// Display alert if need
    ///
    /// - Parameters:
    ///   - data: notification info
    ///   - target: screen target
    ///   - buttons: button name, first action is close popup
    private func displayAlert(title: String, message: String,
                              target: String = "",
                              buttons: [String] = ["Cancel", "OK"]) {
        guard !message.isEmpty else { return }
        let doneAction: Action = { SwiftMessages.sharedInstance.hide() }
        //		if target != "" {
        //			let targetAction: Action = {
        //				SwiftMessages.sharedInstance.hide()
        //				//AppCoordinator.shared.handle(target: target)
        //			}
        //			AppMessagesManager.shared.alert(title: title,
        //											message: message,
        //											buttons: buttons,
        //											actions: [doneAction, targetAction])
        //		} else {
        AppMessagesManager.shared.alert(title: title,
                                        message: message,
                                        buttons: ["OK"], actions: [doneAction])
        //		}
    }
}


