//
//  UsedPromotion.swift
//  xeviet
//
//  Created by Nguyen Anh Tien on 17/07/2021.
//  Copyright © 2021 eagle. All rights reserved.
//

import UIKit
import SwiftyJSON

class UsedPromotion {
    var total_amount_used: Float = 0.0
    var number_of_uses_available: Int = 0
    
    convenience init(fromJson json: JSON!) {
        self.init()
        if json.isEmpty { return }
        total_amount_used = json["total_amount_used"].floatValue
        number_of_uses_available = json["number_of_uses_available"].intValue
        
    }
}
