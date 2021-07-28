//
//  UserInfoVC.swift
//  xeviet
//
//  Created by Admin on 7/3/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import UIKit
import RxSwift
import GoogleMaps
import GooglePlaces
import DateTimePicker

class UserInfoVC: BaseViewController {

    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var lb_phone: UILabel!
    @IBOutlet weak var lb_birthday: UILabel!
    @IBOutlet weak var lb_address: UILabel!
    @IBOutlet weak var lb_zalo: UILabel!
    @IBOutlet weak var lb_facebook: UILabel!
    @IBOutlet weak var lb_credit: UILabel!
    @IBOutlet weak var lb_credit_amount: UILabel!
    
    @IBOutlet weak var btn_change: PButton!
    @IBOutlet weak var btn_pay: PButton!
    
    @IBOutlet weak var tf_name: PTextField!
    @IBOutlet weak var tf_phone: PTextField!
    @IBOutlet weak var tf_birthday: UITextField!
    @IBOutlet weak var tf_address: PTextField!
    @IBOutlet weak var tf_zalo: PTextField!
    @IBOutlet weak var tf_facebook: PTextField!
    
    var isUpdate = false
    
    let myBag = DisposeBag()
    
    var userInfo = AppManager.shared.user
    
    var picked_date:Date?

    var place: GMSPlace?
    
    // MARK: - Init
   init() {
      super.init(nibName: "UserInfoVC", bundle: nil)
   }

   required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "TITLE_USER_INFO".localized()
        self.configUpdate()

        self.bindData()
        
        PLoadingActivity.shared.show(type: .ballScaleMultiple, message: "LOADING_USER_INFO".localized(), thresholdTime: 0, autoHide: false)

        MainServices.getUserInfo().asObservable()
                   .subscribe(onNext: { [unowned self] result in
                    PLoadingActivity.shared.hide()

                       switch result {
                       case .success(let userInfo):
                           AppManager.shared.user = userInfo
                           self.userInfo = userInfo
                           self.bindData()
                       case .failure(let error):
                           AppMessagesManager.shared.showMessage(messageType: .error, message: error.message)
                       }
                   })
               .disposed(by: myBag)
        // Do any additional setup after loading the view.
    }

    
    func bindData(){
        self.tf_name.text = self.userInfo?.user_name
        self.tf_phone.text = self.userInfo?.phone_number
        self.tf_birthday.text = self.userInfo?.birthdate.toDate()?.toYearMonthDay
        self.tf_address.text = self.userInfo?.address
//        self.tf_name.text = self.userInfo?.user_name
//        self.tf_name.text = self.userInfo?.user_name
    }
    
    func configUpdate(){
        if self.isUpdate{
            self.tf_name.isEnabled = true
            self.tf_phone.isEnabled = false
            self.tf_address.isEnabled = true
            self.tf_zalo.isEnabled = true
            self.tf_facebook.isEnabled = true
            self.tf_birthday.isEnabled = true
        }else{
            self.tf_name.isEnabled = false
            self.tf_phone.isEnabled = false
            self.tf_address.isEnabled = false
            self.tf_zalo.isEnabled = false
            self.tf_facebook.isEnabled = false
            self.tf_birthday.isEnabled = false
        }
    }
    
    func validateField() -> Bool{
        if self.tf_name.text!.isEmpty{
            AppMessagesManager.shared.showMessage(messageType: .error, message: "TF_NAME_EMPTY")
            return false
        }
        
        if self.tf_phone.text!.isEmpty{
            AppMessagesManager.shared.showMessage(messageType: .error, message: "TF_PHONE_EMPTY")
            return false
        }
        
        if self.tf_birthday.text!.isEmpty{
            AppMessagesManager.shared.showMessage(messageType: .error, message: "TF_BIRTHDAY_EMPTY")
            return false
        }
        
        if self.tf_address.text!.isEmpty{
                  AppMessagesManager.shared.showMessage(messageType: .error, message: "TF_ADDRESS_EMPTY")
                  return false
              }
        return true
        
    }
    
    @IBAction func on_pick_address(_ sender: Any) {
        if self.isUpdate{
            let pickAddressVC = PickAddressVC()
            
            pickAddressVC.didCompletePicked = { place in
                print(place)
                self.place = place
                if let address = place.formattedAddress{
                    self.tf_address.text = address
                }
            }
            
            let navi = UINavigationController.init(rootViewController: pickAddressVC)
            navi.modalPresentationStyle = .overCurrentContext
            navi.isNavigationBarHidden = true
            navi.navigationBar.isTranslucent = true
            navi.navigationBar.isHidden = true
            self.present(navi, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func on_pick_day(_ sender: Any) {
        if self.isUpdate{
            DatePickerDialog().show("CHOSE_BIRTHDAY".localized(), doneButtonTitle: "Done".localized(), cancelButtonTitle: "Cancel".localized(), datePickerMode: .date) {
                (date) -> Void in
                if let dt = date {
                    self.tf_birthday.text = dt.toYearMonthDay
                }
            }
        }
    }
    
    @IBAction func on_change(_ sender: Any) {
        self.isUpdate = !self.isUpdate
        self.configUpdate()

        if self.isUpdate{
            self.btn_change.setTitle("BTN_SAVE_TITTLE", for: .normal)
        }else{
            if self.validateField() == true{
                self.btn_change.setTitle("BTN_CHANGE_TITLE", for: .normal)
                          
                 let birthday = tf_birthday.text?.toDate()?.toApiDateFormatString
                 let place_id = self.place?.placeID != nil ? self.place?.placeID : self.userInfo?.place_id
                 let address = self.place?.formattedAddress != nil ? self.place?.formattedAddress : self.userInfo?.address
                 let latitude = self.place?.coordinate.latitude != nil ? self.place?.coordinate.latitude : self.userInfo?.latitude
                 let longitude = self.place?.coordinate.longitude != nil ? self.place?.coordinate.longitude : self.userInfo?.longitude
                
                  PLoadingActivity.shared.show(type: .ballScaleMultiple, message: "UPDATE_PROFILE_LOADING".localized(), thresholdTime: 0, autoHide: false)
                let params = ["user_name" : tf_name.text!, "birthdate" : birthday!, "place_id" : place_id!, "address" : address! , "latitude" : latitude! , "longitude" : longitude!] as [String : Any]
                     MainServices.userUpdateProfile(params).asObservable().subscribe(onNext: { [unowned self] result in
                         PLoadingActivity.shared.hide()
                         switch result {
                         case .success(let done):
                            AppMessagesManager.shared.showMessage(messageType: .success, message: "UPDATE_PROFILE_SUCCESS".localized())
                            self.isUpdate = false
                         case .failure(let error):
                             AppMessagesManager.shared.showMessage(messageType: .error, message: error.message.localized())
                         }
                     }).disposed(by: self.myBag)
            }
        }
    }
    
    @IBAction func on_pay(_ sender: Any) {
        AppMessagesManager.shared.showMessage(messageType: .info, message: "PAY_IN_DEVELOPMENT".localized())
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
