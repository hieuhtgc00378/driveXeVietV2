//
//  NotificationSetup.swift
//  Paditech
//
//  Created by nhatquangz on 11/5/18.
//  Copyright © 2018 paditech. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationSetup: NSObject {
	
	static let shared = NotificationSetup()
	
	func registerNotification() {
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
			guard granted else { return }
			self.getNotificationSettings()
		}
	}
	
	private func getNotificationSettings() {
		UNUserNotificationCenter.current().getNotificationSettings { (settings) in
			print("Notification settings: \(settings)")
			guard settings.authorizationStatus == .authorized else { return }
			UNUserNotificationCenter.current().delegate = self
			DispatchQueue.main.async {
				UIApplication.shared.registerForRemoteNotifications()
			}
		}
	}
}


// MARK: - Present nofication
extension NotificationSetup: UNUserNotificationCenterDelegate {
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		let userInfo = notification.request.content.userInfo
		print(userInfo)
		NotificationHandle.shared.process(userInfo: userInfo)
		print("willPresent notification: UNNotification")
		completionHandler([])
	}
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		let userInfo = response.notification.request.content.userInfo
        NotificationHandle.shared.process(userInfo: userInfo)
		//NotificationHandle.shared.processUserResponse(userInfo: userInfo)
		print("didReceive response: UNNotificationResponse")
		completionHandler()
	}
}


// MARK: - App Delegate
extension AppDelegate {
	/// Register
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		let tokenParts = deviceToken.map { data -> String in
			return String(format: "%02.2hhx", data)
		}
		let token = tokenParts.joined()
		print("APNS Device Token: \(token)")
	}
	
	func application(_ application: UIApplication,
					 didFailToRegisterForRemoteNotificationsWithError error: Error) {
		//print("Failed to register: \(error)")
	}
	
	// Handle remote notification background
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
		print("didReceiveRemoteNotification userInfo:")
		print(userInfo)
		NotificationHandle.shared.process(userInfo: userInfo)
		DispatchQueue.main.asyncAfter(deadline: .now()) {
			completionHandler(.newData)
		}
	}
}

