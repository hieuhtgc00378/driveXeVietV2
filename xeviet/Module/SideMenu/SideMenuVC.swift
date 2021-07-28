//
//  SideMenuVC.swift
//  xeviet
//
//  Created by Admin on 5/29/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import UIKit
import SafariServices

class SideMenuVC: BaseViewController {
    @IBOutlet weak var height_tb: NSLayoutConstraint!
           
    @IBOutlet weak var tableView: UITableView!
    
    let menus = ["Thông tin tài khoản","Chia sẻ bạn bè", "Đăng xuất","Giới thiệu","Điều khoản dịch vụ","Đăng ký làm lái xe","Ý kiến khách hàng"]
    
    init() {
          super.init(nibName: "SideMenuVC", bundle: nil)
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
            self.navigationController!.navigationBar.isTranslucent = true
            self.navigationController!.navigationBar.isHidden = true
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib.init(nibName: SideMenuCell.nameOfClass, bundle: nil), forCellReuseIdentifier: SideMenuCell.nameOfClass)
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
extension SideMenuVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SideMenuCell = tableView.dequeueReusableCell(withIdentifier: SideMenuCell.nameOfClass, for: indexPath) as! SideMenuCell
        cell.selectionStyle = .none
        cell.lb_title.text = menus[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            //thong tin tk
            let userInfoVC = UserInfoVC()
            self.dismiss(animated: true) {
                UIApplication.getTopViewController()?.navigationController?.pushViewController(userInfoVC, animated: true)
            }
        case 4:
                //privacy
               let webVC = SFSafariViewController.init(url: URL.init(string: "http://policies.xeviet.net.vn/passenger/privacy/")!)
               self.present(webVC, animated: true, completion: nil)
        case 5:
                //driver
                let webVC = SFSafariViewController.init(url: URL.init(string: "http://driver.xeviet.net.vn")!)
                self.present(webVC, animated: true, completion: nil)
        case 2:
            self.dismiss(animated: true) {
                AppManager.shared.reset()
                AppDelegate.shared().appCoordinator.showLoginScreen()
            }
        default:
            print("nothing...")
        }
    }
    
}
