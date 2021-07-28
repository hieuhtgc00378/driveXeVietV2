//
//  PromotionCellVM.swift
//  xeviet
//
//  Created by Tran Thanh Nhien on 6/10/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class PromotionCellVM {
    
    var model: PromotionModel
    let title = BehaviorRelay<String>(value: "")
    let desc = BehaviorRelay<String>(value: "")
    let type = BehaviorRelay<Int>(value: 0)
    let promotionValue = BehaviorRelay<String>(value: "")
    
    init(model: PromotionModel) {
        self.model = model
        title.accept(model.title)
        desc.accept(model.description)
        if model.type == 2 {
            self.promotionValue.accept("\(model.percentDiscount)%")
        } else {
            if let amountDiscount = model.amountDiscount {
                self.promotionValue.accept("\(amountDiscount)VNĐ")
            }
        }
    }
}
