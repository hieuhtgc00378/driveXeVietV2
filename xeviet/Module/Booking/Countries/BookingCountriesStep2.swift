//
//  BookingCountriesStep2.swift
//  Xe TQT
//
//  Created by Admin on 5/20/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BookingCountriesStep2: BaseViewController {
    @IBOutlet weak var height_tb: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var myBag = DisposeBag()
    var routeList:[RouteModel] = []
    
    // MARK: - Init
    init(routeID: String) {
        super.init(nibName: "BookingCountriesStep2", bundle: nil)
        
        self.getRouteList(routeID: routeID)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = "Đặt xe liên tỉnh"
        self.height_tb.constant = self.tableView.contentSize.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: CountriesCell.nameOfClass, bundle: nil), forCellReuseIdentifier: CountriesCell.nameOfClass)
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }
    
    func getRouteList(routeID: String) {
        FastBookingServices.getRouteList(routeID: routeID).asObservable()
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let list):
                    self?.routeList = list
                    self?.tableView.reloadData()
                case .failure(let error):
                    AppMessagesManager.shared.showMessage(messageType: .error, message: error.message)
                }
            })
        .disposed(by: myBag)
    }
    
}
extension BookingCountriesStep2: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CountriesCell = tableView.dequeueReusableCell(withIdentifier: CountriesCell.nameOfClass, for: indexPath) as! CountriesCell
        cell.lb_name.text = routeList[indexPath.row].routeName
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = BookingCountriesStep3(routeModel: self.routeList[indexPath.row])
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
