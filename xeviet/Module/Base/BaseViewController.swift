//
//  BaseViewController.swift
//  Xe TQT
//
//  Created by eagle on 5/5/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import UIKit
import UIKit
import RxSwift
import RxCocoa
import SideMenu
import MBProgressHUD
import Localize_Swift
import Kingfisher
import IQKeyboardManagerSwift
import SnapKit

class BaseViewController: UIViewController {
    var isShowBackBtn: Bool = true
    var isShowNotificationBtn: Bool = true
    @IBOutlet var contentView: UIView?
    public var imv_background: UIImageView!
    public var myScrollView: UIScrollView?
    public var isAllowSwipeBack: Bool = true
    
    fileprivate let myBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupBackgroundImage()
        self.makeContentViewScrollable()
        
        self.showNoticeButton(badge: 10)
        self.configBackButton()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // Default Use status bar lightContent
       override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent
       }
       
       // Default show status bar
       override var prefersStatusBarHidden: Bool {
           return false
       }

    func setupBackgroundImage(){
        let imv_bg = UIImageView.init(image: UIImage.init(named: "background"))
        // Add contentView
        self.view.insertSubview(imv_bg, at: 0)
        
        // Layout view
          imv_bg.snp.makeConstraints { make in
              make.top.equalTo(topLayoutGuide.snp.bottom)
              make.bottom.equalToSuperview()
              make.width.equalToSuperview()
              make.centerX.equalToSuperview()
          }
        
          imv_bg.snp.makeConstraints { make in
             make.edges.equalToSuperview()
             make.width.equalToSuperview()
             make.height.equalTo(1024)
          }
        
        self.imv_background = imv_bg
    }
    
    func makeContentViewScrollable(showIndicator: Bool = false) {
           guard let contentView = self.contentView else {
               return
           }
           
           // Setup scrollView
           let scrollView = UIScrollView()
           scrollView.showsVerticalScrollIndicator = showIndicator
           scrollView.showsHorizontalScrollIndicator = showIndicator
           
           // Add contentView
           self.view.insertSubview(scrollView, at: 1)
           scrollView.addSubview(contentView)
           
           // Layout view
           scrollView.snp.makeConstraints { make in
               make.top.equalTo(topLayoutGuide.snp.bottom)
               make.bottom.equalToSuperview()
               make.width.equalToSuperview()
               make.centerX.equalToSuperview()
           }
           
           contentView.snp.makeConstraints { make in
               make.edges.equalToSuperview()
               
               // only vertical scroll
               make.width.equalToSuperview()
               
               // only horizontal scroll
               //make.height.equalToSuperview()
           }
           
           self.myScrollView = scrollView
       }
    
    func configBackButton(){
        if self.isShowBackBtn{
            let cusView = UIView.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            let btnBack = UIButton.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
            btnBack.setImage(UIImage.init(named: "ic_back"), for: .normal)
            btnBack.addTarget(self, action: #selector(popVC), for: .touchUpInside)
            cusView.addSubview(btnBack)
            btnBack.frame = cusView.bounds
            self.navigationItem.backBarButtonItem = UIBarButtonItem(customView: cusView)
        }else{
            self.navigationItem.hidesBackButton = true
        }
        self.view.layoutIfNeeded()
    }
    
    @objc func popVC(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func showNoticeButton(badge: Int) {
           if self.isShowNotificationBtn{
               let cusView = UIView.init(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
               let noticeButton = NoticeButton(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
                   noticeButton.setImage(UIImage(named: "icon_bell"), for: .normal)
                   noticeButton.imageView?.contentMode = .scaleAspectFit
                   noticeButton.addTarget(self, action: #selector(noticeButton_Clicked(_:)), for: .touchUpInside)
                 if badge > 0{
                     noticeButton.badge = badge
                 }else{
                     noticeButton.badge = badge
                 }
            
                cusView.addSubview(noticeButton)
                noticeButton.frame = cusView.bounds
//                self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cusView)
            
                let alertBarItem = UIBarButtonItem(customView: cusView)

                let currWidth = alertBarItem.customView?.widthAnchor.constraint(equalToConstant: 34)
                currWidth?.isActive = true
                let currHeight = alertBarItem.customView?.heightAnchor.constraint(equalToConstant: 34)
                currHeight?.isActive = true
            
                self.navigationItem.rightBarButtonItem = alertBarItem

           }else{
               self.navigationItem.rightBarButtonItem = nil
           }
       }

    //button action
      @objc func noticeButton_Clicked(_ button: UIButton) {
            // Don't show notice when user not logined
    //        if !PAppManager.shared.isLogined {
    //            return
    //        }
    //
            // Show controller
//            let noticeListVC = NotificationVC()
//            noticeListVC.hidesBottomBarWhenPushed = true
//    //        self.navigationController?.pushViewController(noticeListVC, animated: true)
//    //        self.tabBarController?.selectedIndex = 0
//            let naviVC = UINavigationController.init(rootViewController: noticeListVC)
//            self.tabBarController?.present(naviVC, animated: true, completion: nil)
        }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
