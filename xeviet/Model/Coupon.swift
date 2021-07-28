//
//  Coupon.swift
//  xeviet
//
//  Created by Admin on 7/14/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import UIKit
import SwiftyJSON

class Coupon {
     var id: Int = 0
     var title: String = ""
     var descriptions: String = ""
     var gift_code: String = ""
     var start_time: String = ""
     var end_time: String = ""
     var object_apply: Int = 1
     var user_ids: [Int] = [Int]()
     var percent_discount: Int = 0
    var max_amount_reduce: Int = 0
    var amount_discount: Int = 0
    var minimum_bill: Int = 0
    var type: Int = 0
    var is_active:Bool = true
    var created_at: String = ""
    var updated_at: String = ""
    var amount_discount_available: Int = 0
    var usedPromotion: [UsedPromotion] = [UsedPromotion]()

     convenience init(fromJson json: JSON) {
         self.init()
         if json.isEmpty { return }
         id = json["id"].intValue
         title = json["title"].stringValue
         descriptions = json["description"].stringValue
         gift_code = json["gift_code"].stringValue
         start_time = json["start_time"].stringValue
         end_time = json["end_time"].stringValue
         object_apply = json["object_apply"].intValue
         user_ids = json["user_ids"].arrayValue.map { $0.intValue }
        percent_discount = json["percent_discount"].intValue
        max_amount_reduce = json["max_amount_reduce"].intValue
        amount_discount = json["amount_discount"].intValue
        minimum_bill = json["minimum_bill"].intValue
        type = json["type"].intValue
        is_active = json["is_active"].boolValue
        created_at = json["created_at"].stringValue
        updated_at = json["updated_at"].stringValue
        usedPromotion = json["UsedPromotion"].arrayValue.map{ UsedPromotion(fromJson: $0)}

     }
    
    func getAmount_discount() -> Int{
        if (usedPromotion != nil && usedPromotion.count > 0 && usedPromotion[0] != nil && amount_discount > 0) {
            return amount_discount - Int(usedPromotion[0].total_amount_used)
        } else {
            return amount_discount;
        }
    }

}
