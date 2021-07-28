//
//  Calculate.swift
//  xeviet
//
//  Created by Admin on 6/5/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import UIKit
import SwiftyJSON

class Calculate {
    var distance: Int = 0
    var airport: String = ""
    var original_fee: Int = 0
    var fee: Int = 0
    var destination_addresses: String = ""
    var origin_addresses: String = ""
    
    convenience init(fromJson json: JSON!) {
       self.init()
       if json.isEmpty { return }
        
        distance = json["distance"].intValue
        airport = json["airport"].stringValue
        original_fee = json["original_fee"].intValue
        fee = json["fee"].intValue
        destination_addresses = json["destination_addresses"].stringValue
        origin_addresses = json["origin_addresses"].stringValue
    }
    
}
