//
//  NotificationModel.swift
//  xeviet
//
//  Created by Hieu Ha trung on 01/07/2021.
//  Copyright © 2021 eagle. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftDate

class NotificationModel {
    
    var id: Int?
    var user_id: Int?
    var type: Int?
    var user_phone: String?
    var images: String?
    var title: String?
    var content: String?
    var created_at: String?
    
    convenience init(fromJson json: JSON) {
        self.init()
        if json.isEmpty { return }
        
        id = json["id"].intValue
        user_id = json["user_id"].intValue
        type = json["type"].intValue
        user_phone = json["user_phone"].stringValue
        images = json["images"].stringValue
        title = json["tittle"].stringValue
        content = json["content"].stringValue
        created_at = json["created_at"].stringValue
    }
}
