//
//  BookingCountriesStep3Cell.swift
//  Xe TQT
//
//  Created by Admin on 5/20/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BookingCountriesStep3Cell: UITableViewCell {
    
    @IBOutlet weak var routeNameLabel: UILabel!
    @IBOutlet weak var desciptionLabel: UILabel!
    @IBOutlet weak var percentDiscountButton: PButton!
    @IBOutlet weak var newPriceLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var vehicleTypeLabel: UILabel!
    @IBOutlet weak var percentView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var myBag = DisposeBag()
    var viewModel: CountriesRouteVM? {
        didSet {
            setupRxData()
        }
    }
    
    func setupRxData() {
        guard let viewModel = self.viewModel else { return }
        
        viewModel.routeName.asDriver().drive(self.routeNameLabel.rx.text).disposed(by: myBag)
        viewModel.descript.asDriver().drive(self.desciptionLabel.rx.text).disposed(by: myBag)
        
        viewModel.discount.asDriver()
            .drive(onNext: { [weak self] percent in
                self?.percentDiscountButton.setTitle("-\(percent)%", for: .normal)
                
                self?.oldPriceLabel.isHidden = percent == 0
                self?.percentView.isHidden = percent == 0
                
            })
            .disposed(by: myBag)
        
        viewModel.price_old.asDriver()
            .drive(onNext: { [weak self] oldPrice in
                let oldPriceFormatted = AppManager.shared.numberFormetter.string(from: NSNumber(value: oldPrice ))
                self?.oldPriceLabel.text = "OLDPRICE".localized() + " : \(oldPriceFormatted ?? "0")VNĐ"
                
                let newprice = AppManager.shared.numberFormetter.string(from: NSNumber(value: oldPrice * (100 - viewModel.discount.value) / 100 ))
                self?.newPriceLabel.text = "PRICE".localized() + " : \(newprice ?? "0")VNĐ"
                viewModel.model?.price = oldPrice * (100 - viewModel.discount.value) / 100
            })
            .disposed(by: myBag)
        
        viewModel.vehicleType.asDriver()
            .drive(onNext: { [weak self] vehicleType in
                self?.vehicleTypeLabel.text = "VEHICLE_TYPE".localized() + " : " + vehicleType
            })
            .disposed(by: myBag)
        
    }
    
    @IBAction func on_booking(_ sender: Any) {
        if let model = self.viewModel?.model{
            let bookingAirPortStep2 = BookingAirPortStep2(isBookingAirport: false)
            bookingAirPortStep2.booking.route_id = model.id
            bookingAirPortStep2.booking.place_end = model.placeEndName
            bookingAirPortStep2.booking.place_begin = model.placeBeginName
            bookingAirPortStep2.booking.fee = model.price
            bookingAirPortStep2.booking.type = BookingType.province.rawValue
            bookingAirPortStep2.booking.vehicleType = model.vehicleType
            UIApplication.getTopViewController()?.navigationController?.pushViewController(bookingAirPortStep2, animated: true)
        }
    }
    
    @IBAction func callDriver(_ sender: Any) {
        //AppCoordinator.shared.callToDriver(driverNumber: "")
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        myBag = DisposeBag()
    }
}
