//
//  DateCell.swift
//  bosty-ios
//
//  Created by eagle on 1/7/20.
//  Copyright © 2020 Tran Thanh Nhien. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DateCell: JTAppleCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
