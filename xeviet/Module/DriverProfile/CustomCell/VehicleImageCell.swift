//
//  VehicleImageCell.swift
//  Driver-iOS
//
//  Created by Tran Thanh Nhien on 7/1/20.
//  Copyright © 2020 Tran Thanh Nhien. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class VehicleImageCell: UICollectionViewCell {

    @IBOutlet weak var vehicleImageView: PImageView!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(imageUrl url: String) {
        if let url = url.urlEncoded {
            self.vehicleImageView.kf.setImage(with: url)
        }
    }
}
