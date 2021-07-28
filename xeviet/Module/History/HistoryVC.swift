//
//  HistoryVC.swift
//  Xe TQT
//
//  Created by Admin on 5/25/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import UIKit
import ESPullToRefresh
import RxSwift

class HistoryVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var currentPage = 1
    let myBag = DisposeBag()

    var listBooking:[Booking] = [Booking]()
    // MARK: - Init
    init() {
       super.init(nibName: "HistoryVC", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getListBooking()
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        self.title = "HISTORY".localized()
        self.configBackButton()
        
         tableView.delegate = self
         tableView.dataSource = self
         tableView.register(UINib.init(nibName: HistoryCell.nameOfClass, bundle: nil), forCellReuseIdentifier: HistoryCell.nameOfClass)
         self.tableView.estimatedRowHeight = 60
         self.tableView.rowHeight = UITableView.automaticDimension
             // Do any additional setup after loading the view.
        self.setupPullToRefresh()
        self.addLoadMoreUI()
    }
    
    @objc func popVC(){
           self.navigationController?.popViewController(animated: true)
       }
    
    func configBackButton(){
          let cusView = UIView.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
          let btnBack = UIButton.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
          btnBack.setImage(UIImage.init(named: "ic_back"), for: .normal)
          btnBack.addTarget(self, action: #selector(popVC), for: .touchUpInside)
          cusView.addSubview(btnBack)
          btnBack.frame = cusView.bounds
          self.navigationItem.backBarButtonItem = UIBarButtonItem(customView: cusView)
      }
    
    func getListBooking(){
        if !PLoadingActivity.shared.isLoading(){
            PLoadingActivity.shared.show(type: .ballScaleMultiple, message: "LOADING_GET_LIST_BOOKING".localized(), thresholdTime: 2, autoHide: false)

                 MainServices.listBooking(page: currentPage).asObservable()
                                   .subscribe(onNext: { [unowned self] result in
                    PLoadingActivity.shared.hide()
                       switch result {
                       case .success(let list):
                            if list.count == 0 && self.currentPage > 1{
                                self.currentPage -= 1
                                return
                            }
                           self.listBooking.append(contentsOf: list)
                           self.reloadListBooking()
                       case .failure(let error):
                           self.currentPage -= 1
                           AppMessagesManager.shared.showMessage(messageType: .error, message: error.message)
                       }
                   })
               .disposed(by: myBag)
        }
    }
    
    func setupPullToRefresh() {
          self.tableView.es.addPullToRefresh {
              [weak self] in
            self?.currentPage = 1
            self?.listBooking = [Booking]()
            self?.getListBooking()
          }
        self.tableView.header?.alpha = 0
      }
    
    func addLoadMoreUI() {
         self.tableView.es.addInfiniteScrolling {
             [weak self] in
             self?.currentPage += 1
             self?.getListBooking()
         }
     }
    
    func reloadListBooking(){
        self.tableView.es.stopPullToRefresh()
        self.tableView.es.stopLoadingMore()
        self.tableView.reloadData()
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

extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listBooking.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HistoryCell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.nameOfClass, for: indexPath) as! HistoryCell
        cell.selectionStyle = .none
        cell.booking = self.listBooking[indexPath.row]
        cell.bindData()
        return cell
    }
    
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.reloadData()
//    }
    
}
