//
//  NotificationName.swift
//  Paditech
//
//  Created by nhatquangz on 5/27/19.
//  Copyright © 2019 paditech. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Define notification name
extension Notification.Name {

	static let updateUser = Notification.Name(rawValue: "NOTIFY_UPDATE_USER")
	
	static let badgeUpdate = Notification.Name(rawValue: "badgeUpdate")
	
	static let activeTab = Notification.Name(rawValue: "TabBarViewController.avtive.tab")
	
	static let updateUserName = Notification.Name(rawValue: "Menu.Name.Update")
	
	static let updateSocial = Notification.Name(rawValue: "Menu.Social.Update")
	
	static let newCoupon = Notification.Name(rawValue: "ACTION_NEW_COUPON")
	
	static let newNotice = Notification.Name(rawValue: "ACTION_NEW_INFO")
	
	static let processQueueNotification = Notification.Name(rawValue: "processQueueNotification")
    
    static let bookingFastEnd = Notification.Name(rawValue: "BOOKING_FAST_END")
    static let bookingFastCancel = Notification.Name(rawValue: "BOOKING_FAST_CANCEL")


}

