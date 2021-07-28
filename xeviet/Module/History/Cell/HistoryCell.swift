//
//  HistoryCell.swift
//  Xe TQT
//
//  Created by Admin on 5/25/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet weak var lb_begin_place: UILabel!
    @IBOutlet weak var lb_end_place: UILabel!
    @IBOutlet weak var lb_date: UILabel!
    @IBOutlet weak var lb_time: UILabel!
    @IBOutlet weak var lb_fee: UILabel!
    
    
    var booking = Booking()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindData(){
        self.lb_begin_place.text = "Điểm xuất phát: \(booking.place_begin)"
          self.lb_end_place.text = "Điểm kết thúc: \(booking.place_end)"
          
        if let time:String? = self.booking.pickup_time{
            if let date:Date = time?.iso8601withFractionalSeconds{
                self.lb_date.text = "Ngày: \(date.toYearMonthDay)"
                self.lb_time.text = "Giờ: \(date.toHourMinUTC)"
            }
        }
          
        if let fee = self.booking.fee{
            self.lb_fee.text = "Tổng: \(fee.convertToVND())"
        }
    }
    
    @IBAction func on_booking(_ sender: Any) {
        let bookingAirPortStep2 = BookingAirPortStep2(isBookingAirport: false)
          bookingAirPortStep2.booking = booking
          UIApplication.getTopViewController()?.navigationController?.pushViewController(bookingAirPortStep2, animated: true)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
