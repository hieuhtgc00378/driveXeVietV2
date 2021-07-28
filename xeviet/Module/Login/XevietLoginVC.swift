//
//  XevietLoginVC.swift
//  xeviet
//
//  Created by Admin on 6/1/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import UIKit
import Firebase
import RxCocoa
import RxSwift
import CountryPickerView


class XevietLoginVC: UIViewController {
    
    @IBOutlet weak var enterPhoneNumberLabel: UILabel!
    weak var cpvTextField: CountryPickerView!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var phoneNumberView: PView!
    
    @IBOutlet weak var otpLabel: UILabel!
    @IBOutlet weak var otpTextField: PTextField!
    @IBOutlet weak var ruleButton: UIButton!
    @IBOutlet weak var loginButton: PButton!
    
    fileprivate var myBag = DisposeBag()
    var verificationID: String?
    
    init() {
        super.init(nibName: "XevietLoginVC", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cp = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        phoneNumberTextField.leftView = cp
        phoneNumberTextField.leftViewMode = .always
        self.cpvTextField = cp
        cpvTextField.tag = 2
        cpvTextField.dataSource = self
        self.phoneNumberTextField.delegate = self
        setupRxAction()
        // Do any additional setup after loading the view.
    }
    
    func login(verifiCode: String) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.verificationID ?? "", verificationCode: verifiCode)
        Auth.auth().signIn(with: credential) { authData, error in
            if ((error) != nil) {
                // Handles error
                //                self.handleError(error)
                PLoadingActivity.shared.hide()
                return
            }
            
            //login success
            let user = authData!.user
            user.getIDToken(completion: { (token, error) in
                if error != nil{
                    PLoadingActivity.shared.hide()
                    return
                }
                
                if let token = token {
                    let params: [String: Any] = [
                        "firebase_token": token
                    ]
                    
                    MainServices.userLogin(params).asObservable().asObservable().subscribe(onNext: { [unowned self] result in
                        switch result {
                        case .success(let userInfo):
                            PLoadingActivity.shared.hide()
                            AppManager.shared.user = userInfo
                            AppDelegate.shared().appCoordinator.showMainScreen()
                        case .failure(let error):
                            PLoadingActivity.shared.hide()
                            AppMessagesManager.shared.showMessage(messageType: .error, message: error.message)
                        }
                    }).disposed(by: self.myBag)
                }
            })
            
            
        }
    }
    
    
    
    func getVerifiCode(phoneNumber: String){
        let phoneNumber = "+84\(phoneNumber)"
        
        PLoadingActivity.shared.show(type: .ballScaleMultiple, message: "LOGIN_LOADING".localized(), thresholdTime: 0)
        
        Auth.auth().settings!.isAppVerificationDisabledForTesting = false
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate:nil) {
            verificationID, error in
            if ((error) != nil) {
                // Handles error
                //              self.handleError(error)
                PLoadingActivity.shared.hide()
                AppMessagesManager.shared.showMessage(messageType: .warning, message: error?.localizedDescription ?? "PHONE_NUMBER_INVAILD".localized())
                return
            }
            self.verificationID = verificationID
            PLoadingActivity.shared.hide()
        }
    }
    
    func setupRxAction() {
        
        self.phoneNumberTextField.rx.text.orEmpty.distinctUntilChanged()
        .asObservable()
            .subscribe(onNext: { [weak self] number in
                if number.count == 10 {
                    let numberStrimed = number.substring(from: 1)
                    self?.getVerifiCode(phoneNumber: numberStrimed)
                    self?.otpLabel.isHidden = false
                    self?.otpTextField.isHidden = false
                }
            })
            .disposed(by: myBag)
        
//        self.otpTextField.rx.text.orEmpty
//        .asDriver()
//        .drive(onNext: { [weak self] otp in
//            self?.loginButton.isHidden = otp.isEmpty
//        })
//        .disposed(by: myBag)
        
//        loginButton.rx.tap.asDriver().throttle(.seconds(1))
//            .drive(onNext: { [weak self] _ in
//                self?.login(verifiCode: self?.otpTextField.text ?? "")
//
//            })
//        .disposed(by: myBag)
    }
    
}

extension XevietLoginVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 10
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}

extension XevietLoginVC: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Only countryPickerInternal has it's delegate set
        let title = "Selected Country"
        let message = "Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)"
    }
}

extension XevietLoginVC: CountryPickerViewDataSource {
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country] {
//        if countryPickerView.tag == cpvMain.tag && showPreferredCountries.isOn {
//            return ["NG", "US", "GB"].compactMap { countryPickerView.getCountryByCode($0) }
//        }
        return []
    }
    
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String? {
//        if countryPickerView.tag == cpvMain.tag && showPreferredCountries.isOn {
//            return "Preferred title"
//        }
        return nil
    }
    
    func showOnlyPreferredSection(in countryPickerView: CountryPickerView) -> Bool {
//        return countryPickerView.tag == cpvMain.tag && showOnlyPreferredCountries.isOn
        return false
    }
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select a Country"
    }
        
    func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition {
//        if countryPickerView.tag == cpvMain.tag {
//            switch searchBarPosition.selectedSegmentIndex {
//            case 0: return .tableViewHeader
//            case 1: return .navigationBar
//            default: return .hidden
//            }
//        }
        return .tableViewHeader
    }
    
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool {
//        return countryPickerView.tag == cpvMain.tag && showPhoneCodeInList.isOn
        return true
    }
    
    func showCountryCodeInList(in countryPickerView: CountryPickerView) -> Bool {
//       return countryPickerView.tag == cpvMain.tag && showCountryCodeInList.isOn
        return true
    }
}

