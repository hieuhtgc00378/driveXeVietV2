//
//  FastBookingServices.swift
//  xeviet
//
//  Created by Tran Thanh Nhien on 6/7/20.
//  Copyright © 2020 eagle. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxCocoa
import RxSwift
import Alamofire

class FastBookingServices {

    static let myBag = DisposeBag()
    typealias bookingDetailResult = (booking: Booking, driver: DriverModel)

    /// get  vehicle list
    class func getVehicleList(_ params: PARAM) -> Observable<Result<[VehicleTypeModel], APIError>> {

        return Networking.shared.request(method: .post,
                                         endpoint: APIPath.vehicle_type.url,
                                         parameters: params)
            .map { result -> Result<[VehicleTypeModel], APIError> in
                return result.map { $0.arrayValue.map { VehicleTypeModel(fromJson: $0)}}
        }
    }
    
    /// get promotion list
    
    class func getPromotionList() -> Observable<Result<[PromotionModel], APIError>> {

        return Networking.shared.request(method: .get,
                                         endpoint: APIPath.list_coupon.url)
            .map { result -> Result<[PromotionModel], APIError> in
                return result.map { $0.arrayValue.map { PromotionModel(fromJson: $0)}}
        }
    }
    
    /// booking fast
    class func bookingFast(_ params: PARAM) -> Observable<Result<Booking, APIError>> {

        return Networking.shared.request(method: .post,
                                         endpoint: APIPath.booking_fast.url,
                                         parameters: params,
                                         encoding: JSONEncoding.default)
            .map { result -> Result<Booking, APIError> in
                return result.map { Booking(fromJson: $0["booking"]) }
        }
    }
    
    /// get booking detail
    class func bookingDetail(_ bookingID: Int) -> Observable<Result<bookingDetailResult, APIError>> {

        return Networking.shared.request(method: .get,
                                         endpoint: APIPath.booking_detail.url + "/\(bookingID)")
            .map { result -> Result<bookingDetailResult, APIError> in
                return result.map {(Booking(fromJson: $0["booking"]), DriverModel(fromJson: $0["driver"]))}
        }
    }
    
    /// cancel booking
    class func cancelBooking(_ bookingID: Int, reson: String) -> Observable<Result<Bool, APIError>> {
        
        let param: PARAM = [
        "reason_cancel": reson
        ]
        
        return Networking.shared.request(method: .post,
                                         endpoint: APIPath.cancel_booking.url + "/\(bookingID)",
                                        parameters: param)
            .map { result -> Result<Bool, APIError> in
                return result.map { $0["success"].intValue == 1 }
        }
    }
    
    //MARK: - Province
    /// get route list
    class func getRouteList(routeID: String) -> Observable<Result<[RouteModel], APIError>> {
        
        return Networking.shared.request(method: .get,
                                         endpoint: APIPath.routeList.url + "/\(routeID)")
            .map { result -> Result<[RouteModel], APIError> in
                return result.map { $0.arrayValue.map { RouteModel(fromJson: $0)} }
        }
    }
    
    /// get route list
    class func getRideList(_ param: PARAM) -> Observable<Result<[CountriesRoute], APIError>> {
        
        return Networking.shared.request(method: .get,
                                         endpoint: APIPath.rideList.url,
                                         parameters: param,
                                         encoding: URLEncoding.queryString)
            .map { result -> Result<[CountriesRoute], APIError> in
                return result.map { $0.arrayValue.map { CountriesRoute(fromJson: $0)} }
        }
    }
    
    /// calculate price the ride with promotion
    class func getRidePrice(_ param: PARAM) -> Observable<Result<Booking, APIError>> {
        
        return Networking.shared.request(method: .post,
                                         endpoint: APIPath.caculate_ride.url,
                                         parameters: param)
            .map { result -> Result<Booking, APIError> in
                return result.map { Booking(fromJson: $0) }
        }
    }
    
    /// booking province
    class func bookingProvince(_ param: PARAM) -> Observable<Result<Bool, APIError>> {
        
        return Networking.shared.request(method: .post,
                                         endpoint: APIPath.booking_ride.url,
                                         parameters: param)
            .map { result -> Result<Bool, APIError> in
                return result.map { $0["success"].intValue == 1 }
        }
    }

    /// booking province
    class func checkBooking() -> Observable<Result<Int, APIError>> {
        
        return Networking.shared.request(method: .get,
                                         endpoint: APIPath.checkBooking.url)
            .map { result -> Result<Int, APIError> in
                return result.map { $0["id"].intValue}
        }
    }
}
