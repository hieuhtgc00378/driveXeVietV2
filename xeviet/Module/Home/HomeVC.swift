//
//  HomeVC.swift
//  Xe TQT
//
//  Created by eagle on 5/5/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import UIKit
import SideMenu
import RxCocoa
import RxSwift
//import ImageSlideshow
import SafariServices
class HomeVC: BaseViewController {
    
    @IBOutlet weak var lb_top: UILabel!
    @IBOutlet weak var sliderView: MediaSlider!
    // @IBOutlet weak var slideshow: ImageSlideshow!
    //var images = [ImageSource(image: UIImage.init(named: "bg_stack_1")!), ImageSource(image: UIImage.init(named: "bg_stack_2")!), ImageSource(image: UIImage.init(named: "bg_stack_3")!), ImageSource(image: UIImage.init(named: "bg_stack_4")!), ImageSource(image: UIImage.init(named: "bg_stack_5")!)]
    
    var myBag = DisposeBag()
    // MARK: - Init
    init() {
        super.init(nibName: "HomeVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createSideMenu()
        self.setupSlideShow()
        
        self.getUserInfo()
        self.checkBooking()
        // Do any additional setup after loading the view.
    }
    
    func setupSlideShow(){
        
        let images = ["bg_stack_2", "bg_stack_3", "bg_stack_4", "bg_stack_5"]
        
        self.sliderView.config(data: images, sourceType: .local)
        self.sliderView.autoPlay()
        self.sliderView.itemSelected = { item in
            self.tapBanner()
        }
    }
    
    func tapBanner(){
        let webVC = SFSafariViewController.init(url: URL.init(string: "http://www.xeviet.net.vn")!)
        self.present(webVC, animated: true, completion: nil)
    }
    
    func createSideMenu(){
        let menuVC = SideMenuVC()
        var settings:SideMenuSettings = SideMenuSettings()
        settings.menuWidth = SCREEN_WIDTH - 100
        settings.blurEffectStyle = .dark
        settings.animationOptions = .curveEaseIn
        let leftMenuNavigationController = SideMenuNavigationController.init(rootViewController: menuVC, settings: settings)
        SideMenuManager.default.leftMenuNavigationController = leftMenuNavigationController
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        leftMenuNavigationController.statusBarEndAlpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // AppManager.shared.getAppInfos()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.isHidden = true
        self.updateTopLabel()
        
    }
    
    func updateTopLabel(){
        if let user = AppManager.shared.user{
            if let name:String? = user.user_name{
                self.lb_top.text = "\("Hello".localized())\n\(name)"
            }
        }
    }
    
    //Button Action
    @IBAction func on_booking_airport(_ sender: Any) {
        guard AppManager.shared.accessToken != nil else {
            AppManager.shared.reset()
            AppDelegate.shared().appCoordinator.showLoginScreen()
            return
        }
        let pickRouteAirportVC = PickRouteAirportVC()
        pickRouteAirportVC.isShowBackBtn = true
        self.navigationController?.pushViewController(pickRouteAirportVC, animated: true)
    }
    
    @IBAction func on_booking_contries(_ sender: Any) {
        guard AppManager.shared.accessToken != nil else {
            AppManager.shared.reset()
            AppDelegate.shared().appCoordinator.showLoginScreen()
            return
        }
        
        let bookingCountriesStep1 = BookingCountriesStep1()
        bookingCountriesStep1.isShowBackBtn = true
        self.navigationController?.pushViewController(bookingCountriesStep1, animated: true)
    }
    
    @IBAction func on_history(_ sender: Any) {
        guard AppManager.shared.accessToken != nil else {
            AppManager.shared.reset()
            AppDelegate.shared().appCoordinator.showLoginScreen()
            return
        }
        
        let historyVC = HistoryVC()
        self.navigationController?.pushViewController(historyVC, animated: true)
    }
    
    @IBAction func on_deal(_ sender: Any) {
        guard AppManager.shared.accessToken != nil else {
            AppManager.shared.reset()
            AppDelegate.shared().appCoordinator.showLoginScreen()
            return
        }
        
        let couponVC = CouponVC()
        self.navigationController?.pushViewController(couponVC, animated: true)
    }
    
    @IBAction func on_share(_ sender: Any) {
        guard AppManager.shared.accessToken != nil else {
            AppManager.shared.reset()
            AppDelegate.shared().appCoordinator.showLoginScreen()
            return
        }
        
        let shareViewController = ShareViewController()
        shareViewController.isShowBackBtn = true
        self.navigationController?.pushViewController(shareViewController, animated: true)
    }
    
    @IBAction func on_booking_now(_ sender: Any) {
        guard AppManager.shared.accessToken != nil else {
            AppManager.shared.reset()
            AppDelegate.shared().appCoordinator.showLoginScreen()
            return
        }
        
        let viewModel = MapViewVM(bookingID: 0, isLookingDriver: false)
        let mapVC = MapViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    @IBAction func on_menu(_ sender: Any) {
        present(SideMenuManager.default.leftMenuNavigationController!, animated: true, completion: nil)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func btnNotificationClicked(_ sender: Any) {
        guard AppManager.shared.accessToken != nil else {
            AppManager.shared.reset()
            AppDelegate.shared().appCoordinator.showLoginScreen()
            return
        }
        
        let notificationController = NotifiVC()
        self.navigationController?.pushViewController(notificationController, animated: true)
    }
}


extension HomeVC {
    /// get user info
    func getUserInfo() {
        MainServices.getUserInfo().asObservable()
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let userInfo):
                    AppManager.shared.user = userInfo
                    self?.updateTopLabel()
                case .failure(let error):
                    //                    AppMessagesManager.shared.showMessage(messageType: .error, message: error.message)
                    break
                }
            })
            .disposed(by: myBag)
    }
    
    func checkBooking() {
        FastBookingServices.checkBooking().asObservable()
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let id):
                    if id != 0 {
                        let viewModel = MapViewVM(bookingID: id, isLookingDriver: true)
                        let mapVC = MapViewController(viewModel: viewModel)
                        self?.navigationController?.pushViewController(mapVC, animated: true)
                    }
                case .failure(let error):
                    break
                    //AppMessagesManager.shared.showMessage(messageType: .error, message: error.message)
                }
            })
            .disposed(by: myBag)
    }
}
