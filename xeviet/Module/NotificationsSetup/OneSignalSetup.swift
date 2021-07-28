//
//  WOneSignalSetup.swift
//  WeWorld
//
//  Created by NhatQuang on 12/26/17.
//  Copyright © 2017 Paditech. All rights reserved.
//

import Foundation
import UIKit
import OneSignal
import RxCocoa
import RxSwift
import SwiftMessages

class OneSignalSetup: NSObject {
	
	static let shared = OneSignalSetup()
	let disposeBag = DisposeBag()
    
    // Save current OneSignal PlayerID
    var currentPlayerId: String?
	
	var launchOptions: [UIApplication.LaunchOptionsKey: Any]? {
		didSet {
			setup()
		}
	}
	
    func setup() {
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: true]
		let appID = AppEnvironment.shared.current.oneSignalKey
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: appID,
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.none
        OneSignal.add(self)
        
        // Update playerId for current user (if needed)
        self.currentPlayerId = OneSignal.getPermissionSubscriptionState().subscriptionStatus.userId
        self.checkAndUpdatePlayerID()
    }
}



// MARK: - Delegate
extension OneSignalSetup: OSSubscriptionObserver {
    func onOSSubscriptionChanged(_ stateChanges: OSSubscriptionStateChanges!) {
        print("[OneSignal] SubscriptionStateChange: \(String(describing: stateChanges))")
        
        if let playerID = stateChanges.to.userId {
            print("[OneSignal] Subscribed, PlayerID = \(playerID)")
            self.currentPlayerId = playerID
            sendPlayerID(playerID: playerID)
        }
    }
    
    func sendPlayerID(playerID: String) {
        // Check playerID is empty
        guard !playerID.isEmpty else {
            return
        }
        
        // Check user already logined
        guard let currentUser = AppManager.shared.user, let _ = AppManager.shared.accessToken else {
            return
        }
        
        // Check playerID already sent or different with saved on local
        let newHashPlayerID = "\(currentUser.id ?? 0)_\(playerID)"
        if let savedHash = AppManager.shared.savedPlayerId, savedHash == newHashPlayerID {
            return
        }
        
		let params: PARAM = [
            "playid": playerID,
            "token": AppManager.shared.accessToken ?? "",
            "os" : "iOS"
        ]
        
		MainServices.registerDevice(params)
			.subscribe(onNext: { result in
                switch result {
                case .success(_):
                    // Save playerId on local, for not update next time
                    AppManager.shared.savedPlayerId = newHashPlayerID
                    
                case .failure(_):
                    break
                }
			})
			.disposed(by: disposeBag)
	}
	
    // Check and update if latest playerId's different from saved playerId
    func checkAndUpdatePlayerID() {
        if let playerId = self.currentPlayerId {
            sendPlayerID(playerID: playerId)
        }
    }
    	
	func unRegister() {
		OneSignal.setSubscription(false)
	}
}





























