//
//  BaseViewModel.swift
//  bosty-ios
//
//  Created by quanarmy on 2/20/20.
//  Copyright © 2020 Tran Thanh Nhien. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import MBProgressHUD

enum ViewLoadingState: Int {
    case firstLoading = 1
    case successLoading = 2
    case errorLoading = 3
}

class BaseViewModel {
//    let loadingHud: bool = false
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    let myBag: DisposeBag = DisposeBag()
    
    // Message
    let successMessage = "SUCCESSFUL".localized()
    let failMessage = "SOMETHING_WRONG".localized()
    
    init() {
//        loadingHud.asDriver().drive(onNext: { isLoading in
//            isLoading ? loadingHud.show(animated: true) : loadingHud.hide(animated: true)
//        })
//        .disposed(by: myBag)
    }
}
