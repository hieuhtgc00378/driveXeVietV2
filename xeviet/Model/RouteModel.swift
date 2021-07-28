//
//  RouteModel.swift
//  xeviet
//
//  Created by Tran Thanh Nhien on 6/17/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import Foundation
import SwiftyJSON

class RouteModel {
    
    var routeName: String = ""
    var placeBeginName: String = ""
    var placeBeginID: String = ""
    var placeEndName: String = ""
    var placeEndID: String = ""
    
    convenience init(fromJson json: JSON) {
        self.init()
        if json.isEmpty { return }
        
        routeName = json["name"].stringValue
        placeBeginName = json["place_begin_name"].stringValue
        placeBeginID = json["place_begin_id"].stringValue
        placeEndName = json["place_end_name"].stringValue
        placeEndID = json["place_end_id"].stringValue
    }
}
