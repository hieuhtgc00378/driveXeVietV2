//
//  AppManager.swift
//  aisekigo
//
//  Created by NhatQuang on 6/27/18.
//  Copyright © 2018 Paditech. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import SwiftyJSON
import KeychainAccess

class AppManager {
	
	static let shared = AppManager()
	let myBag = DisposeBag()
    var selectedFoodId = 0
    
    var listAirPort = [Position]()
    var listCity = [Position]()
    var airPortPosition : Position?
    var airPortBackPosition : Position?
    var passengerBeginPosition : Position?
    var passengerEndPosition : Position?

	var user: UserInfo? {
		didSet {
            // Post notification update user info
            NotificationCenter.default.post(name: .updateUser, object: nil)
            
            // Update OneSignal PlayerID for push notification
            OneSignalSetup.shared.checkAndUpdatePlayerID()
        }
	}
	
	var accessToken: String? {
		didSet {
            PDefaults.set(accessToken, forKey: .accessToken)
		}
	}
    
    /// Saved One Signal Player ID (format: UserID_PlayerID)
    var savedPlayerId: String? {
        didSet {
            PDefaults.set(savedPlayerId, forKey: .savedPlayerId)
        }
    }
	
	var holidays: [Date] = []
	var deviceID: String
    
    let numberFormetter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter
    }()
	
	init() {
          accessToken = PDefaults.object(forKey: .accessToken) as? String
          print("Init accessToken: \(accessToken ?? "Empty")")
          let keychain = Keychain(service: "xeviet.net.vn")
          if let deviceID = keychain["device-id"] {
              self.deviceID = deviceID
          } else {
              deviceID = UIDevice.current.identifierForVendor?.uuidString ?? ""
              keychain["device-id"] = deviceID
          }
          print("Device ID: \(deviceID)")
    }
	
	func reset() {
        user = nil
		accessToken = nil
        PDefaults.removeObject(forKey: .accessToken)
	}
}






























