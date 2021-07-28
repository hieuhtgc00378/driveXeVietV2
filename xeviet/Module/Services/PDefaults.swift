//
//  PDefaults.swift
//  VietLib
//
//  Created by Gio Viet on 2/12/19.
//  Copyright © 2019 Paditech Inc. All rights reserved.
//

import UIKit
import Localize_Swift

enum BookingType : Int, CaseIterable{
    case airport = 1
    case province = 2
    case airport_back = 3
    case fast = 4
    
    func getTitleString() -> String {
        switch self {
        case.airport:
            return "BOOKING_AIRPORT".localized()
        case .province:
            return "BOOKING_COUNTRY".localized()
        case .airport_back:
            return "BOOKING_AIRPORT_BACK".localized()
        case .fast:
            return "BOOKING_NOW".localized()
        }
    }
}

extension PDefaults {

    enum Keys: String {
        // User finish tutorial
        case isTutorialComplete

        // Authentication token
        case accessToken

        // OneSignal
        case savedPlayerId
        //device id
        case deviceID
        
        case userName
        case userId
        case userEmail
        case userPassword
        case isLogined
    }
}

struct PDefaults {

    static let SETTINGS = UserDefaults.standard

    static func set(_ object: Any?, forKey key: PDefaults.Keys) {
        if let value = object {
            SETTINGS.set(value, forKey: key.rawValue)
        } else {
            SETTINGS.removeObject(forKey: key.rawValue)
        }
    }

    static func get(_ key: PDefaults.Keys) -> Any? {
        return SETTINGS.object(forKey: key.rawValue)
    }

    //
    static func integer(forKey key: PDefaults.Keys) -> Int {
        return SETTINGS.integer(forKey: key.rawValue)
    }

    static func integer(forKey key: PDefaults.Keys, default defValue: Int) -> Int {
        if let value = SETTINGS.object(forKey: key.rawValue) as? NSNumber {
            return value.intValue
        }

        return defValue
    }

    //
    static func double(forKey key: PDefaults.Keys) -> Double {
        return SETTINGS.double(forKey: key.rawValue)
    }

    static func double(forKey key: PDefaults.Keys, default defValue: Double) -> Double {
        if let value = SETTINGS.object(forKey: key.rawValue) as? NSNumber {
            return value.doubleValue
        }

        return defValue
    }

    //
    static func string(forKey key: PDefaults.Keys) -> String? {
        return SETTINGS.string(forKey:key.rawValue)
    }

    static func string(forKey key: PDefaults.Keys, default defValue: String) -> String {
        if let value = SETTINGS.string(forKey:key.rawValue) {
            return value
        }

        return defValue
    }

    //
    static func bool(forKey key: PDefaults.Keys) -> Bool {
        return SETTINGS.bool(forKey: key.rawValue)
    }
    
    static func bool(forKey key: PDefaults.Keys, default defValue: Bool) -> Bool {
        if let value = SETTINGS.object(forKey: key.rawValue) as? Bool {
            return value
        }
        
        return defValue
    }

    // Object
    static func object(forKey key: PDefaults.Keys) -> Any? {
        return SETTINGS.object(forKey: key.rawValue)
    }

    //
    static func removeObject(forKey key: PDefaults.Keys) {
        SETTINGS.removeObject(forKey: key.rawValue)
    }

    
}
