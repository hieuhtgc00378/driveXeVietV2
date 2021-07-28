//
//  BookingAirPortStep1.swift
//  Xe TQT
//
//  Created by Admin on 5/9/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class BookingAirPortStep1: BaseViewController {
   
    @IBOutlet weak var lb_booking_airport_step1: UILabel!
    
    @IBOutlet weak var height_tb: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    let mybag = DisposeBag()
    var list_airport = [Position]()
    
    var selectedIndex = -1
    var booking:Booking!
    
    // MARK: - Init
     init() {
        super.init(nibName: "BookingAirPortStep1", bundle: nil)
     }

     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.height_tb.constant = self.tableView.contentSize.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getListAirPort()
        
        if booking.type == BookingType.airport.rawValue{
            self.lb_booking_airport_step1.text = "LB_BOOKING_STEP1_AIRPORT".localized()
            self.title = "BOOKING_AIRPORT".localized()
        }else{
            self.lb_booking_airport_step1.text = "LB_BOOKING_STEP1_AIRPORT_BACK".localized()
            self.title = "BOOKING_AIRPORT_BACK".localized()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: AirPortCell.nameOfClass, bundle: nil), forCellReuseIdentifier: AirPortCell.nameOfClass)
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }
    
    func getListAirPort() {
        MainServices.getPosition(type: 2).asObservable().subscribe(onNext: {[weak self] result in
            switch result {
            case .success(let airports):
                self?.list_airport = airports
                self?.tableView.reloadData()
                self?.height_tb.constant = self?.tableView.contentSize.height as! CGFloat
            case .failure(let error):
                AppMessagesManager.shared.showMessage(messageType: .error, message: error.message)
            }
        })
        .disposed(by: mybag)
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

extension BookingAirPortStep1: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list_airport.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:AirPortCell = tableView.dequeueReusableCell(withIdentifier: AirPortCell.nameOfClass, for: indexPath) as! AirPortCell
        cell.lb_name.text = list_airport[indexPath.row].name
        if indexPath.row == self.selectedIndex{
            cell.bg.backgroundColor = UIColor.init(hexString: "#1353CB")
        }else{
            cell.bg.backgroundColor = UIColor.clear
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        if booking.type == BookingType.airport.rawValue{
            self.booking.place_end_id = list_airport[indexPath.row].place_id
            self.booking.airport_id = list_airport[indexPath.row].id
            self.booking.place_end = list_airport[indexPath.row].name
        }else{
            self.booking.place_begin_id = list_airport[indexPath.row].place_id
            self.booking.airport_id = list_airport[indexPath.row].id
            self.booking.place_begin = list_airport[indexPath.row].name
        }
        
        let bookingAirPortStep2 = BookingAirPortStep2(isBookingAirport: true)
        bookingAirPortStep2.booking = self.booking
        self.navigationController?.pushViewController(bookingAirPortStep2, animated: true)
    }
    
}
