//
//  CountriesRoute.swift
//  Xe TQT
//
//  Created by Admin on 5/21/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import UIKit
import SwiftyJSON



class CountriesRoute: NSObject {
    var id = -1
    var routeName: String = ""
    var placeBeginName: String = ""
    var placeBeginID: String = ""
    var placeEndName: String = ""
    var placeEndID: String = ""
    var vehicleType: VehicleTypeModel.VehicleType = .seat_4
    var descript = ""
    var discount = 0
    var price = 0
    var price_old = 0
    var phone = ""
    var type: Int = 0
    var isActive: Bool = false
    
    convenience init(fromJson json: JSON) {
        self.init()
        if json.isEmpty { return }
        
        id = json["id"].intValue
        routeName = json["name"].stringValue
        placeBeginName = json["place_begin_name"].stringValue
        placeBeginID = json["place_begin_id"].stringValue
        placeEndName = json["place_end_name"].stringValue
        placeEndID = json["place_end_id"].stringValue
        vehicleType = VehicleTypeModel.VehicleType(rawValue: json["vehicle_type"].intValue) ?? .seat_4
        descript = json["description"].stringValue
        discount = json["percent_discount"].intValue
        price = json["price"].intValue
        price_old = json["fee"].intValue
        phone = json["phone"].stringValue//
        type = json["type"].intValue
        isActive = json["is_active"].boolValue
    }
}
