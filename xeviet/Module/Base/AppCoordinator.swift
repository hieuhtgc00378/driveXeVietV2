//
//  AppCoordinator.swift
//  Supership
//
//  Created by Mac on 8/15/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import UIKit
import SafariServices
import AVKit
import RxCocoa
import RxSwift
import SideMenu

class AppCoordinator: Coordinator {
    // MARK: - Properties
    
    static let shared = AppCoordinator(window: UIWindow())
    
    let window: UIWindow
    var deviceAPNSToken : String = ""
    var start_address: String = ""
    let driverInfo = BehaviorRelay<DriverModel?>(value: nil)
    
    // MARK: - Coordibatir
    let myBag = DisposeBag()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        let splashVC = SplashVC()
        
        self.window.rootViewController = splashVC
        self.window.makeKeyAndVisible()
        
        //self.showMainScreen()

        // Navigation after app start 1 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showMainScreen()
        }
    }
    
    override func finish() {
        
    }
}


extension AppCoordinator {
    
    func callToDriver(driverNumber number: String) {
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func hiddenBottomBar(isHidden: Bool) {
        guard let tabbarController = self.window.rootViewController as? UITabBarController else { return }
        
        tabbarController.tabBar.isHidden = isHidden
    }
    
    func showLoginScreen() {
        let loginVC = XevietLoginVC()
        let naviVC = UINavigationController.init(rootViewController: loginVC)
        naviVC.navigationBar.isTranslucent = true
        naviVC.navigationBar.isHidden = true
        naviVC.navigationBar.setBackgroundImage(UIImage(), for: .default) //.init(named: "navi_bg")
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = true
        self.window.rootViewController = naviVC
    }
    

    func showMainScreen() {
        // Define the menus
        let homeVC = HomeVC()
        let naviVC = UINavigationController.init(rootViewController: homeVC)
        naviVC.navigationBar.isTranslucent = true
        naviVC.navigationBar.isHidden = true
        naviVC.navigationBar.setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = true
        self.window.rootViewController = naviVC
        print("show main screen")
        // Process queue notification
        NotificationHandle.shared.processQueueNotification()
    }
    
    func showMemberVC() {
        guard
            let tabController = self.window.rootViewController as? UITabBarController,
            let controllers = tabController.viewControllers,
            controllers.count >= 2
            else {
                return
        }
        
        tabController.selectedIndex = 2
    }
        
    func openAppBrowser(url: String) {
        guard let url = URL(string: url), UIApplication.shared.canOpenURL(url) else {
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        self.window.rootViewController?.present(safariVC, animated: true, completion: nil)
    }
    
    func openExternalBrowser(url: String) {
        guard let url = URL(string: url), UIApplication.shared.canOpenURL(url) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    func showBadgeIcon() {
//        UIApplication.shared.applicationIconBadgeNumber = PAppManager.shared.numberNotificationUnread
    }
    
    func showRandomNumberBadge() {
//        UIApplication.shared.applicationIconBadgeNumber = PAppManager.shared.numberNotificationUnread + 1
    }
    
    func playVideo(stringUrl: String) {
        let url = URL(string: stringUrl)!
        let player = AVPlayer(url: url)
        let vc = AVPlayerViewController()
        vc.player = player

        UIApplication.getTopViewController()?.navigationController?.present(vc, animated: true) { vc.player?.play() }
    }
    
}


extension UIApplication {

    class func getTopViewController(base: UIViewController? = AppDelegate.shared().appCoordinator.window.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
