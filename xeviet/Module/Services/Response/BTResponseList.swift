//
//  BTResponseList.swift
//  bosty-ios
//
//  Created by eagle on 1/9/20.
//  Copyright © 2020 Tran Thanh Nhien. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyJSON

class BTResponseList<T:Mappable>: Mappable {
    var dataObject:[T] = [T]()
    var message:String = ""
    var code:Int?
    var server_time:ServerTime?
    
    init() {}
    required convenience init?(map: Map) { self.init() }
       
       // Mappable
      func mapping(map: Map) {
          dataObject    <- map["dataObject"]
          message         <- map[message]
          code      <- map["code"]
          server_time       <- map["server_time"]
      }
}
