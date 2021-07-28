//
//  ReasonDeclineView.swift
//  Happ
//
//  Created by Tran Thanh Nhien on 7/7/20.
//  Copyright © 2020 Tran Thanh Nhien. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SwiftMessages

class ReasonDeclineView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var reasonTextView: UITextView!
    @IBOutlet weak var declineButton: PButton!
    
    private let myBag: DisposeBag = DisposeBag()
    var callBack: ((String, Bool) -> Void)?
    var image: UIImage?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
       
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        Bundle.main.loadNibNamed(self.className, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        self.reasonTextView.backgroundColor = .white
        self.reasonTextView.layer.masksToBounds = true
        self.reasonTextView.layer.cornerRadius = 10
        self.reasonTextView.text = "REASON_FOR_CANCEL".localized()
        self.reasonTextView.textColor = UIColor.lightGray
        self.reasonTextView.delegate = self
        setupRx()
    }
    
    class func showView(completeBlock: ((String, Bool) -> Void)?) {
        var config = AppMessagesManager.shared.sharedConfig
        config.presentationStyle = .center
        config.presentationContext = .window(windowLevel: .normal)
        
        let myView = ReasonDeclineView()
        myView.callBack = completeBlock
        SwiftMessages.sharedInstance.show(config: config, view: myView)
    }
    
    private func setupRx() {
        
        // Close view
        closeButton.rx.tap.asDriver()
            .throttle(.seconds(1))
            .drive(onNext: { _ in
                SwiftMessages.sharedInstance.hide()
            })
            .disposed(by: myBag)
        
        // decline
        declineButton.rx.tap.asDriver()
            .throttle(.seconds(1))
            .drive(onNext: { _ in
                if let reason = self.reasonTextView.text, !reason.isEmpty, reason != "REASON_FOR_CANCEL".localized() {
                    self.callBack?(reason, true)
                    SwiftMessages.sharedInstance.hide()
                    
                } else {
                    return
                }
            })
            .disposed(by: myBag)
    }
}


extension ReasonDeclineView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "REASON_FOR_CANCEL".localized()
            textView.textColor = UIColor.lightGray
        }
    }
}
