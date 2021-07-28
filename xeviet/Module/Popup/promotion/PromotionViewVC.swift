//
//  PromotionViewVC.swift
//  xeviet
//
//  Created by Tran Thanh Nhien on 6/10/20.
//  Copyright © 2020 eagle. All rights reserved.
//


import UIKit
import SwiftMessages
import RxSwift
import RxCocoa

class PromotionViewVC: UIView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var promotionLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    private let myBag: DisposeBag = DisposeBag()
    var callBack: ((PromotionModel) -> Void)?
    var viewModel: PromotionViewVM? {
        didSet {
            setupRx()
        }
    }

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
        self.promotionLabel.text = "PROMOTION_LIST".localized()
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .clear
        self.tableView.estimatedRowHeight = 70
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 0))
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 0))
        
        self.tableView.register(UINib(nibName: PromotionCellVC.nameOfClass, bundle: nil), forCellReuseIdentifier: PromotionCellVC.nameOfClass)
        
    }
    
    
    
    class func showView(completeBlock: ((PromotionModel) -> Void)?) {
        var config = AppMessagesManager.shared.sharedConfig
        config.presentationStyle = .center
        
        let myView = PromotionViewVC()
        myView.viewModel = PromotionViewVM()
        myView.callBack = completeBlock
        SwiftMessages.sharedInstance.show(config: config, view: myView)
    }
    
    private func setupRx() {
        
        // Setup refresh/loadmore for tableView
        //viewModel?.pagingManager?.commonSetupFor(tableView, disposeBag: viewModel?.myBag ?? DisposeBag())
        
        viewModel?.dataSource.asDriver()
            .drive(self.tableView.rx.items(cellIdentifier: PromotionCellVC.nameOfClass, cellType: PromotionCellVC.self)) { index, viewModel, cell in
                cell.viewModel = viewModel
            }
            .disposed(by: myBag)
        
        // Action
        tableView.rx.modelSelected(PromotionCellVM.self).asObservable()
            .subscribe(onNext: { viewModel in
                self.callBack?(viewModel.model)
                SwiftMessages.sharedInstance.hideAll()
            })
        .disposed(by: myBag)
        
        closeButton.rx.tap.asDriver().throttle(.seconds(1))
            .drive(onNext: { [weak self] _ in
                SwiftMessages.hideAll()
            })
        .disposed(by: myBag)
        
        
    }
    
    
}
