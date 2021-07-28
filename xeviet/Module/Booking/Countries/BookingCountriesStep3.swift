//
//  BookingCountriesStep3.swift
//  Xe TQT
//
//  Created by Admin on 5/20/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import UIKit
import DropDown
import RxCocoa
import RxSwift


class BookingCountriesStep3: BaseViewController {
    @IBOutlet weak var height_tb: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    @IBOutlet weak var dropView: UIView!
    @IBOutlet weak var lb_car_type: UILabel!
    
    var myBag = DisposeBag()
    var totalRoute: [CountriesRoute] = []
    var list_airport: [CountriesRoute] = []
    var vehicleList = [VehicleTypeModel]()
    let dropDown = DropDown()
    
    // MARK: - Init
    init(routeModel: RouteModel) {
        super.init(nibName: "BookingCountriesStep3", bundle: nil)
        self.getRouteList(model: routeModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: BookingCountriesStep3Cell.nameOfClass, bundle: nil), forCellReuseIdentifier: BookingCountriesStep3Cell.nameOfClass)
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableView.automaticDimension
        
        
        self.initData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = "Đặt xe liên tỉnh"
        self.height_tb.constant = self.tableView.contentSize.height
    }
    
    func initData() {
        self.getVehicleList()
    }
    
    
    @IBAction func on_show_menu(_ sender: Any) {
        self.dropDown.show()
    }
    
    
    
    func setupDropdownMenuToView(view: UIView){
        // The view to which the drop down will appear on
        dropDown.anchorView = view // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        let data: [String] = ["Tất cả"] + self.vehicleList.map { $0.verhicleAirportType.getString()}
        dropDown.dataSource = data
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.lb_car_type.text = item
            // reload tableView
            if index == 0 {
                if self.list_airport != self.totalRoute {
                    self.list_airport = self.totalRoute
                    self.tableView.reloadData()
                } else {
                    return
                }
                
            } else {
                var type = index
                for i in self.vehicleList {
                    if i.verhicleAirportType.getString() == item {
                        type = i.verhicleAirportType.rawValue
                    }
                }
                
                self.list_airport = self.totalRoute.filter { $0.type == type }
                self.tableView.reloadData()
            }
            
        }
    }
    
    func getRouteList(model: RouteModel) {
        let param: PARAM = [
            "place_begin_id" : model.placeBeginID,
            "place_end_id" : model.placeEndID
        ]
        
        FastBookingServices.getRideList(param).asObservable()
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let list):
                    self?.list_airport = list
                    self?.totalRoute = list
                    self?.tableView.reloadData()
                case .failure(let error):
                    AppMessagesManager.shared.showMessage(messageType: .error, message: error.message)
                }
            })
        .disposed(by: myBag)
        
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
extension BookingCountriesStep3: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list_airport.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:BookingCountriesStep3Cell = tableView.dequeueReusableCell(withIdentifier: BookingCountriesStep3Cell.nameOfClass, for: indexPath) as! BookingCountriesStep3Cell
        cell.selectionStyle = .none
        cell.viewModel = CountriesRouteVM(model: self.list_airport[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension BookingCountriesStep3 {
    
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
