//
//  BookingAirPortStep3.swift
//  Xe TQT
//
//  Created by Admin on 5/11/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BookingAirPortStep3: BaseViewController {
    
    @IBOutlet weak var vehicleTypeLabel: UILabel!
    @IBOutlet weak var lb_diemden: UILabel!
    @IBOutlet weak var lb_diemdi: UILabel!
    @IBOutlet weak var lb_date: UILabel!
    @IBOutlet weak var lb_time: UILabel!
    @IBOutlet weak var tf_name: PTextField!
    @IBOutlet weak var tf_phone: PTextField!
    @IBOutlet weak var lb_note_driver: UILabel!
    @IBOutlet weak var tf_total_cost: PTextField!
    @IBOutlet weak var tf_deal: PTextField!
    
    var airportPosition:Position?
    var passengerPosition:Position?
    
    var calculate:Calculate!
    var promotion: PromotionModel?
    var booking:Booking!
    
    
    var myBag = DisposeBag()
    
    var viewModel : BookingModelVM! {
        didSet {
            self.bindData()
        }
    }
    
    // MARK: - Init
    init() {
        self.viewModel = BookingModelVM()
        super.init(nibName: "BookingAirPortStep3", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        switch self.booking.type {
//
//        case BookingType.airport.rawValue:
//            self.title = "Đặt xe sân bay"
//        case BookingType.airport_back:
//
//        case BookingType.province.rawValue:
//            self.title = "Đặt xe liên tỉnh"
//
//        case .none:
//            self.title = "Đặt xe sân bay"
//        case .some(_):
//            break
//        }
        
        let type: BookingType = BookingType(rawValue: self.booking.type ?? 1) ?? .airport
        self.title = type.getTitleString()
        
        self.bindData()
    }
    
    @IBAction func on_view_deal(_ sender: Any) {
        PromotionViewVC.showView { [weak self] (promotion) in
            self?.promotion = promotion
            self?.tf_deal.text = promotion.giftCode
        }
    }
    
    @IBAction func on_submit(_ sender: Any) {
        switch self.booking.type {
        case BookingType.airport.rawValue:
            var place_id = ""
            if booking.type == BookingType.airport.rawValue{
                place_id = booking.place_begin_id
            }else{
                place_id = booking.place_end_id
            }
            
            PLoadingActivity.shared.show(type: .ballScaleMultiple, message: "LOADING_BOOKING".localized(), thresholdTime: 0, autoHide: false)
            
            
            var params: [String : Any]
            if let promotionID = self.promotion?.ID {
                params = [
                "latitude" : booking.lat_start!,
                "longitude" : booking.lng_start!,
                "airport_id" : booking.airport_id!,
                "pickup_time" : "\(booking.pickup_time):00",
                "note" : lb_note_driver.text ?? "",
                "passenger_phone" : booking.passenger_phone,
                "passenger_name" : booking.passenger_name,
                "is_back": false,
                "type" : self.booking.vehicleType.rawValue,
                "promotion_id": promotionID
                ]
            } else {
                params = [
                "latitude" : booking.lat_start!,
                "longitude" : booking.lng_start!,
                "airport_id" : booking.airport_id!,
                "pickup_time" : "\(booking.pickup_time):00",
                "note" : lb_note_driver.text ?? "",
                "passenger_phone" : booking.passenger_phone,
                "passenger_name" : booking.passenger_name,
                "is_back": false,
                "type" : self.booking.vehicleType.rawValue
                ]
            }
            
            MainServices.bookingAirPort(params).asObservable().asObservable().subscribe(onNext: { [unowned self] result in
                PLoadingActivity.shared.hide()
                switch result {
                case .success(_):
                    self.navigationController?.popToRootViewController(animated: true)
                    AppMessagesManager.shared.showMessage(messageType: .success, message: "BOOKING_SUCCESS".localized())
                case .failure(let error):
                    AppMessagesManager.shared.showMessage(messageType: .error, message: error.message)
                }
            }).disposed(by: self.myBag)
            
        case BookingType.airport_back.rawValue:
            var place_id = ""
            if booking.type == BookingType.airport.rawValue{
                place_id = booking.place_begin_id
            }else{
                place_id = booking.place_end_id
            }
            
            PLoadingActivity.shared.show(type: .ballScaleMultiple, message: "LOADING_BOOKING".localized(), thresholdTime: 0, autoHide: false)
            
            var params: [String : Any] = [
                "latitude" : booking.lat_end!,
                "longitude" : booking.lng_end!,
                "airport_id" : booking.airport_id!,
                "pickup_time" : "\(booking.pickup_time):00",
                "note" : lb_note_driver.text ?? "",
                "passenger_phone" : booking.passenger_phone,
                "passenger_name" : booking.passenger_name,
                "is_back": true,
                "type" : self.booking.vehicleType.rawValue
                ]
            if let id = self.promotion?.ID {
                params["promotion_id"] = id
            }
            
            MainServices.bookingAirPort(params).asObservable().asObservable().subscribe(onNext: { [unowned self] result in
                PLoadingActivity.shared.hide()
                switch result {
                case .success(let booking):
                    self.navigationController?.popToRootViewController(animated: true)
                    AppMessagesManager.shared.showMessage(messageType: .success, message: "BOOKING_SUCCESS".localized())
                case .failure(let error):
                    print(error)
                }
            }).disposed(by: self.myBag)
        case BookingType.province.rawValue:
            PLoadingActivity.shared.show(type: .ballScaleMultiple, message: "LOADING_BOOKING".localized(), thresholdTime: 0, autoHide: false)
            
            var param: PARAM = [
                "route_id": booking.route_id!,
                "note": booking.note,
                "pickup_time": "\(booking.pickup_time):00",
                "passenger_phone": booking.passenger_phone,
                "place_start": booking.place_begin,
                "place_end": booking.place_end,
                "passenger_name": booking.passenger_name,
                "lat_start": booking.lat_start!,
                "lng_start": booking.lng_start!,
                "lat_end": booking.lat_end!,
                "lng_end": booking.lng_end!
            ]
            
            if let id = self.promotion?.ID {
                param["promotion_id"] = id
            }
            
            FastBookingServices.bookingProvince(param).asObservable().subscribe(onNext: { [unowned self] result in
                PLoadingActivity.shared.hide()
                switch result {
                case .success(let booking):
                    self.navigationController?.popToRootViewController(animated: true)
                    AppMessagesManager.shared.showMessage(messageType: .success, message: "BOOKING_SUCCESS".localized())
                case .failure(let error):
                    AppMessagesManager.shared.showMessage(messageType: .error, message: error.localizedDescription)
                    print (error)
                }
            }).disposed(by: self.myBag)
            
            break
        default:
            break
        }
    }
    
    
    func bindData() {
        self.vehicleTypeLabel.text = self.booking.vehicleType.getString()
        self.lb_diemdi.text = "Điểm đi: \(self.booking.place_begin)"
        self.lb_diemden.text = "Điểm đến: \(self.booking.place_end)"
        
        if let date = self.booking.pickup_time.components(separatedBy: " ").first{
            print("dateeee: \(date)")
            self.lb_date.text = "Ngày: \(date.toDateOnly()?.toYearMonthDay ?? "")"
        }
        
        if let time = self.booking.pickup_time.components(separatedBy: " ").last{
            print("timeeeee: \(time)")
            self.lb_time.text = "Giờ: \(time)"
        }
        
        self.tf_name.text = "\(self.booking.passenger_name)"
        self.tf_phone.text = "\(self.booking.passenger_phone)"
        
        self.tf_total_cost.text = self.calculate.original_fee.convertToVND()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
