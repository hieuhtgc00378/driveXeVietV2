//
//  ServerTime.swift
//  bosty-ios
//
//  Created by eagle on 1/9/20.
//  Copyright © 2020 Tran Thanh Nhien. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON

class ServerTime: Mappable {
    var date:String = "" //format: yyyy-MM-dd hh:mm:ss
    var timezone_type:Int = 3
    var timezone:String = ""

    init() {}
    required convenience init?(map: Map) { self.init() }

       // Mappable
      func mapping(map: Map) {
        date    <- map["date"]
        timezone_type    <- map["timezone_type"]
        timezone    <- map["timezone"]
      }
}
