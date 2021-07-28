//
//  UserInfo.swift
//  bosty-ios
//
//  Created by eagle on 1/8/20.
//  Copyright © 2020 Tran Thanh Nhien. All rights reserved.
//

import SwiftyJSON

class UserInfo{
    var id: Int?
    var phone_number: String = ""
    var user_name: String = ""
    var email: String = ""
    var password: String = ""
    var type: Int = 1
    var credit: Int = 0
    var avatar_url: String = ""
    var is_active: Bool = true
    var sex: String = "male"
    var birthdate: String = ""
    var created_at: String = ""
    var updated_at: String = ""
    
    var address: String = ""
    var place_id: String = ""
    var longitude: Double = 0
    var latitude: Double = 0
    var credit_hold: Int = 0

    var token: String = ""

 /**
     * Instantiate the instance using the passed json values to set the properties values
     */
     convenience init(fromJson json: JSON!) {
         self.init()
         if json.isEmpty { return }
        id = json["id"].int
        phone_number = json["phone_number"].stringValue
        user_name = json["user_name"].stringValue
        email = json["email"].stringValue
        password = json["password"].stringValue
        type = json["type"].intValue
        avatar_url = json["avatar_url"].stringValue
        is_active = json["is_active"].boolValue
        sex = json["sex"].stringValue
        birthdate = json["birthdate"].stringValue
        created_at = json["created_at"].stringValue
        updated_at = json["updated_at"].stringValue
        token = json["token"].stringValue
        
        address = json["address"].stringValue
        place_id = json["place_id"].stringValue
        longitude = json["longitude"].doubleValue
        latitude = json["latitude"].doubleValue
        credit_hold = json["credit_hold"].intValue

     }
    
}
