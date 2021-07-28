//
//  MapViewController.swift
//  Xe TQT
//
//  Created by Admin on 5/11/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftMessages
import ActionSheetPicker_3_0
import RxCocoa
import RxSwift
import MarqueeLabel
import RxGesture

class MapViewController: BaseViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapV: UIView!
    @IBOutlet weak var view_loading: UIView!
    @IBOutlet weak var contenView: UIView!
    @IBOutlet weak var avatar_driver: UIImageView!
    
    var locationManager = CLLocationManager()
    var mapView : GMSMapView!
    
    var start_address = ""
    var end_address = ""
    
    var startCor : CLLocationCoordinate2D?
    var endCor : CLLocationCoordinate2D?
    
    var likelyPlaces: [GMSPlace] = []
    
    var type: BookingType = BookingType.fast
    

    
    var startPlace = true
    
    @IBOutlet weak var lb_type_car: UILabel!
    @IBOutlet weak var lb_type_car_price: UILabel!
    @IBOutlet weak var lb_fast_total: UILabel!
    
    @IBOutlet weak var btn_coupon: PButton!
    @IBOutlet weak var btn_type_pay: PButton!
    
//    var bookingAirPortVC:BookingAirPortStep2?
    
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    // view price
    @IBOutlet weak var view_price: PView!
    @IBOutlet weak var bookingButton: PButton!
    @IBOutlet weak var chooseVehicleType: UILabel!
    @IBOutlet weak var promotionCodeLabel: UILabel!
    @IBOutlet weak var payTypeLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    // route view
    @IBOutlet weak var view_route: PView!
    @IBOutlet weak var startPointLabel: UILabel!
    @IBOutlet weak var tf_start: PTextField!
    @IBOutlet weak var endPointLabel: UILabel!
    @IBOutlet weak var tf_end: PTextField!
    
    // Driver view
    @IBOutlet var driverView: UIView!
    @IBOutlet weak var driverInfoView: PView!
    @IBOutlet weak var cancelButton: PButton!
    @IBOutlet weak var driverTotalLabel: UILabel!
    @IBOutlet weak var driverPriceLabel: UILabel!
    //@IBOutlet weak var driverStartPointLabel: UILabel!
    @IBOutlet weak var driverStartpoint: MarqueeLabel!
    //@IBOutlet weak var driverEndPointLabel: UILabel!
    @IBOutlet weak var driverEndPoint: MarqueeLabel!
    @IBOutlet weak var driverLabel: UILabel!
    @IBOutlet weak var driverNameLabel: UILabel!
    @IBOutlet weak var carNameLabel: UILabel!
    @IBOutlet weak var carColorLabel: UILabel!
    @IBOutlet weak var licensePlateLabel: UILabel!
    @IBOutlet weak var licensePlate: UILabel!
    @IBOutlet weak var callDriverButton: PButton!
    
    
    fileprivate var myBag = DisposeBag()
    let viewModel: MapViewVM
    
    var booking:Booking!
    
    // MARK: - Init
    init(viewModel: MapViewVM) {
        self.viewModel = viewModel
        super.init(nibName: "MapViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("denit mapviewvc.................")
    }
    
    @IBOutlet weak var btnChooseCarType: UIButton!
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var btnX: UIButton!
    var indicator = UIActivityIndicatorView()

    func disableControlsOnBooking(isDisable: Bool) -> Void {
        btn_type_pay.isEnabled = !isDisable
        btnChooseCarType.isEnabled = !isDisable
        btn_coupon.isEnabled = !isDisable
        btnBack.isEnabled = !isDisable
        btnX.isEnabled = !isDisable
        self.isShowBackBtn = !isDisable
        if(isDisable){
            indicator.style = UIActivityIndicatorView.Style.whiteLarge
            indicator.color = .black
            mapV.addSubview(indicator)
            mapV.bringSubviewToFront(indicator)
            indicator.startAnimating()
            indicator.center = mapV.center
        }else{
            indicator.removeFromSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(popToRoot), name: .bookingFastEnd, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(popToRoot), name: .bookingFastCancel, object: nil)

        self.tf_end.text = start_address
        self.view_price.isHidden = true
        self.view_route.isHidden = false
        self.view.sendSubviewToBack(mapV)
        self.initComponents()
        self.setupRxData()
        self.setupRxAction()
        //Location Manager code to fetch current location
        self.initializeTheLocationManager()
    }
    
    @objc func popToRoot(){
        DispatchQueue.main.async {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func initComponents(){
        PLoadingActivity.shared.show(type: .ballScaleMultiple, message: "MAP_LOADING".localized(), thresholdTime: 0, autoHide: false)
        
        
        self.title = "BOOKING_NOW".localized()
        self.createLocationBarBtn()
        // add driver view
        self.contenView.addSubview(self.driverView)
        self.driverView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.lessThanOrEqualTo(500)
        }
        self.contenView.bringSubviewToFront(self.driverView)
        self.driverView.isHidden = true
        
        // add view_price
        self.contenView.addSubview(self.view_price)
        self.view_price.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.greaterThanOrEqualTo(350)
        }
        
        self.contenView.bringSubviewToFront(self.view_price)
        self.view_price.isHidden = true
        
        // add loading view
        self.contenView.addSubview(self.view_loading)
        self.view_loading.snp.makeConstraints {
            $0.top.equalToSuperview()
        }
        self.contenView.bringSubviewToFront(self.view_loading)
        self.view_loading.isHidden = true
        
        // setup language
        self.setupLanguage()
    }
    
    func setupLanguage() {
        self.tf_end.placeholder = "CHOSE_PLACE".localized()
        self.tf_start.placeholder = "CHOSE_PLACE".localized()
        
        self.bookingButton.setTitle("BOOKING".localized(), for: .normal)
        self.chooseVehicleType.text = "CHOOSE_VEHICLE_TYPE".localized()
        self.payTypeLabel.text = "PAY_TYPE".localized()
        self.promotionCodeLabel.text = "PROMOTION_CODE".localized()
        
        // driver view
        self.cancelButton.setTitle("CANCEL_BOOKING".localized(), for: .normal)
        self.driverTotalLabel.text = "DRIVER_TOTAL".localized()
        //        self.driverStartPointLabel.text = "DRIVER_START_POINT".localized()
        //        self.driverEndPointLabel.text = "DRIVER_END_POINT".localized()
        self.driverLabel.text = "DRIVER_LABEL".localized()
        self.licensePlateLabel.text = "LICENSE_PLATE".localized()
        self.callDriverButton.setTitle("CALL_DRIVER".localized(), for: .normal)
    }
    
    func setupRxData() {
        self.viewModel.booking.asDriver()
            .drive(onNext: { [weak self] booking in
                guard booking != nil else { return }
                
                self?.driverStartpoint.text = "DRIVER_START_POINT".localized() + " : " + (booking?.place_begin ?? "")
                self?.driverEndPoint.text = "DRIVER_END_POINT".localized() + " : " + (booking?.place_end ?? "")
                // show status booking
                if booking?.status == 1 {
                    self?.statusLabel.text = "Đang chờ lái xe"
                    
                    // hidden backButton
                    self?.isShowBackBtn = true
                    self?.configBackButton()
                    
                } else if booking?.status == 2 {
                    self?.isShowBackBtn = true
                    self?.configBackButton()
                    self?.statusLabel.text = "Đang di chuyển"
                }  else if booking?.status == 5 || booking?.status == 6 {
                    self?.popToRoot()
                }else {
                    self?.isShowBackBtn = true
                    self?.configBackButton()
                }
                
                let price = AppManager.shared.numberFormetter.string(from: NSNumber(value: booking?.fee ?? 0))
                self?.driverPriceLabel.text = "\(price ?? "0")đ"
            })
            .disposed(by: myBag)
        
        self.viewModel.selectedCar.asDriver()
            .drive(onNext: { [weak self] car in
                self?.lb_type_car.text = car?.verhicleName
                let price = AppManager.shared.numberFormetter.string(from: NSNumber(value: car?.data.fee ?? 0))
                self?.lb_type_car_price.text = "\(price ?? "0")đ"
                self?.totalPriceLabel.text = "\(price ?? "0")đ"
                //self?.driverPriceLabel.text = "\(price ?? "0")đ"
            })
            .disposed(by: myBag)
        
        viewModel.listVehicle.asDriver()
            .drive(onNext: { [weak self] list in
                if list.isEmpty { return }
                self?.viewModel.selectedCar.accept(list.first)
                
                // Show price view
                self?.view_price.isHidden = false
                self?.view_route.isHidden = true
            })
            .disposed(by: myBag)
        
        viewModel.promotionSelected.asDriver()
            .drive(onNext: { [weak self] promotion in
                if let self = self,
                    let model = promotion {
                    self.btn_coupon.setTitle(model.giftCode, for: .normal)
                } else {
                    self?.btn_coupon.setTitle("YOUR_PROMOTIONAL_CODE".localized(), for: .normal)
                }
                // update price
                self?.viewModel.getVehicleAction.onNext(promotion?.ID)
            })
            .disposed(by: myBag)
        
        viewModel.isHiddenDriverView.asDriver().drive(onNext: { [weak self] isHidden in
            if !isHidden {
                self?.driverView.isHidden = false
                self?.view_price.isHidden = true
                self?.indicator.removeFromSuperview()
            }
        }).disposed(by: myBag)
        
        viewModel.isHiddenStatusViewView.asDriver().drive(self.statusView.rx.isHidden).disposed(by: myBag)
        
        viewModel.driverModel.asDriver()
            .drive(onNext: { [weak self] model in
                guard let model = model,
                    let self = self else { return }
                
                self.driverNameLabel.text = model.userName
                self.carNameLabel.text = model.vehicleKin
                self.carColorLabel.text = model.color
                self.licensePlate.text = model.license
                if let url = URL.init(string: model.avatarUrl){
                    self.avatar_driver.kf.setImage(with: url)
                }
            })
            .disposed(by: myBag)
        
        // pop viewcontroller
        viewModel.popViewController.asDriver()
            .drive(onNext: { [weak self] isPop in
                if let isPop = isPop, isPop == true {
                    self?.navigationController?.popViewController(animated: true)
                }
            })
            .disposed(by: myBag)
        
        viewModel.currentAction.asDriver().drive(onNext: { [weak self] isPop in
            if(isPop){
                self?.bookingButton.setTitle("Huỷ", for: .normal)
            }else{
                self?.bookingButton.setTitle("Đặt xe", for: .normal)
            }
            self?.disableControlsOnBooking(isDisable: isPop)
        }).disposed(by: myBag)
        

    }
    
    func setupRxAction() {
        // Tap on driverInfoView
        self.driverInfoView.rx.tapGesture().when(.recognized).asObservable()
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                let viewModel = ProfileVM(driverModel: self.viewModel.driverModel.value ?? DriverModel())
                self.navigationController?.pushViewController(ProfileVC(viewModel: viewModel), animated: true)
            })
            .disposed(by: myBag)
    }
    
    func createLocationBarBtn(){
        let cusView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 44, height: 44))
        let button = UIButton.init(frame: cusView.bounds)
        button.setImage(UIImage.init(named: "ic_your_location"), for: .normal)
        button.addTarget(self, action: #selector(targetCurrentLocation), for: .touchUpInside)
        cusView.addSubview(button)
        button.frame = cusView.bounds
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: cusView)
    }
    
    
    func actionAttachMessage() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let list = self.viewModel.listVehicle.value
        if list.isEmpty { return }
        for car in list {
            let price = AppManager.shared.numberFormetter.string(from: NSNumber(value: car.data.original_fee ))
            
            let action = UIAlertAction(title: "\(car.verhicleName) - \(price ?? "0")đ", style: .default) { action in
                self.viewModel.selectedCar.accept(car)
            }
            alert.addAction(action)
        }
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel))
        present(alert, animated: true)
    }
    
    
    //MARK: Button Action
    
    @IBAction func on_coupon(_ sender: Any) {
        PromotionViewVC.showView { [weak self] model in
            self?.viewModel.promotionSelected.accept(model)
        }
    }
    
    @IBAction func on_pay_type(_ sender: Any) {
        
    }
    
    @IBAction func on_car_type(_ sender: Any) {
        self.actionAttachMessage()
    }
    
    @IBAction func on_back(_ sender: Any) {
        switch self.type {
        case BookingType.airport:
            
            break
        case BookingType.airport_back:
            
            break
        case BookingType.province:
            
            break
        case BookingType.fast:
            self.view_price.isHidden = true
            self.view_route.isHidden = false
            break
        }
        
    }
    
    @IBAction func on_done(_ sender: Any) {
        switch self.type {
        case BookingType.airport:
            
            break
        case BookingType.airport_back:
            
            break
        case BookingType.province:
            
            break
        case BookingType.fast:
            var message: String = "Bạn có chắc muốn đặt xe không?"
            var title: String = "Đặt xe"
            if(self.viewModel.currentAction.value){
                message = "Bạn có chắc muốn huỷ chuyến không?"
                title = "Huỷ chuyến"
            }
            let alert = UIAlertController(title: title.localized(), message: message.localized(), preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Có", style: .default) { (_) in
                if(!self.viewModel.currentAction.value){
                    self.viewModel.bookingFastAction.onNext(())
                }else{
                    self.cancelBooking()
                }
            }
            
            let cancelAction = UIAlertAction(title: "Không".localized(), style: .cancel) { (_) in
                return
            }
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func on_cancel_promotion(_ sender: Any) {
        switch self.type {
        case BookingType.airport:
            print("airport")
            
        case BookingType.airport_back:
            print("airport_back")
            
        case BookingType.province:
            print("province")
            
        case BookingType.fast:
            self.viewModel.promotionSelected.accept(nil)
        }
    }
    
    @IBAction func call_driver(_ sender: Any) {
        AppCoordinator.shared.callToDriver(driverNumber: self.viewModel.driverModel.value?.phoneNumber ?? "")
    }
    
    @IBAction func cancel_booking(_ sender: Any) {
        cancelBooking()
    }
    
    func cancelBooking() -> Void {
        switch self.type {
        case BookingType.airport:
            print("airport")
            
        case BookingType.airport_back:
            print("airport_back")
            
        case BookingType.province:
            print("province")
            
        case BookingType.fast:
            ReasonDeclineView.showView { (reason, cancel) in
                if cancel {
                    if self.viewModel.isLookingDriver.value {
                        self.viewModel.cancelBookingAction.onNext((self.viewModel.bookingID.value!, reason))
                    } else {
                        if let id = self.viewModel.booking.value?.id {
                            self.viewModel.cancelBookingAction.onNext((id, reason))
                        }
                        
                    }
                }
            }
        }
    }
    
    func initializeTheLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @objc func targetCurrentLocation(){
        if let place = self.mapView!.myLocation{
            self.mapView.clear()
            
            let placesClient = GMSPlacesClient.shared()
            
            let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.coordinate.rawValue) | UInt(GMSPlaceField.formattedAddress.rawValue))!
            
            placesClient.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: fields) { (placeLikelihoods, error) in
                if let error = error {
                    // TODO: Handle the error.
                    print("Current Place error: \(error.localizedDescription)")
                    
                    // hide loading to manual select start coordinate
                    PLoadingActivity.shared.hide()
                    self.view_loading.isHidden = true
                    // show note to tf_start
                    return
                }
                
                // Get likely places and add to the list.
                if let likelihoodList = placeLikelihoods {
                    var count = 0
                    for likelihood in likelihoodList {
                        let place = likelihood.place
                        self.likelyPlaces.append(place)
                        count += 1
                        if(count == 1){
                            // Creates a marker in the center of the map.
                            let marker = GMSMarker()
                            marker.position = place.coordinate
                            marker.title = self.likelyPlaces.first?.formattedAddress
                            //      marker.snippet = "Australia"
                            marker.map = self.mapView
                            
                            self.cameraMoveToLocation(toLocation: place.coordinate)
                            // fake drivers
                            self.initFakeDrivers(current: place.coordinate)
                            
                            self.startCor = place.coordinate
                            self.viewModel.startPoint.accept(place.coordinate)
                            
                            self.tf_start.text = self.likelyPlaces.first?.formattedAddress
                            self.viewModel.placeBegin.accept(self.likelyPlaces.first?.formattedAddress ?? "")
                            
                            if let id = place.placeID {
                                let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.addressComponents.rawValue) | UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.coordinate.rawValue) | UInt(GMSPlaceField.formattedAddress.rawValue))!
                                placesClient.fetchPlace(fromPlaceID: id, placeFields: fields, sessionToken: nil) { (place, error) in
                                    if let error = error {
                                        print("api error : \(error.localizedDescription)")
                                        return
                                    }
                                    
                                    
                                    // get province name
                                    guard let place = place else { return }
                                    guard let addressArr = place.addressComponents, !addressArr.isEmpty else { return }
                                    for i in addressArr {
                                        if i.type == "administrative_area_level_1" {
                                            self.viewModel.provinceName.accept(i.name)
                                            break
                                        }
                                    }
                                }
                            }
                            
                            
                            self.view_loading.isHidden = true
                            PLoadingActivity.shared.hide()
                            return
                        }
                    }
                }
                
                
            }
        }
    }
    
    
    // show random location driver
    // 1km = 0.00900900900901°
    func initFakeDrivers(current: CLLocationCoordinate2D) {
        for _ in 1...20 {
            let randomLat = Double.random(in: (current.latitude - 2 * 0.00900900900901) ... (current.latitude + 2 * 0.00900900900901))
            let randonLng = Double.random(in: (current.longitude - 2 * 0.00900900900901) ... (current.longitude + 2 * 0.00900900900901))
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: randomLat, longitude: randonLng)
            marker.icon = UIImage(named: "faked_car")?.resize(width: 40, height: 40)
            marker.map = self.mapView
        }
    }
    
    // get position callback
    func getPosition(place: GMSPlace) -> Position {
        let position = Position()
        
        if let place_id = place.placeID{
            position.place_id = place_id
        }
        if let format_address = place.formattedAddress{
            position.format_address = format_address
        }
        
        if let lat:Double? = place.coordinate.latitude{
            position.lat = Float(lat ?? 0)
        }
        
        if let long:Double? = place.coordinate.longitude{
            position.long = Float(long ?? 0)
        }
        return position
    }
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 18)
        if mapView == nil{
            mapView = GMSMapView.map(withFrame: self.mapV.bounds, camera: camera)
            mapView.isMyLocationEnabled = true
            self.mapV.addSubview(mapView)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.targetCurrentLocation()
            }
        }
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
    }
    
    func cameraMoveToLocation(toLocation: CLLocationCoordinate2D?) {
        if toLocation != nil {
            self.mapView.camera = GMSCameraPosition.camera(withTarget: toLocation!, zoom: 18)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

//MARK: - Helper
extension MapViewController {
    
}

//MARK: - UITextFieldDelegate, GMSAutocompleteViewControllerDelegate

extension MapViewController: UITextFieldDelegate, GMSAutocompleteViewControllerDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.tf_start{
            self.view.endEditing(true)
            self.autocompleteClicked(startPlace: true)
            return false
        }else if textField == self.tf_end{
            self.view.endEditing(true)
            self.autocompleteClicked(startPlace: false)
            return false
        }
        
        return true
    }
    
    func findDirection(fromOrigin:String,toDestination:String){
        
        let ggdirectionkey = "AIzaSyC0dzfvvstD0an8jDoZKwK0-YUWXjZPVSY"
        //Here you need to set your origin and destination points and mode
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(fromOrigin)&destination=\(toDestination)&mode=driving&key=\(ggdirectionkey)")
        
        //OR if you want to use latitude and longitude for source and destination
        //let url = NSURL(string: "\("https://maps.googleapis.com/maps/api/directions/json")?origin=\("17.521100"),\("78.452854")&destination=\("15.1393932"),\("76.9214428")")
        
        let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) -> Void in
            
            do {
                if data != nil {
                    let dic = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as!  [String:AnyObject]
                    
                    let status = dic["status"] as! String
                    var routesArray:String!
                    if status == "OK" {
                        routesArray = (((dic["routes"]!as! [Any])[0] as! [String:Any])["overview_polyline"] as! [String:Any])["points"] as? String
                    }
                    
                    DispatchQueue.main.async {
                        let path = GMSPath.init(fromEncodedPath: routesArray!)
                        let singleLine = GMSPolyline.init(path: path)
                        singleLine.strokeWidth = 6.0
                        singleLine.strokeColor = UIColor.init(hexString: "#75D595")!
                        singleLine.map = self.mapView
                        self.mapView.camera = GMSCameraPosition.camera(withTarget: self.startCor!, zoom: 13)
                    }
                    
                }
            } catch {
                print("Error")
            }
        }
        
        task.resume()
    }
    
    
    // Present the Autocomplete view controller when the button is pressed.
    @objc func autocompleteClicked(startPlace:Bool) {
        let autocompleteController = GMSAutocompleteViewController()
        // setup textColor for SearchBar textfield
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        autocompleteController.delegate = self
        
        self.startPlace = startPlace
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.addressComponents.rawValue) | UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.coordinate.rawValue) | UInt(GMSPlaceField.formattedAddress.rawValue) | UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.phoneNumber.rawValue))!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        autocompleteController.autocompleteFilter = filter
        
        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = place.coordinate
        marker.title = place.formattedAddress
        marker.map = mapView
        
        self.cameraMoveToLocation(toLocation: place.coordinate)
        
        if self.startPlace {
            
            let placesClient = GMSPlacesClient.shared()
            if let id = place.placeID {
                let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.addressComponents.rawValue) | UInt(GMSPlaceField.placeID.rawValue) | UInt(GMSPlaceField.coordinate.rawValue) | UInt(GMSPlaceField.formattedAddress.rawValue))!
                placesClient.fetchPlace(fromPlaceID: id, placeFields: fields, sessionToken: nil) { (place, error) in
                    if let error = error {
                        print("api error : \(error.localizedDescription)")
                        return
                    }
                    
                    // get province name
                    guard let place = place else { return }
                    guard let addressArr = place.addressComponents, !addressArr.isEmpty else { return }
                    for i in addressArr {
                        if i.type == "administrative_area_level_1" {
                            self.viewModel.provinceName.accept(i.name)
                            
                            self.startCor = place.coordinate
                            self.viewModel.startPoint.accept(place.coordinate)
                            self.tf_start.text = place.formattedAddress
                            self.viewModel.placeBegin.accept(place.formattedAddress ?? "")
                            guard let _ = self.endCor else {
                                self.dismiss(animated: true, completion: nil)
                                return
                            }
                            // API get bill when not selected yet promotion
                            self.viewModel.getVehicleAction.onNext(nil)
                            self.dismiss(animated: true, completion: nil)
                            break
                        }
                    }
                }
            }
        }else{
            self.endCor = place.coordinate
            self.viewModel.endPoint.accept(place.coordinate)
            self.tf_end.text = place.formattedAddress
            self.viewModel.placeEnd.accept(place.formattedAddress ?? "")
            guard let _ = self.startCor else {
                self.dismiss(animated: true, completion: nil)
                return
            }
            // API get bill when not selected yet promotion
            self.viewModel.getVehicleAction.onNext(nil)
            self.dismiss(animated: true, completion: nil)
        }
        
        guard let startCor = self.startCor, let endCor = self.endCor else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        // draw derection
        self.findDirection(fromOrigin: "\(startCor.latitude),\(startCor.longitude)", toDestination: "\(endCor.latitude),\(endCor.longitude)")
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
}
