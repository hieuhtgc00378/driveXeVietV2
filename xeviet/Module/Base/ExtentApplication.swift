//
//  ExtentApplication.swift
//  htxviet
//
//  Created by NhatQuang on 8/28/18.
//  Copyright © 2018 nhatquang. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
//import CoreLocation

class ExtentApplication: NSObject {
	
	static let shared = ExtentApplication()

}

// MARK: - Message
extension ExtentApplication: MFMessageComposeViewControllerDelegate {
	func sendMessage(phone: String, fromViewController viewController: UIViewController) {
		guard MFMessageComposeViewController.canSendText() else { return }
		let messageVC = MFMessageComposeViewController()
		messageVC.recipients = [phone]
		messageVC.messageComposeDelegate = self
		viewController.present(messageVC, animated: false, completion: nil)
	}
	
	internal func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
		switch (result.rawValue) {
		case MessageComposeResult.cancelled.rawValue:
			print("Message was cancelled")
			controller.dismiss(animated: true, completion: nil)
		case MessageComposeResult.failed.rawValue:
			print("Message failed")
			controller.dismiss(animated: true, completion: nil)
		case MessageComposeResult.sent.rawValue:
			print("Message was sent")
			controller.dismiss(animated: true, completion: nil)
		default:
			break
		}
	}
}


// MARK: - Call
extension ExtentApplication {
	func call(to phone: String) {
		if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
			if #available(iOS 10, *) {
				UIApplication.shared.open(url)
			} else {
				UIApplication.shared.openURL(url)
			}
		}
	}
}

// MARK: - Messenger
extension ExtentApplication {
	func messenger(toUser userID: String) {
		if let url = URL(string: "fb-messenger://user-thread/\(userID)") {
			// Attempt to open in Messenger App first
			UIApplication.shared.open(url, options: [:], completionHandler: {
				(success) in
				if success == false {
					// Messenger is not installed. Open in browser instead.
					let url = URL(string: "https://m.me/\(userID)")
					if UIApplication.shared.canOpenURL(url!) {
						UIApplication.shared.open(url!)
					}
				}
			})
		}
	}
}

// MARK: - Zalo
extension ExtentApplication {
	func zaloMessage(toUser phone: String) {
		if let url = URL(string: "http://zalo.me/\(phone)") {
			if UIApplication.shared.canOpenURL(url) {
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
			}
		}
	}
}


// MARK: - Open Map
//extension ExtentApplication {
//	func navigate(toLocation destination: CLLocation) {
//		// Try google map first
//		if !routeInGoogleMap(destination: destination) {
//			// Try Apple Map
//			_ = routeInAppleMap(destination: destination )
//		}
//	}
//
//	private func routeInGoogleMap(destination: CLLocation) -> Bool {
//		let stringURL = "comgooglemaps://?saddr=&daddr=\(destination.coordinate.latitude),\(destination.coordinate.longitude)&directionsmode=driving"
//		let googleMapURL = URL(string:"comgooglemaps://")
//		if let mapURL = googleMapURL, UIApplication.shared.canOpenURL(mapURL), let destinationURL = URL(string: stringURL) {
//			UIApplication.shared.openURL(destinationURL)
//			return true
//		} else {
//			return false
//		}
//	}
//
//	private func routeInAppleMap(destination: CLLocation) -> Bool {
//		let stringURL = "http://maps.apple.com/?saddr=&daddr=\(destination.coordinate.latitude),\(destination.coordinate.longitude)"
//		if let url = URL(string: stringURL) {
//			UIApplication.shared.openURL(url)
//			return true
//		}
//		return false
//	}
//}


// MARK: - Open AppStore
extension ExtentApplication {
	func openStore() {
		let appID = "kAppStoreID"
		if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(appID)"),
			UIApplication.shared.canOpenURL(url)
		{
			if #available(iOS 10.0, *) {
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
			} else {
				UIApplication.shared.openURL(url)
			}
		}
	}
}

















