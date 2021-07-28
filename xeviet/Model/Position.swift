//
//  Position.swift
//  xeviet
//
//  Created by Admin on 6/1/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import UIKit
import SwiftyJSON

class Position {
    var id: Int?
    var name: String = ""
    var format_address: String = ""
    var type: Int = 1
    var place_id: String = ""
    var created_at: String = ""
    var updated_at: String = ""
    var lat: Float = 0
    var long: Float = 0

    convenience init(fromJson json: JSON!) {
        self.init()
        if json.isEmpty { return }
        id = json["id"].int
        name = json["name"].stringValue
        format_address = json["format_address"].stringValue
        type = json["type"].int!
        place_id = json["place_id"].stringValue
        created_at = json["created_at"].stringValue
        updated_at = json["updated_at"].stringValue
        lat = json["lat"].floatValue
        long = json["long"].floatValue

     }
    
}
