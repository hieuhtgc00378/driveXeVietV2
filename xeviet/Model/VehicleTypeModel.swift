//
//  VehicleTypeModel.swift
//  xeviet
//
//  Created by Tran Thanh Nhien on 6/7/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import Foundation
import SwiftyJSON
import Localize_Swift

class VehicleTypeModel {
    enum VehicleType: Int {
        case seat_4 = 1
        case seat_7 = 2
        case seat_16 = 3
        case seat_29 = 5
        case seat_35 = 6
        case seat_45 = 7
        
        static let allValue = [seat_4, seat_7, seat_16, seat_29, seat_35, seat_45]
        
        func getString() -> String {
            switch self {
            case .seat_4:
                return "4_SEAT_CAR".localized()
            case .seat_7:
                return "7_SEAT_CAR".localized()
            case .seat_16:
                return "16_SEAT_CAR".localized()
            case .seat_29:
                return "29_SEAT_CAR".localized()
            case .seat_35:
                return "35_SEAT_CAR".localized()
            case .seat_45:
                return "45_SEAT_CAR".localized()
            }
        }
    }
    var verhicleAirportType: VehicleType = .seat_4
    var verhicleType: Int = 0
    var verhicleName: String = ""
    var data: Calculate = Calculate()
    
    convenience init(fromJson json: JSON) {
        self.init()
        if json.isEmpty { return }
        
        verhicleAirportType = VehicleTypeModel.VehicleType(rawValue: json["type"].intValue) ?? .seat_4
        verhicleType = json["vehicle_type"].intValue
        verhicleName = json["vehicle_name"].stringValue
        data = Calculate(fromJson: json["data"])
    }
}
