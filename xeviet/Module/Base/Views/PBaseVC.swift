//
//  PBaseVC.swift
//  Supership
//
//  Created by Mac on 8/15/18.
//  Copyright © 2018 Padi. All rights reserved.
//

import RxSwift
import UIKit

class PBaseVC: UIViewController {

    var isEnableSwipeBack: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set delegate swipe back
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Helper

extension PBaseVC {
    
    func tapEndEditing() {
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: DisposeBag())
        view.addGestureRecognizer(tapBackground)
    }
}

// MARK: - Swipe back

extension PBaseVC: UIGestureRecognizerDelegate {
    
    func isBackButtonVisible() -> Bool {
        return self.navigationItem.leftBarButtonItem != nil
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isEqual(self.navigationController?.interactivePopGestureRecognizer) {
            return isEnableSwipeBack && isBackButtonVisible()
        }
        
        return true
    }
}













