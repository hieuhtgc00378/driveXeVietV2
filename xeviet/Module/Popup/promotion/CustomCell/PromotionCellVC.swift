//
//  PromotionCellVC.swift
//  xeviet
//
//  Created by Tran Thanh Nhien on 6/10/20.
//  Copyright © 2020 eagle. All rights reserved.
//


import UIKit
import RxCocoa
import RxSwift
import Kingfisher

class PromotionCellVC: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var promotionValueLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    // MARK: - Variables
    var myBag = DisposeBag()
    var viewModel: PromotionCellVM? {
        didSet {
            setupRxData()
            setupRxAction()
        }
    }
    
    func setupRxData() {
        guard let viewModel = self.viewModel else { return }
        
        viewModel.title.asDriver().drive(self.titleLabel.rx.text).disposed(by: myBag)
        viewModel.desc.asDriver().drive(self.descriptionLabel.rx.text).disposed(by: myBag)
        viewModel.promotionValue.asDriver().drive(self.promotionValueLabel.rx.text).disposed(by: myBag)
    }
    
    func setupRxAction() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.myBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.promotionValueLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    }
    
}
