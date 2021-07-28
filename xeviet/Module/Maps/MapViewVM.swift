//
//  MapViewVM.swift
//  xeviet
//
//  Created by Tran Thanh Nhien on 6/7/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import GooglePlaces
import SwiftDate

class MapViewVM: BaseViewModel {
    
    let startPoint = BehaviorRelay<CLLocationCoordinate2D?>(value: nil)
    let endPoint = BehaviorRelay<CLLocationCoordinate2D?>(value: nil)
    
    let listVehicle = BehaviorRelay<[VehicleTypeModel]>(value: [])
    let selectedCar = BehaviorRelay<VehicleTypeModel?>(value: nil)
    let promotionSelected = BehaviorRelay<PromotionModel?>(value: nil)
    let booking = BehaviorRelay<Booking?>(value: nil)
    let driverModel = BehaviorRelay<DriverModel?>(value: nil)
    let provinceName = BehaviorRelay<String>(value: "")
    let placeBegin = BehaviorRelay<String>(value: "")
    let placeEnd = BehaviorRelay<String>(value: "")
    let bookingID = BehaviorRelay<Int?>(value: nil)
    let popViewController = BehaviorRelay<Bool?>(value: nil)
    // Flag
    let isHiddenDriverView = BehaviorRelay<Bool>(value: true)
    let isHiddenStatusViewView = BehaviorRelay<Bool>(value: true)
//    let isWaitingDriver = BehaviorRelay<Bool>(value: false)
    let isLookingDriver = BehaviorRelay<Bool>(value: false)
    
    // Action
    let getVehicleAction = PublishSubject<Int?>()
    let bookingFastAction = PublishSubject<Void>()
    let getBookingDetail = PublishSubject<Int>()
    let cancelBookingAction = PublishSubject<(Int, String)>()
    
    var refused_drivers: [Int] = []
    var booking_id: Int? = nil
    
    let currentAction = BehaviorRelay<Bool>(value: false)
    
