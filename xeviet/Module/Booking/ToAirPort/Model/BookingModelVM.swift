//
//  BookingModelVM.swift
//  Xe TQT
//
//  Created by Admin on 5/11/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BookingModelVM: BaseViewModel {
    let viewModel = BehaviorRelay<BookingModel>(value: BookingModel())
    let address_go = BehaviorRelay<String>(value: "")
    let address_deliver = BehaviorRelay<String>(value: "")
    let phone_passenger = BehaviorRelay<String>(value: "")
    let phone_driver = BehaviorRelay<String>(value: "")
    let name_passenger = BehaviorRelay<String>(value: "")
    let name_driver = BehaviorRelay<String>(value: "")
    let date = BehaviorRelay<String>(value: "")
    let time = BehaviorRelay<String>(value: "")
    let note_passenger = BehaviorRelay<String>(value: "")

    override init() {
           super.init()
           setupRx()
       }
       
    func setupRx() {
        
    }
}
