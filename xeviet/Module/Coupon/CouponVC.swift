//
//  CouponVC.swift
//  xeviet
//
//  Created by Admin on 7/14/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import UIKit
import RxSwift

class CouponVC: BaseViewController {
    @IBOutlet weak var height_tb: NSLayoutConstraint!
      
    @IBOutlet weak var tableView: UITableView!
    
    let myBag = DisposeBag()

    var listCoupon : [Coupon] = [Coupon]()
    // MARK: - Init
        init() {
           super.init(nibName: "CouponVC", bundle: nil)
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TITLE_COUPON".localized()
           tableView.delegate = self
           tableView.dataSource = self
           tableView.register(UINib.init(nibName: CouponCell.nameOfClass, bundle: nil), forCellReuseIdentifier: CouponCell.nameOfClass)
           self.tableView.estimatedRowHeight = 60
           self.tableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.height_tb.constant = self.tableView.contentSize.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getListCoupon()
    }

    func getListCoupon(){
        PLoadingActivity.shared.show(type: .ballScaleMultiple, message: "LOADING_GET_LIST_COUPON".localized(), thresholdTime: 2, autoHide: false)

         MainServices.listCoupon().asObservable()
                           .subscribe(onNext: { [unowned self] result in
            PLoadingActivity.shared.hide()
               switch result {
               case .success(let list):
                    self.listCoupon = list
                    self.tableView.reloadData()
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

extension CouponVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCoupon.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CouponCell = tableView.dequeueReusableCell(withIdentifier: CouponCell.nameOfClass, for: indexPath) as! CouponCell
        let coupon = listCoupon[indexPath.row]
        cell.lb_name.text = coupon.title
        cell.lb_time.text = "Thời gian: Từ \((coupon.start_time.iso8601withFractionalSeconds != nil) ? coupon.start_time.iso8601withFractionalSeconds!.toFullDateUTC : Date().toFullDateUTC) đến \((coupon.end_time.iso8601withFractionalSeconds != nil) ? coupon.end_time.iso8601withFractionalSeconds!.toFullDateUTC : Date().toFullDateUTC)"
        
        if coupon.getAmount_discount() != 0{
            cell.lb_value.text = "Giá trị: \(coupon.getAmount_discount().convertToVND())"
        }else{
            cell.lb_value.text = "Giá trị: \(coupon.percent_discount)%"
        }
        cell.lb_target.text = coupon.descriptions
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
