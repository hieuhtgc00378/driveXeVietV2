//
//  BookingAirPortStep2.swift
//  Xe TQT
//
//  Created by Admin on 5/9/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import UIKit
import DateTimePicker
import RxSwift
import RxCocoa
import Localize_Swift
import DropDown

class BookingAirPortStep2: BaseViewController {
    
    @IBOutlet weak var dropView: UIView!
    @IBOutlet weak var lb_car_type: UILabel!
    
    @IBOutlet weak var fromPlaceLabel: UILabel!
    @IBOutlet weak var toPlaceLabel: UILabel!
    @IBOutlet weak var airImageView: UIImageView!
    @IBOutlet weak var lb_diemden: UILabel!
    @IBOutlet weak var lb_diemdon: UILabel!
    @IBOutlet weak var tf_name: PTextField!
    @IBOutlet weak var tf_phone: PTextField!
    @IBOutlet weak var tv_note: PTextView!
    
    @IBOutlet weak var tf_date: UITextField!
    @IBOutlet weak var tf_time: UITextField!
    
    @IBOutlet weak var endStackView: UIStackView!
    @IBOutlet weak var placeEndLabel: UILabel!
    
    @IBOutlet weak var stack_route: UIStackView!
    let disposeBag = DisposeBag()
    
    var booking: Booking = Booking()
    var myBag = DisposeBag()
    
    var picked_date:Date?
    var picked_hour:String?
    var userPosition:Position?
    
