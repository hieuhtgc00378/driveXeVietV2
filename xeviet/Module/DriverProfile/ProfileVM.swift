//
//  ProfileVM.swift
//  Driver-iOS
//
//  Created by Tran Thanh Nhien on 7/1/20.
//  Copyright © 2020 Tran Thanh Nhien. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import SwiftyJSON

class ProfileVM: BaseViewModel {
    let getInfoAction = PublishSubject<Void>()
    let isRequiredLogin = BehaviorRelay<Bool>(value: false)
    
    let driverModel = BehaviorRelay<DriverModel?>(value: nil)
    let dataSource = BehaviorRelay<[String]>(value: [])
    
    
    init(driverModel: DriverModel) {
        super.init()
        
        self.driverModel.accept(driverModel)
        /*
        // getUserInfo
        getInfoAction.asObserver()
            .flatMapLatest({ [weak self] () -> Observable<Result<UserModel, APIError>> in
                guard let self = self else { return Observable.empty() }
                
                return UserServices.userInfo().trackActivity(self.loadingActivity)
            })
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let userModel):
                    // Update current user
                    AppManager.shared.currentUser = userModel
                    self?.driverModel.accept(userModel)
                    break
                    
                case .failure(let error):
                    MessagesManager.shared.showMessage(.error, message: error.message)
                    self?.isRequiredLogin.accept(true)
                    break
                }
            })
            .disposed(by: myBag)
        
        self.getInfoAction.onNext(())
 */
    }
    
}

