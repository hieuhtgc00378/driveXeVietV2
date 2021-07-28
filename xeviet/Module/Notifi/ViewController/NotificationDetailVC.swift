//
//  NotificationDetailVC.swift
//  xeviet
//
//  Created by Hieu Ha trung on 02/07/2021.
//  Copyright © 2021 eagle. All rights reserved.
//

import UIKit

class NotificationDetailVC: BaseViewController {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    
    var myTitle: String? = ""
    var myTime: String? = ""
    var myContent: String? = ""
    
    @IBOutlet weak var topContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblTitle.text = myTitle
        lblTime.text = myTime
        lblContent.text = myContent
        topContainer.backgroundColor = UIColor(white: 1, alpha: 0)

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
