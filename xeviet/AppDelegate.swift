//
//  AppDelegate.swift
//  Xe TQT
//
//  Created by eagle on 5/5/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Localize_Swift
import OneSignal
import GoogleMaps
import GooglePlaces
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow!
    var appCoordinator: AppCoordinator!
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.appCoordinator = AppCoordinator(window: self.window)
        self.appCoordinator.start()
        //          self.setupTimeZone()
        //          self.setupLanguage()
        
        
        // Push notification initialization
        // -----------------------------------------------------------------------------------------------------------------------------------------
        let authorizationOptions: UNAuthorizationOptions = [.sound, .alert, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: authorizationOptions, completionHandler: { _, error in
            if error == nil {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        })
        
        // -----------------------------------------------------------------------------------------------------------------------------------------
        // OneSignal initialization
        // -----------------------------------------------------------------------------------------------------------------------------------------
        //NotificationSetup.shared.registerNotification()
        
        // Setup Onesignal
        OneSignalSetup.shared.launchOptions = launchOptions
        
        if let opts = launchOptions {
            OneSignalSetup.shared.launchOptions = opts
        }
        
        // IQKeyboardManager initialization
        // -----------------------------------------------------------------------------------------------------------------------------------------
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "OK"
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        // GG MAPS
        GMSServices.provideAPIKey("AIzaSyC0dzfvvstD0an8jDoZKwK0-YUWXjZPVSY")
        GMSPlacesClient.provideAPIKey("AIzaSyC0dzfvvstD0an8jDoZKwK0-YUWXjZPVSY")
        
        FirebaseApp.configure()
        
        return true
    }
    
    static func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    //      func application(
    //          _ app: UIApplication,
    //          open url: URL,
    //          options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    //      ) -> Bool {
    //          LoginManager.shared.application(app, open: url)
    //          return ApplicationDelegate.shared.application(
    //              app,
    //              open: url,
    //              options: options
    //          )
    //      }
    /*
     func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
     // Pass device token to auth
     Auth.auth().setAPNSToken(deviceToken, type: .unknown)
     
     // Further handling of the device token if needed by the app
     // ...
     }
     
     
     func application(_ application: UIApplication,
     didReceiveRemoteNotification notification: [AnyHashable : Any],
     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
     if Auth.auth().canHandleNotification(notification) {
     completionHandler(.noData)
     return
     }
     // This notification is not auth related, developer should handle it.
     }
     */
    
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        if Auth.auth().canHandle(url) {
            return true
        }
        
        return false
        // URL not auth related, developer should handle it.
    }
    
    
}

