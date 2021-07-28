//
//  SplashVM.swift
//  bosty-ios
//
//  Created by quanarmy on 2/20/20.
//  Copyright © 2020 Paditech, Inc. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class SplashVM: BaseViewModel {
    let getSliderAction = PublishSubject<Void>()
    let getUserInfoAction = PublishSubject<Void>()
    let registerTempAction = PublishSubject<Void>()
    let isRequiredLogin = BehaviorRelay<Bool>(value: false)
    
    override init() {
        super.init()
    }
    
 
}
