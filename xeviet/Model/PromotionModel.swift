//
//  PromotionModel.swift
//  xeviet
//
//  Created by Tran Thanh Nhien on 6/10/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftDate

class PromotionModel {
    
    var ID: Int = 0
    var title: String = ""
    var description: String = ""
    var giftCode: String = ""
    var startTime: DateInRegion? = nil
    var endTime: DateInRegion? = nil
    var objectApply: Int = 0
    var userIDs: Int? = nil
    var percentDiscount: Int = 0
    var MaxAmountReduce: Double? = nil
    var amountDiscount: Double? = nil
    var minimumBill: Double? = nil
    var type: Int = 0
    var isActive: Bool = false
    var createdAt: DateInRegion? = nil
    var updatedAt: DateInRegion? = nil
    
    convenience init(fromJson json: JSON) {
        self.init()
        if json.isEmpty { return }
        
        ID = json["id"].intValue
        description = json["description"].stringValue
        title = json["title"].stringValue
        giftCode = json["gift_code"].stringValue
        objectApply = json["object_apply"].intValue
        userIDs = json["user_ids"].int
        percentDiscount = json["percent_discount"].intValue
        MaxAmountReduce = json["max_amount_reduce"].double
        amountDiscount = json["amount_discount"].double
        minimumBill = json["minimum_bill"].double
        type = json["type"].intValue
        isActive = json["is_active"].boolValue
    }
}
