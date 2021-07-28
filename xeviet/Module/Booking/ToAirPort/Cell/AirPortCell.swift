//
//  AirPortCell.swift
//  Xe TQT
//
//  Created by Admin on 5/9/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import UIKit

class AirPortCell: UITableViewCell {
    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var bg: PImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
