//
//  PagingProtocol.swift
//  av41group
//
//  Created by nhatquangz on 11/26/18.
//  Copyright © 2018 paditech. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import KafkaRefresh

protocol PagingCompatible: class {
	associatedtype PagingData
	var dataSource: BehaviorRelay<[PagingData]> { get }
	var currentPage: BehaviorRelay<Int> { get }
	var finishLoad: PublishSubject<Void> { get }
	var targetPage: Int { get set }
	var initialPage: Int { get }
}

extension PagingCompatible {
	func add(newData: [PagingData]) {
		print("Add \(newData.count) new data")
		if currentPage.value == initialPage {
			self.targetPage = initialPage
			self.dataSource.accept(newData)
		} else {
            // Append data
            self.dataSource.acceptAppending(newData)
		}
		self.targetPage = self.currentPage.value + (newData.count > 0 ? 1 : 0)
		finishLoad.onNext(())
	}
	
	func loadMore() {
        self.currentPage.accept(targetPage)
	}
	
	func refresh() {
		self.currentPage.accept(initialPage)
	}
}

/**
Manage paging feature
**/
class PagingManager<PagingData>: PagingCompatible {
    
    var dataSource: BehaviorRelay<[PagingData]>
    var currentPage: BehaviorRelay<Int>
	var targetPage: Int
	var initialPage: Int = 1
	let finishLoad = PublishSubject<Void>()
    
    init() {
        dataSource = BehaviorRelay<[PagingData]>(value: [])
        currentPage = BehaviorRelay<Int>(value: initialPage)
		targetPage = initialPage
    }
    
    init(dataSource: BehaviorRelay<[PagingData]>) {
        self.dataSource = dataSource
        currentPage = BehaviorRelay<Int>(value: initialPage)
        targetPage = initialPage
    }
}


// MARK: - Helper
extension PagingManager {
	func commonSetupFor(_ view: UIScrollView, disposeBag: DisposeBag) {
        view.bindHeadRefreshHandler({ [weak self] in
            self?.refresh()
            }, themeColor: .white, refreshStyle: .native)
        
        view.bindFootRefreshHandler({ [weak self] in
            self?.loadMore()
            }, themeColor: .white, refreshStyle: .native)
        
        finishLoad.asObserver()
            .subscribe(onNext: {
                view.headRefreshControl.endRefreshing()
                view.footRefreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
    }
}

