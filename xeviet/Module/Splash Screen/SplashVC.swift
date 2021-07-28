//
//  SplashVC.swift
//  bosty-ios
//
//  Created by Tran Thanh Nhien on 12/16/19.
//  Copyright © 2019 Tran Thanh Nhien. All rights reserved.
//

import UIKit
import RxSwift

class SplashVC: UIViewController {
    
    var viewModel:SplashVM!
    
    let myBag = DisposeBag()

    init() {
        self.viewModel = SplashVM()
        super.init(nibName: "SplashVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRxData()
//        setupRxAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        UIView.animate(withDuration: 3, delay: 0, animations: {
//            self.progressView.setProgress(0.8, animated: true)
//        })
    }

    func setupRxData() {
        // Show login view when user authen view
//        viewModel.isRequiredLogin.asDriver()
//            .drive(onNext: { [weak self] isFailure in
//                AppDelegate.shared().appCoordinator.showLoginScreen()
//            })
//            .disposed(by: myBag)
    }
}

