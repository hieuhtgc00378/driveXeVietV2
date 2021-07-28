//
//  NotifiVC.swift
//  xeviet
//
//  Created by Hieu Ha trung on 01/07/2021.
//  Copyright © 2021 eagle. All rights reserved.
//

import Foundation
import UIKit
import SwiftMessages
import RxSwift
import RxCocoa

class NotifiVC: BaseViewController {

    @IBOutlet var container: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    private let myBag: DisposeBag = DisposeBag()
    var callBack: ((NotificationModel) -> Void)?
    
    var currentPage = 1

    var listNotification: [NotificationModel] = [NotificationModel]()

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        self.title = "NOTIFICATION".localized()
        //self.configBackButton()
        
         tableView.delegate = self
         tableView.dataSource = self
         tableView.register(UINib.init(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "NotificationTableViewCell")
         tableView.rowHeight = UITableView.automaticDimension
         tableView.separatorColor = UIColor.black
        getListNotification()

    }
    
//    @objc override func popVC(){
//           self.navigationController?.popViewController(animated: true)
//       }
//
//    override func configBackButton(){
//          let cusView = UIView.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
//          let btnBack = UIButton.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
//          btnBack.setImage(UIImage.init(named: "ic_back"), for: .normal)
//          btnBack.addTarget(self, action: #selector(popVC), for: .touchUpInside)
//          cusView.addSubview(btnBack)
//          btnBack.frame = cusView.bounds
//          self.navigationItem.backBarButtonItem = UIBarButtonItem(customView: cusView)
//      }
    
    func getListNotification(){
        if !PLoadingActivity.shared.isLoading(){
            PLoadingActivity.shared.show(type: .ballScaleMultiple, message: "LOADING_GET_LIST_NOTIFICATION".localized(), thresholdTime: 2, autoHide: false)

                 MainServices.listnotificationPaging(page: currentPage).asObservable()
                                   .subscribe(onNext: { [unowned self] result in
                    PLoadingActivity.shared.hide()
                       switch result {
                       case .success(let list):
                            if list.count == 0 && self.currentPage > 1{
                                self.currentPage -= 1
                                return
                            }
                           self.listNotification.append(contentsOf: list)
                        self.tableView.reloadData()
                       case .failure(let error):
                           self.currentPage -= 1
                           AppMessagesManager.shared.showMessage(messageType: .error, message: error.message)
                       }
                   })
               .disposed(by: myBag)
        }
    }
    
}

extension NotifiVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listNotification.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NotificationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        cell.selectionStyle = .none
        let notification = listNotification[indexPath.row]
        cell.lblTitle.text = notification.title
        cell.lblContent.text = notification.content
        cell.lblTime.text = notification.created_at
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 12
        cell.backgroundColor = .clear
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notificationDetailVC = NotificationDetailVC()
        notificationDetailVC.myTitle = listNotification[indexPath.row].title
        notificationDetailVC.myTime = listNotification[indexPath.row].created_at
        notificationDetailVC.myContent = listNotification[indexPath.row].content 
        self.navigationController?.pushViewController(notificationDetailVC, animated: true)
    }
    
}
