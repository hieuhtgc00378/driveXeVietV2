//
//  CountriesRouteModel.swift
//  Xe TQT
//
//  Created by Admin on 5/21/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
class CountriesRouteVM{
    var model: CountriesRoute?
    var routeName = BehaviorRelay<String>(value: "")
    let toPlace = BehaviorRelay<String>(value: "")
    var descript = BehaviorRelay<String>(value: "")
    var discount = BehaviorRelay<Int>(value: 0) //-50%
    var price = BehaviorRelay<Int>(value: 0)
    var price_old = BehaviorRelay<Int>(value: 0)
    var phone = BehaviorRelay<String>(value: "")
    var vehicleType = BehaviorRelay<String>(value: "")
    
    init(model: CountriesRoute) {
        self.model = model
        self.routeName.accept(model.routeName)
        self.toPlace.accept(model.placeEndName)
        self.descript.accept(model.descript)
        self.discount.accept(model.discount)
        self.price.accept(model.price)
        self.price_old.accept(model.price_old)
        self.phone.accept(model.phone)
        self.vehicleType.accept(model.vehicleType.getString())
    }
}


