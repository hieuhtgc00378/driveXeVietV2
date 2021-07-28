//
//  Booking.swift
//  xeviet
//
//  Created by Admin on 6/2/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import UIKit
import SwiftyJSON

class Booking{
    var id: Int?
    var passenger_id: Int?
    var driver_id: Int?
    var route_id: Int?
    var place_begin: String = ""
    var place_end: String = ""
    var distance: Int?
    var pickup_time: String = ""
    var start_time: String = ""
    var end_time: String = ""
    var original_fee: Int?
    var fee: Int?
    var status: Int?
    var rating: Int?
    var reason_cancel: String = ""
    var gift_code: String = ""
    var promotion_id: Int?
    var discount_percent: Int?
    var discount_amount: Int?
    var commission: Int?
    var note: String = ""
    var type: Int?
    var passenger_phone: String = ""
    var passenger_name: String = ""
    var created_at: String = ""
    var updated_at: String = ""
    
    var place_begin_id: String = ""
    var place_end_id: String = ""
    
    var airport_id: Int?
    
    var lat_start: Float? = nil
    var lng_start: Float? = nil
    var lat_end: Float? = nil
    var lng_end: Float? = nil
    
    var vehicleType: VehicleTypeModel.VehicleType = .seat_4
    
    convenience init(fromJson json: JSON!) {
        self.init()
        if json.isEmpty { return }
        id = json["id"].int
        passenger_id = json["passenger_id"].int
        driver_id = json["driver_id"].int
        route_id = json["route_id"].int
        place_begin = json["place_begin"].stringValue
        place_end = json["place_end"].stringValue
        distance = json["distance"].int
        pickup_time = json["pickup_time"].stringValue
        start_time = json["start_time"].stringValue
        end_time = json["end_time"].stringValue
        original_fee = json["original_fee"].int
        fee = json["fee"].int
        status = json["status"].int
        rating = json["rating"].int
        reason_cancel = json["reason_cancel"].stringValue
        gift_code = json["gift_code"].stringValue
        promotion_id = json["promotion_id"].int
        discount_percent = json["discount_percent"].int
        discount_amount = json["discount_amount"].int
        commission = json["commission"].int
        note = json["note"].stringValue
        type = json["type"].int
        passenger_phone = json["passenger_phone"].stringValue
        passenger_name = json["passenger_name"].stringValue
        created_at = json["created_at"].stringValue
        updated_at = json["updated_at"].stringValue

        place_begin_id = json["place_begin_id"].stringValue
        place_end_id = json["place_end_id"].stringValue
        
        airport_id = json["airport_id"].int

        lat_start = json["lat_start"].floatValue
        lng_start = json["lng_start"].floatValue
        lat_end = json["lat_end"].floatValue
        lng_end = json["lng_end"].floatValue
    }
}
