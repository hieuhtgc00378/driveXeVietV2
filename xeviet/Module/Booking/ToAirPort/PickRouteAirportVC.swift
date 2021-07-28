//
//  PickRouteAirportVC.swift
//  Xe TQT
//
//  Created by Admin on 5/20/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import UIKit

class PickRouteAirportVC: BaseViewController {
    @IBOutlet weak var height_tb: NSLayoutConstraint!
       
    @IBOutlet weak var tableView: UITableView!
    
    var list_airport = ["BOOKING_AIRPORT".localized(),"BOOKING_AIRPORT_BACK".localized()]
    
    var selectedIndex = -1
    var booking:Booking!

    // MARK: - Init
       init() {
          super.init(nibName: "PickRouteAirportVC", bundle: nil)
       }

       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

    
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         self.title = "BOOK_AIRPORT".localized()
         self.height_tb.constant = self.tableView.contentSize.height
     }
     
     override func viewDidLoad() {
         super.viewDidLoad()
         tableView.delegate = self
         tableView.dataSource = self
         tableView.register(UINib.init(nibName: AirPortCell.nameOfClass, bundle: nil), forCellReuseIdentifier: AirPortCell.nameOfClass)
         self.tableView.estimatedRowHeight = 60
         self.tableView.rowHeight = UITableView.automaticDimension
         // Do any additional setup after loading the view.
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

extension PickRouteAirportVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list_airport.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:AirPortCell = tableView.dequeueReusableCell(withIdentifier: AirPortCell.nameOfClass, for: indexPath) as! AirPortCell
        cell.lb_name.text = list_airport[indexPath.row]
        if indexPath.row == self.selectedIndex{
            cell.bg.backgroundColor = UIColor.init(hexString: "#1353CB")
        }else{
            cell.bg.backgroundColor = UIColor.clear
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.booking = Booking()

        self.selectedIndex = indexPath.row
        if indexPath.row == 0 {
            self.booking.type = BookingType.airport.rawValue
        }else{
            self.booking.type = BookingType.airport_back.rawValue
        }
        let bookingAirPortStep1 = BookingAirPortStep1()
        bookingAirPortStep1.isShowBackBtn = true
        bookingAirPortStep1.booking = self.booking
        self.navigationController?.pushViewController(bookingAirPortStep1, animated: true)
    }
    
}
