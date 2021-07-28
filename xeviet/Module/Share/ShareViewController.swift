//
//  ShareViewController.swift
//  xeviet
//
//  Created by Admin on 7/2/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import UIKit

class ShareViewController: BaseViewController {

    @IBOutlet weak var lb_url: UILabel!
    @IBOutlet weak var btn_copy: UIButton!
    
    // MARK: - Init
      init() {
         super.init(nibName: "ShareViewController", bundle: nil)
      }

      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SHARE_APP".localized()
        // Do any additional setup after loading the view.
    }

    @IBAction func on_send_sms(_ sender: Any) {
        let items = ["Cài ngay ứng dụng Xe Việt để đặt xe vô cùng tiện lợi. Tôi đã sử dụng và vô cùng hài lòng. Đường dẫn tải app: \("URL")"]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    @IBAction func on_copy(_ sender: Any) {
        AppMessagesManager.shared.showMessage(messageType: .success, message: "COPY_SUCCESS".localized())
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
