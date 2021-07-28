////
////  UserServices.swift
////  ConnectEvent
////
////  Created by Tran Thanh Nhien on 10/31/19.
////  Copyright © 2019 Tran Thanh Nhien. All rights reserved.
////

import Alamofire
import Foundation
import RxCocoa
import RxSwift
import SwiftyJSON

class UserServices {
    // Get user info
//    class func userInfo() -> Observable<Result<UserModel, APIError>> {
//        return Networking.shared.request(method: .get,
//                                         endpoint: APIPath.user_info.url)
//            .map { result -> Result<UserModel, APIError> in
//                result.map { UserModel(json: $0["data"]) }
//            }
//    }
//
//    class func registerTemporary() -> Observable<Result<String, APIError>> {
//        return Networking.shared.request(method: .post,
//                                         endpoint: APIPath.user_register_temporary.url,
//                                         parameters: ["device_id": AppManager.shared.deviceID],
//                                         withToken: false)
//            .map { result -> Result<String, APIError> in
//                result.map { $0["data"]["auth_token"].stringValue }
//            }
//    }
//
//    // MARK: - Home screen
//
//    /// Get slider images at home screen
//    ///
//    /// - Parameter : dictionary object
//    /// - Returns: observable object
//    class func getSliderInfo() -> Observable<Result<[SliderModel], APIError>> {
//        return Networking.shared.request(method: .get,
//                                         endpoint: APIPath.homeSlider.url)
//            .map { result -> Result<[SliderModel], APIError> in
//                result.map { $0["data"].arrayValue.map { SliderModel(json: $0) } }
//            }
//    }
//
//    /// Get notifications at home screen
//    ///
//    /// - Parameter : dictionary object
//    /// - Returns: observable object
//    class func getUserNotifications(page: Int) -> Observable<Result<JSON, APIError>> {
//        let param: [String: Any] = ["page": page]
//        return Networking.shared.request(method: .get,
//                                         endpoint: APIPath.homeNotifications.url,
//                                         parameters: param)
//            .map { result -> Result<JSON, APIError> in
//                result.map { $0["data"] }
//            }
//    }
//
//    // MARK: - Meal screen
//
//    /// Get meal list
//    ///
//    /// - Parameter : dictionary object
//    /// - Returns: observable object
//    class func getMealList(date: Date) -> Observable<Result<[FoodModel], APIError>> {
//        let param: [String: Any] = ["date": date.toApiDateFormatString]
//        return Networking.shared.request(method: .get,
//                                         endpoint: APIPath.meal_list.url,
//                                         parameters: param)
//            .map { result -> Result<[FoodModel], APIError> in
//                result.map { $0["data"].arrayValue.map { FoodModel(fromJson: $0) } }
//            }
//    }
//
//    /// Get unread meal comment list
//    ///
//    /// - Parameter : dictionary object
//    /// - Returns: observable object
//    class func getUnreadCommentList(date: Date) -> Observable<Result<[UnreadCommentModel], APIError>> {
//        let param: [String: Any] = ["month": date.toApiYearMonthFormat]
//        return Networking.shared.request(method: .get,
//                                         endpoint: APIPath.meal_unread_comment.url,
//                                         parameters: param)
//            .map { result -> Result<[UnreadCommentModel], APIError> in
//                result.map { $0["data"].arrayValue.map { UnreadCommentModel(json: $0) } }
//            }
//    }
//
//    /// Get meal comment list
//    ///
//    /// - Parameter : dictionary object
//    /// - Returns: observable object
//    class func getMealCommentList(mealId: Int, page: Int) -> Observable<Result<JSON, APIError>> {
//        let param: [String: Any] = ["meal_id": mealId, "page": page]
//        return Networking.shared.request(method: .get,
//                                         endpoint: APIPath.meal_get_comment.url,
//                                         parameters: param)
//            .map { result -> Result<JSON, APIError> in
//                result.map { $0["data"] }
//            }
//    }
//
//    /// Get meal detail
//    ///
//    /// - Parameter :
//    /// - Returns: observable object
//    class func GetMealDetail(id: Int) -> Observable<Result<FoodModel, APIError>> {
//        let param: [String: Any] = [
//            "id": id
//        ]
//        return Networking.shared.request(method: .get,
//                                         endpoint: APIPath.meal_detail.url,
//                                         parameters: param)
//            .map { result -> Result<FoodModel, APIError> in
//                result.map { FoodModel(fromJson: $0["data"]) }
//            }
//    }
//
//    /// Get meal detail
//    ///
//    /// - Parameter :
//    /// - Returns: observable object
//    class func GetMealDetail(type: MealType, date: String) -> Observable<Result<FoodModel, APIError>> {
//        let param: [String: Any] = [
//            "type": type.description,
//            "date": date
//        ]
//        return Networking.shared.request(method: .get,
//                                         endpoint: APIPath.meal_detail.url,
//                                         parameters: param)
//            .map { result -> Result<FoodModel, APIError> in
//                result.map { FoodModel(fromJson: $0["data"]) }
//            }
//    }
//
//    /// Create meal
//    ///
//    /// - Parameter : dictionary object
//    /// - Returns: observable object
//    class func CreateMeal(type: MealType, eatTime: String, content: String, imageData: Data?) -> Observable<Result<FoodModel, APIError>> {
//        let param: [String: Any] = [
//            "time_eat": eatTime,
//            "type": type.rawValue,
//            "content": content
//        ]
//        print("Create meal \(param)")
//        return Networking.shared.upload("", "jpg",
//                                        api: APIPath.meal_create,
//                                        parameters: param,
//                                        mediaParam: "thumb",
//                                        imageData: imageData)
//            .map { result -> Result<FoodModel, APIError> in
//                result.map { FoodModel(fromJson: $0["data"]) }
//            }
//    }
//
//    /// Create meal comment
//    ///
//    /// - Parameter : dictionary object
//    /// - Returns: observable object
//    class func CreateMealComment(mealId: Int, content: String, type: Int, imageData: Data?) -> Observable<Result<CommendModel, APIError>> {
//        let param: [String: Any] = [
//            "meal_id": mealId,
//            "type": type,
//            "content": content
//        ]
//
//        if type == 1 {
//            return Networking.shared.request(method: .post,
//                                             endpoint: APIPath.meal_send_comment.url,
//                                             parameters: param)
//                .map { result -> Result<CommendModel, APIError> in
//                    result.map { CommendModel(json: $0["data"]) }
//                }
//        } else if type == 2 {
//            return Networking.shared.upload("", "jpg",
//                                            api: APIPath.meal_send_comment,
//                                            parameters: param,
//                                            mediaParam: "media",
//                                            imageData: imageData)
//                .map { result -> Result<CommendModel, APIError> in
//                    result.map { CommendModel(json: $0["data"]) }
//                }
//        } else {
//            return Networking.shared.request(method: .post,
//                                             endpoint: APIPath.meal_send_comment.url,
//                                             parameters: param)
//                .map { result -> Result<CommendModel, APIError> in
//                    result.map { CommendModel(json: $0["data"]) }
//                }
//        }
//    }
//
//    // MARK: - Booking screen
//
//    /// Get course list
//    ///
//    /// - Parameter : dictionary object
//    /// - Returns: observable object
//    class func getCourseList(page: Int) -> Observable<Result<[CourseModel], APIError>> {
//        var param: [String: Any] = [:]
//        if page > 0 {
//            param["page"] = page
//        }
//        return Networking.shared.request(method: .get,
//                                         endpoint: APIPath.courseList.url,
//                                         parameters: param)
//            .map { result -> Result<[CourseModel], APIError> in
//                result.map { $0["data"]["list_course"].arrayValue.map { CourseModel(json: $0) } }
//            }
//    }
//
//    /// Get course detail
//    ///
//    /// - Parameter : dictionary object
//    /// - Returns: observable object
//    class func getCourseDetail(id: Int) -> Observable<Result<CourseModel, APIError>> {
//        let param: [String: Any] = ["id": id]
//        return Networking.shared.request(method: .get,
//                                         endpoint: APIPath.courseDetail.url,
//                                         parameters: param)
//            .map { result -> Result<CourseModel, APIError> in
//                result.map { CourseModel(json: $0["data"]) }
//            }
//    }
//
//    /// Confirm booking course
//    ///
//    /// - Parameter : dictionary object
//    /// - Returns: observable object
//    class func confirmBookingCourse(param: [String: Any]) -> Observable<Result<String, APIError>> {
//        return Networking.shared.request(method: .post,
//                                         endpoint: APIPath.confirm_booking.url,
//                                         parameters: param)
//            .map { result -> Result<String, APIError> in
//                result.map { $0["data"]["message"].stringValue }
//            }
//    }
//
//    /// Get course list
//    ///
//    /// - Parameter : dictionary object
//    /// - Returns: observable object
//    class func getVendorList(type: Int, keyword: String, page: Int) -> Observable<Result<JSON, APIError>> {
//        var param: [String: Any] = ["keyword": keyword]
//        if page > 0 {
//            param["page"] = page
//        }
//        return Networking.shared.request(method: .get,
//                                         endpoint: APIPath.vendorList.url,
//                                         parameters: param)
//            .map { result -> Result<JSON, APIError> in
//                result.map { $0["data"] }
//            }
//    }
//
//    /// Get shop list
//    ///
//    /// - Parameter : dictionary object
//    /// - Returns: observable object
//    class func getShopList(isConnectedshop: Bool, keyword: String, page: Int) -> Observable<Result<JSON, APIError>> {
//        var param: [String: Any] = [
//            "search": keyword,
//            "type": isConnectedshop ? 1 : 2
//        ]
//
//        if page > 0 {
//            param["page"] = page
//        }
//
//        return Networking.shared.request(method: .get,
//                                         endpoint: APIPath.shopList.url,
//                                         parameters: param)
//            .map { result -> Result<JSON, APIError> in
//                result.map { $0["data"] }
//            }
//    }
//
//    /// Get shop detail
//    ///
//    /// - Parameter : dictionary object
//    /// - Returns: observable object
//    class func getShopDetail(id: Int) -> Observable<Result<ShopModel, APIError>> {
//        let param: [String: Any] = ["id": id]
//        return Networking.shared.request(method: .get,
//                                         endpoint: APIPath.shopDetail.url,
//                                         parameters: param)
//            .map { result -> Result<ShopModel, APIError> in
//                result.map { ShopModel(json: $0["data"]) }
//            }
//    }
//
//    /// Register shop
//    ///
//    /// - Parameter : dictionary object
//    /// - Returns: observable object
//    class func RegisterShopFirstTime(param: [String: Any]) -> Observable<Result<JSON, APIError>> {
//        print("RegisterShopFirstTime param: \(param)")
//        return Networking.shared.request(method: .post,
//                                         endpoint: APIPath.register_shop_firsttime.url,
//                                         parameters: param)
//            .map { result -> Result<JSON, APIError> in
//                result.map { $0["data"] }
//            }
//    }
//
//    /// connect shop
//    ///
//    /// - Parameter : dictionary object
//    /// - Returns: observable object
//    class func ConnectShop(shopId: Int) -> Observable<Result<JSON, APIError>> {
//        print("ConnectShop shop ID: \(shopId)")
//        return Networking.shared.request(method: .post,
//                                         endpoint: APIPath.connectShop.url,
//                                         parameters: ["shop_id": shopId])
//            .map { result -> Result<JSON, APIError> in
//                result.map { $0["data"] }
//            }
//    }
//
//    /// disconnect shop
//    ///
//    /// - Parameter : dictionary object
//    /// - Returns: observable object
//    class func DisconnectShop(shopId: Int) -> Observable<Result<JSON, APIError>> {
//        print("ConnectShop shop ID: \(shopId)")
//        return Networking.shared.request(method: .post,
//                                         endpoint: APIPath.disconnectShop.url,
//                                         parameters: ["shop_id": shopId])
//            .map { result -> Result<JSON, APIError> in
//                result.map { $0["data"] }
//            }
//    }
}
