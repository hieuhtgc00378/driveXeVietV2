//
//  BookingCountriesStep1.swift
//  Xe TQT
//
//  Created by Admin on 5/20/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BookingCountriesStep1: BaseViewController {
    @IBOutlet weak var height_tb: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    var list_airport = [Position]()
    let myBag = DisposeBag()
    
    // MARK: - Init
    init() {
        super.init(nibName: "BookingCountriesStep1", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = "ORDER_INTERCITY_VEHICLES".localized()
        self.height_tb.constant = self.tableView.contentSize.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getProvinceList()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: CountriesCell.nameOfClass, bundle: nil), forCellReuseIdentifier: CountriesCell.nameOfClass)
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 10))
        // Do any additional setup after loading the view.
    }
    
    func getProvinceList() {
        MainServices.getPosition(type: 1).asObservable().subscribe(onNext: {[weak self] result in
            switch result {
            case .success(let city):
                self?.list_airport = city
                self?.tableView.reloadData()
            case .failure(let error):
                AppMessagesManager.shared.showMessage(messageType: .error, message: error.message)
            }
        }).disposed(by: myBag)
    }
    
}
extension BookingCountriesStep1: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list_airport.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CountriesCell = tableView.dequeueReusableCell(withIdentifier: CountriesCell.nameOfClass, for: indexPath) as! CountriesCell
        cell.lb_name.text = list_airport[indexPath.row].name
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let placeID: String = self.list_airport[indexPath.row].place_id
        if !placeID.isEmpty {
            let bookingCountriesStep2 = BookingCountriesStep2(routeID: placeID)
            bookingCountriesStep2.isShowBackBtn = true
            self.navigationController?.pushViewController(bookingCountriesStep2, animated: true)
        }
    }
    
}