    init(bookingID: Int, isLookingDriver: Bool) {
        super.init()
        
        self.isLookingDriver.accept(isLookingDriver)
        self.bookingID.accept(bookingID)
        
        
        
        //get vehicle list
        getVehicleAction.asObservable()
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMapLatest ({ [weak self] promotionID -> Observable<Result<[VehicleTypeModel], APIError>> in
            guard let self = self,
                let startPoint = self.startPoint.value,
                let endPoint = self.endPoint.value else { return Observable.empty() }
                var params: PARAM
                if let id = promotionID {
                    params = [
                        "lat_start" : startPoint.latitude,
                        "lng_start" : startPoint.longitude,
                        "lat_end" : endPoint.latitude,
                        "lng_end" : endPoint.longitude,
                        "promotion_id" : id,
                        "address" : self.provinceName.value
                    ]
                } else {
                    params = [
                        "lat_start" : startPoint.latitude,
                        "lng_start" : startPoint.longitude,
                        "lat_end" : endPoint.latitude,
                        "lng_end" : endPoint.longitude,
                        "address" : self.provinceName.value
                    ]
                }
                PLoadingActivity.shared.show()
                return FastBookingServices.getVehicleList(params)
        })
        .subscribe(onNext: { [weak self] result in
            
            switch result {
            case .success(let models):
                PLoadingActivity.shared.hide()
                self?.listVehicle.accept(models)
                
            case .failure(let error):
                PLoadingActivity.shared.hide()
                AppMessagesManager.shared.showMessage(messageType: .error, message: error.message)
            }
        })
        .disposed(by: myBag)
        
        //Booking fast
        bookingFastAction.asObservable()
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMapLatest ({ [weak self] _ -> Observable<Result<Booking, APIError>> in
            guard let self = self,
                let startPoint = self.startPoint.value,
                let endPoint = self.endPoint.value,
                let selectedCar = self.selectedCar.value else { return Observable.empty() }
                var params: PARAM
                params = [
                    "lat_start" : startPoint.latitude,
                    "lng_start" : startPoint.longitude,
                    "lat_end" : endPoint.latitude,
                    "lng_end" : endPoint.longitude,
                    "vehicle_type": selectedCar.verhicleType,
                    "pickup_time": Date().fullTimeString,
                    "passenger_phone": AppManager.shared.user?.phone_number ?? "",
                    "passenger_name": AppManager.shared.user?.user_name ?? "",
                    "address": self.provinceName.value,
                    "note": "Đặt xe nhanh",
                    "fee" : self.selectedCar.value?.data.fee ?? 0,
                    "original_fee" : self.selectedCar.value?.data.original_fee ?? 0,
                    "place_begin" : self.placeBegin.value,
                    "place_end" : self.placeEnd.value,
                    "refused_drivers": self.refused_drivers,
                    "booking_id": self.booking_id ?? -1,
                    "promotion_id": self.promotionSelected.value?.ID ?? -1
                ]
                
                
            return FastBookingServices.bookingFast(params)
        })
        .subscribe(onNext: { [weak self] result in
            switch result {
            case .success(let booking):
                self?.booking.accept(booking)
                if let bookingID = booking.id {
                    self?.booking_id = bookingID
                    self?.getBookingDetail.onNext(bookingID)
                    if let driverId = booking.driver_id {
                    self?.refused_drivers.append(driverId)
                    }
                    self?.currentAction.accept(true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + kTimeoutRequest) {
                        if let driver = self?.driverModel.value{
                            if (driver.phoneNumber == ""){
                                self?.bookingFastAction.onNext(())
                               }
                        }else{
                            self?.bookingFastAction.onNext(())
                        }
                        
                    }
                }else{
                    AppMessagesManager.shared.showMessage(messageType: .error, message: "Chưa tìm thấy tài xế nào gần bạn")
                    self?.currentAction.accept(false)
                    self?.refused_drivers.removeAll()
                }
               
            case .failure(let error):
                AppMessagesManager.shared.showMessage(messageType: .error, message: error.message)
                self?.currentAction.accept(false)
                self?.refused_drivers.removeAll()
            }
        })
        .disposed(by: myBag)
        
        AppCoordinator.shared.driverInfo.asDriver()
            .drive(onNext: {[weak self] driverModel in
                if let id = self?.booking.value?.id {
                    self?.getBookingDetail.onNext(id)
                }
            })
            .disposed(by: self.myBag)
        
        //get booking detail
        getBookingDetail.asObservable()
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMapLatest ({ [weak self] bookingID -> Observable<Result<FastBookingServices.bookingDetailResult, APIError>> in
            return FastBookingServices.bookingDetail(bookingID)
        })
        .subscribe(onNext: { [weak self] result in
            switch result {
            case .success(let bookingResult):
                if bookingResult.booking.status != 1{
                       if bookingResult.driver != nil {
                            self?.driverModel.accept(bookingResult.driver)
                            self?.booking.accept(bookingResult.booking)
                            self?.isHiddenDriverView.accept(false)
                            self?.isHiddenStatusViewView.accept(false)
                            PLoadingActivity.shared.hide()
                        }
                } else {
                    // retry
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        do{
                            var bookingId: Int = -1
                            if(isLookingDriver){
                                bookingId = bookingID
                            }else{
                                if let booking = self?.booking.value{
                                    bookingId = booking.id ?? -1
                                }
                            }
                            self?.getBookingDetail.onNext(bookingId)
                            
                        }catch{
                            
                        }
                    }
                }
            case .failure(let error):
                PLoadingActivity.shared.hide()
                AppMessagesManager.shared.showMessage(messageType: .error, message: error.message)
            }
        })
        .disposed(by: myBag)
        
        // cancel booking
        cancelBookingAction.asObservable()
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMapLatest ({ [weak self] (bookingID, reason) -> Observable<Result<Bool, APIError>> in
            return FastBookingServices.cancelBooking(bookingID, reson: reason)
        })
        .subscribe(onNext: { [weak self] result in
            switch result {
            case .success(let success):
                if success {
                    // pop view controller
                    self?.popViewController.accept(true)
                    self?.currentAction.accept(false)
                } else {
                    // handler err
                }
                
            case .failure(let error):
                AppMessagesManager.shared.showMessage(messageType: .error, message: error.message)
            }
        })
        .disposed(by: myBag)

        
        if isLookingDriver {
            self.getBookingDetail.onNext(bookingID)
        }
    }
}
