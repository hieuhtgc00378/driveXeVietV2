//
//  AppEnviroment.swift
//  kirindo
//
//  Created by NQZ on 7/1/19.
//  Copyright © 2019 Paditech Inc. All rights reserved.
//

import Foundation


extension AppEnvironment {
    func value<T>(for key: String) -> T {
        guard let value = Bundle.main.infoDictionary?[key] as? T else {
            fatalError("Invalid or missing Info.plist key: \(key)")
        }
        return value
    }
}

struct AppEnvironment {
    
    enum Environment: String {
        case development = "development"
        case staging = "staging"
        case product = "production"
    }
    
    static let shared = AppEnvironment()
    
    //set environment
    var current: Environment = .development
    
    // Link
    
    init() {
        /// Get current environment 
        let env: String = self.value(for: "APP_ENV")
        current = Environment(rawValue: env) ?? .development
    }
}


// MARK: - Service config
extension AppEnvironment.Environment {
    var baseURL: String {
        switch self {
        case .development:
            return "http://api.xeviet.net.vn"
        case .staging:
            return "http://api.xeviet.net.vn"
        case .product:
            return "http://api.xeviet.net.vn"
        }
        
        //test return "http://116.118.48.127:81"
    }
    
    var oneSignalKey: String {
        let appID: String = AppEnvironment.shared.value(for: "ONE_SIGNAL_ID")
        switch self {
        case .development:
            return appID
        case .staging:
            return appID
        case .product:
           return appID
        }
    }
    
    var webPath: String {
        switch self {
        case .development:
            return "http://eventmobi.paditech.com"
        case .staging:
            return "http://eventmobi.paditech.com"
        case .product:
            return "http://eventmobi.paditech.com"
        }
    }
    
}


/*
 OneSignalのステージング環境作成してます。
 "KIRINDO_STG
 OS_APP_ID=8054f03c-03cc-42fc-98d2-6011c546ebbd
 OS_REST_API_KEY=YTkzNGYwNDEtYWNhOC00NjU3LWJhYzktMzhjM2YwOWJlMzhk
 OS_USER_AUTH_KEY=YmEzMmRmZmItOTA1ZC00ZTA2LWE1MDgtMzQyNjliMTViOWE3"
 */
