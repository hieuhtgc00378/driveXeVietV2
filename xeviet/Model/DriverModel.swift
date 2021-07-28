//
//  DriverModel.swift
//  xeviet
//
//  Created by Tran Thanh Nhien on 6/11/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import Foundation
import SwiftyJSON

class DriverModel {
    var driverID: Int = 0
    var userID: Int = 0
    var atmNumber: String = ""
    var address: String = ""
    var lat: Double? = 0
    var lng: Double? = nil
    var phoneNumber: String = ""
    var userName: String = ""
    var avatarUrl: String = ""
    var birthday: String = ""
    var sex: String = ""
    var license: String = ""
    var color: String = ""
    var vehicleKin: String = ""
    var imagesUrl: [String] = []

//    var car: CarModel = CarModel()
    
    convenience init(fromJson json: JSON) {
        self.init()
        if json.isEmpty { return }
        
        phoneNumber = json["phone_number"].stringValue
        userName = json["user_name"].stringValue
        avatarUrl = json["avatar_url"].stringValue
        sex = json["sex"].stringValue
        license = json["license_plate"].stringValue
        color = json["vehicle_color"].stringValue
        vehicleKin = json["vehicle_kind"].stringValue
        imagesUrl = json["vehicle_images"].arrayValue.map { $0.stringValue }

    }
}


class CarModel {
    
    var license: String = ""
    var color: String = ""
    var vehicleKin: String = ""
    var imagesUrl: [String] = []
    
    convenience init(fromJson json: JSON) {
        self.init()
        if json.isEmpty { return }
        
        license = json["license_plate"].stringValue
        color = json["vehicle_color"].stringValue
        vehicleKin = json["vehicle_kind"].stringValue
        imagesUrl = json["vehicle_images"].arrayValue.map { $0.stringValue }
    }
}

