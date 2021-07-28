//
//  NotificationTableViewCell.swift
//  xeviet
//
//  Created by Hieu Ha trung on 01/07/2021.
//  Copyright © 2021 eagle. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
