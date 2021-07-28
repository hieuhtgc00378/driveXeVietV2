//
//  PConstants.swift
//  Supership
//
//  Created by Mac on 8/10/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import Foundation
import UIKit

// MARK: CompletionHandler
typealias CompletionHandler = (Bool, Int, Any?) -> ()

// MARK: Standard UserDefault
public let userDefaults = UserDefaults.standard
public let kDeviceToken = "kDeviceToken"
public let kAccessToken = "kAccessToken"
public let kDeviceUUID = "kDeviceUUID"
public let kVendorDeviceUUID = "kVendorDeviceUUID"

// MARK: Device Constant
public let SCREEN_WIDTH = UIScreen.main.bounds.size.width
public let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
public let OS_VERSION = UIDevice.current.systemVersion

// MARK: - Public Constants and Function
public let kTimeoutRequest = TimeInterval(30)
public let kImageQualityUpload = CGFloat(0.7)
public let kImageSizeUpload = CGFloat(640)

// MARK: Notification
public let kLoginNotification       = "kLoginNotification"
public let kLogoutNotification      = "kLogoutNotification"

// MARK: Third key
public let kPlacesAPIKey = "AIzaSyDNaxV6tecldXTshO0Gf2ZbcMbLhh_Uk0k"
public let kGoogleMapKey = "AIzaSyAU-vt-Xf9gYBAvYQnhJq5YGEdSb1D_mjU" //jp
//public let kGoogleMapKey = "AIzaSyDto8zK6Ze-Fvo7JRps02p1qMvO2daNX94" // paditech
public let kPlacesSearchAPIKey = "AIzaSyDNaxV6tecldXTshO0Gf2ZbcMbLhh_Uk0k"
public let GoogleNearBySearchUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
public let kOneSignalUserKey = "kOneSignalUserKey"
//public let oneSignalUserKey = "N2RhZjg3YmItNjJmNi00NGMyLWEwYzUtZTQ5YzliOGRkZGNl" // patditech
public let oneSignalUserKey = "YmEzMmRmZmItOTA1ZC00ZTA2LWE1MDgtMzQyNjliMTViOWE3" // stg
// MARK: Local string function

// MARK: Twitter
public let kTwitterSecret = "XydhorjyxUbnSVI6ODJtixHHn2zqExMdgLThk9gnQdnQNsr2VE"
public let kGoogleClientId = "612290569656-7371c9ss80hfhrljfk5l8kbishhhenvt.apps.googleusercontent.com"

func LANGTEXT(key: String)-> String {
    return key
}