    var list_airport: [CountriesRoute] = []
    var vehicleList = [VehicleTypeModel]()
    let dropDown = DropDown()
    var isBookingAirport: Bool = true
    // MARK: - Init
    init(isBookingAirport: Bool) {
        self.isBookingAirport = isBookingAirport
        super.init(nibName: "BookingAirPortStep2", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initComponents()
        self.initData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func initComponents() {
        switch self.booking.type {
        case BookingType.airport.rawValue:
            self.endStackView.isHidden = true
            self.toPlaceLabel.text = "TO_PLACE".localized()
            self.fromPlaceLabel.text = "FROM_PLACE".localized()
            self.title = "BOOKING_AIRPORT".localized()
            break
        case BookingType.airport_back.rawValue:
            self.endStackView.isHidden = true
            self.toPlaceLabel.text = "TO_PLACE_BACK".localized()
            self.fromPlaceLabel.text = "FROM_PLACE_BACK".localized()
            self.title = "BOOKING_AIRPORT_BACK".localized()
            break
        case BookingType.province.rawValue:
            self.airImageView.isHidden = true
            self.toPlaceLabel.text = "FROM_PLACE_BACK".localized()
            self.fromPlaceLabel.text = "TO_PLACE_BACK".localized()
            self.title = "BOOKING_PROVINCE".localized()
        default:
            break
        }
        
        self.lb_car_type.text = self.booking.vehicleType.getString()
        
        self.bindData()
        
    }
    
    func initData() {
        self.getVehicleList()
    }
    
    func bindData() {
        switch self.booking.type {
        case BookingType.airport.rawValue:
            _ = "DI SAN BAY"
            self.lb_diemdon.text = self.booking.place_begin != "" ? self.booking.place_begin : "PICK_BEGIN_PLACE".localized()
            self.lb_diemden.text = self.booking.place_end != "" ? self.booking.place_end : "PICK_END_PLACE".localized()
            break
        case BookingType.airport_back.rawValue:
            _ = "DON SAN BAY"
            self.lb_diemdon.text = self.booking.place_end != "" ? self.booking.place_end : "PICK_END_PLACE".localized()
            self.lb_diemden.text = self.booking.place_begin != "" ? self.booking.place_begin : "PICK_BEGIN_PLACE".localized()
            break
        case BookingType.province.rawValue:
            _ = "LIEN TINH"
            self.lb_diemden.text = "PICK_BEGIN_PLACE".localized()
            self.stack_route.isHidden = true
        default:
            break
        }
        
        
        if let time:String? = self.booking.pickup_time{
            if let date:Date = time?.iso8601withFractionalSeconds{
                self.tf_date.text = date.toYearMonthDay
                self.tf_time.text = date.toHourMinUTC
                self.picked_date = date
                self.picked_hour = date.toHourMinUTC
            }
        }
        
        
        
        if let user = AppManager.shared.user{
            if let name:String? = user.user_name{
                self.tf_name.text = name
            }
            
            if let phone:String? = user.phone_number{
                self.tf_phone.text = phone
            }
        }
    }
    
    func setupDropdownMenuToView(view: UIView){
        // The view to which the drop down will appear on
        dropDown.anchorView = view // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        let data: [String] = self.vehicleList.map {$0.verhicleAirportType.getString()}
        dropDown.dataSource = data
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.lb_car_type.text = item
            self.booking.vehicleType = self.vehicleList[index].verhicleAirportType
        }
    }
    
    @IBAction func on_show_menu(_ sender: Any) {
        if self.isBookingAirport {
            self.dropDown.show()
        }
    }
    
    
    @IBAction func on_pick_day(_ sender: Any) {
        let calendarVC = BostyCalendarVC.init(minDate: Date().getYesterday() ?? Date(), maxDate: Date().getNextThirdMonthEnd() ?? Date(), isRange: false) { (pickedDate) in
            self.picked_date = pickedDate.first
            self.tf_date.text = self.picked_date?.toYearMonthDay
        }
        calendarVC.modalPresentationStyle = .overCurrentContext
        self.present(calendarVC, animated: true, completion: nil)
    }
    
    
    @IBAction func on_pick_hour(_ sender: Any) {
        let picker = DateTimePicker.create()
        picker.isTimePickerOnly = true
        picker.dateFormat = "HH:mm"
        picker.cancelButtonTitle = "Cancel".localized()
        picker.doneButtonTitle = "Done".localized()
        picker.todayButtonTitle = "Today".localized()
        picker.completionHandler = { date in
            self.picked_hour = date.toHourMinUTC7
            self.tf_time.text = date.toHourMinUTC7
        }
        picker.show()
    }
    
    @IBAction func on_pick_address(_ sender: Any) {
        let pickAddressVC = PickAddressVC()
        pickAddressVC.didCompletePicked = { place in
            print(place)
            if let address = place.formattedAddress{
                switch self.booking.type {
                case BookingType.airport.rawValue:
                    self.lb_diemdon.text = address
                    self.booking.place_begin = address
                    self.booking.place_begin_id = place.placeID!
                    self.booking.lat_start = Float(place.coordinate.latitude)
                    self.booking.lng_start = Float(place.coordinate.longitude)
                    break
                case BookingType.airport_back.rawValue:
                    self.lb_diemdon.text = address
                    self.booking.place_end = address
                    self.booking.place_end_id = place.placeID!
                    self.booking.lat_end = Float(place.coordinate.latitude)
                    self.booking.lng_end = Float(place.coordinate.longitude)
                    break
                case BookingType.province.rawValue:
                    _ = "LIEN TINH"
                    if let btn:UIButton = sender as? UIButton{
                        if btn.tag == 10{
                            self.placeEndLabel.text = address
                            self.booking.place_end = address
                            self.booking.place_end_id = place.placeID!
                            self.booking.lat_end = Float(place.coordinate.latitude)
                            self.booking.lng_end = Float(place.coordinate.longitude)
                        }else{
                            self.lb_diemdon.text = address
                            self.booking.place_begin = address
                            self.booking.place_begin_id = place.placeID!
                            self.booking.lat_start = Float(place.coordinate.latitude)
                            self.booking.lng_start = Float(place.coordinate.longitude)
                        }
                    }
                default:
                    break
                }
            }
        }
        
        let navi = UINavigationController.init(rootViewController: pickAddressVC)
        navi.modalPresentationStyle = .overCurrentContext
        navi.isNavigationBarHidden = true
        navi.navigationBar.isTranslucent = true
        navi.navigationBar.isHidden = true
        self.present(navi, animated: true, completion: nil)
        
        
    }
    
    @IBAction func on_next(_ sender: Any) {
        switch self.booking.type {
        case BookingType.airport.rawValue:
            if booking.lat_start == nil {
                AppMessagesManager.shared.showMessage(messageType: .error, message: "EMPTY_USER_POSITION".localized())
                return
            }
            break
        case BookingType.airport_back.rawValue:
            if booking.lat_end == nil {
                AppMessagesManager.shared.showMessage(messageType: .error, message: "EMPTY_USER_POSITION_BACK".localized())
                return
            }
            break
        case BookingType.province.rawValue:
            if booking.lat_start == nil {
                AppMessagesManager.shared.showMessage(messageType: .error, message: "EMPTY_USER_POSITION".localized())
                return
            }
            
            if booking.lat_end == nil {
                AppMessagesManager.shared.showMessage(messageType: .error, message: "EMPTY_USER_POSITION_BACK".localized())
                return
            }
            
        default:
            break
        }
        
        if self.booking.type == BookingType.province.rawValue && booking.lat_end == nil {
            AppMessagesManager.shared.showMessage(messageType: .error, message: "EMPTY_END_POSITION".localized())
            return
        }
        
        if picked_date == nil{
            AppMessagesManager.shared.showMessage(messageType: .error, message: "EMPTY_PICKED_DATE".localized())
            return
        }
        
        if picked_hour == nil{
            AppMessagesManager.shared.showMessage(messageType: .error, message: "EMPTY_PICKED_HOUR".localized())
            return
        }
        
        if tf_name.text!.isEmpty{
            AppMessagesManager.shared.showMessage(messageType: .error, message: "EMPTY_PASSENGER_NAME".localized())
            return
        }
        
        if tf_phone.text!.isEmpty{
            AppMessagesManager.shared.showMessage(messageType: .error, message: "EMPTY_PASSENGER_PHONE".localized())
            return
        }
        
        booking.pickup_time = "\(self.picked_date!.toApiDateFormatString) \(self.picked_hour!)"
        
        booking.passenger_name = self.tf_name.text!
        booking.passenger_phone = self.tf_phone.text!
        booking.note = self.tv_note.text
        
        switch self.booking.type {
        case BookingType.airport.rawValue:
            PLoadingActivity.shared.show(type: .ballScaleMultiple, message: "GET_PRICE_LOADING".localized(), thresholdTime: 0, autoHide: false)
            
            let params = [
                "latitude": booking.lat_start!,
                "longitude": booking.lng_start!,
                "airport_id":booking.airport_id!,
                "is_back": 0,
                "type" : self.booking.vehicleType.rawValue
                ] as [String : Any]
            
            MainServices.calculatePriceAirPort(params).asObservable().asObservable().subscribe(onNext: { [unowned self] result in
                switch result {
                case .success(let calculate):
                    PLoadingActivity.shared.hide()
                    let bookingAirPortStep3 = BookingAirPortStep3()
                    bookingAirPortStep3.booking = self.booking
                    bookingAirPortStep3.calculate = calculate
                    self.navigationController?.pushViewController(bookingAirPortStep3, animated: true)
                case .failure(let error):
                    PLoadingActivity.shared.hide()
                    AppMessagesManager.shared.showMessage(messageType: .error, message: error.message.localized())
                }
            }).disposed(by: self.myBag)
            
        case BookingType.airport_back.rawValue:
            print("airport_back")
            PLoadingActivity.shared.show(type: .ballScaleMultiple, message: "GET_PRICE_LOADING".localized(), thresholdTime: 0, autoHide: false)
            
            let params = [
                "latitude": booking.lat_end!,
                "longitude": booking.lng_end!,
                "airport_id":booking.airport_id!,
                "is_back": 1,
                "type" : self.booking.vehicleType.rawValue
                ] as [String : Any]
            
            MainServices.calculatePriceAirPort(params).asObservable().asObservable().subscribe(onNext: { [unowned self] result in
                switch result {
                case .success(let calculate):
                    PLoadingActivity.shared.hide()
                    let bookingAirPortStep3 = BookingAirPortStep3()
                    bookingAirPortStep3.booking = self.booking
                    bookingAirPortStep3.calculate = calculate
                    self.navigationController?.pushViewController(bookingAirPortStep3, animated: true)
                case .failure(let error):
                    PLoadingActivity.shared.hide()
                    AppMessagesManager.shared.showMessage(messageType: .error, message: error.message.localized())
                }
            }).disposed(by: self.myBag)
            
        case BookingType.province.rawValue:
            let bookingAirPortStep3 = BookingAirPortStep3()
            bookingAirPortStep3.booking = self.booking
            let calculate = Calculate()
            calculate.original_fee = booking.fee ?? 0
            bookingAirPortStep3.calculate = calculate
            self.navigationController?.pushViewController(bookingAirPortStep3, animated: true)
            break
            
        case BookingType.fast.rawValue:
            break
        case .none:
            break
        case .some(_):
            break
        }
    }
}

extension BookingAirPortStep2 {
    
    func getVehicleList () {
        MainServices.getListVehicle().asObservable().subscribe(onNext: { [unowned self] result in
            switch result {
            case .success(let vehicles):
                PLoadingActivity.shared.hide()
                self.vehicleList = vehicles
                self.setupDropdownMenuToView(view: self.dropView)
            case .failure(let error):
                PLoadingActivity.shared.hide()
                AppMessagesManager.shared.showMessage(messageType: .error, message: error.message.localized())
            }
        }).disposed(by: self.myBag)
    }
}
