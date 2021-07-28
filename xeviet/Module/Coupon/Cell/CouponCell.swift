//
//  CouponCell.swift
//  xeviet
//
//  Created by Admin on 7/14/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import UIKit

class CouponCell: UITableViewCell {
    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var lb_time: UILabel!
    @IBOutlet weak var lb_value: UILabel!
    @IBOutlet weak var lb_target: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
