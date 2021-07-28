//
//  PromotionViewVM.swift
//  xeviet
//
//  Created by Tran Thanh Nhien on 6/10/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PromotionViewVM: BaseViewModel {
    let dataSource = BehaviorRelay<[PromotionCellVM]>(value: [])
    var pagingManager: PagingManager<PromotionCellVM>?
    
    override init() {
        super.init()
        
        self.pagingManager = PagingManager<PromotionCellVM>(dataSource: dataSource)
        
        /**
        Get event list
        **/
        pagingManager?.currentPage.asObservable()
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .flatMapLatest { [weak self] page -> Observable<Result<[PromotionModel], APIError>> in
                guard self != nil else { return Observable.empty() }
                return FastBookingServices.getPromotionList()//.trackActivity(self.loadingActivity)
            }
            .map { (try? $0.get()) ?? [] }
            .map { $0.map { PromotionCellVM(model: $0) } }
            .subscribe(onNext: { [weak self] newData in
                self?.pagingManager?.add(newData: newData)
            })
            .disposed(by: myBag)
        
        
    }
}
