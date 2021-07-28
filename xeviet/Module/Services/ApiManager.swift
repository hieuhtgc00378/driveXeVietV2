////
////  ApiManager.swift
////  bosty-ios
////
////  Created by eagle on 1/2/20.
////  Copyright © 2020 Tran Thanh Nhien. All rights reserved.
////
//
//import UIKit
//import RxAlamofire
//import RxCocoa
//import RxSwift
//import ObjectMapper
//
//class ApiManager: NSObject {
//    static let shared = ApiManager()
//    let client = RxAlamofireClient.shared
//
//    fileprivate var myBag = DisposeBag()
//
//    //MARK: PARAMS
//    func configParams(old: [String:Any?]) -> [String:Any]{
//        var params = [String:Any]()
//        var count = 0
//        while count < old.keys.count{
//            let key:String = Array(old.keys)[count]
//            if let value = old[key]{
//                params.updateValue(value!, forKey: key)
//            }
//            count += 1
//        }
//
//        //add auth_token to params
//
//
//        return params
//    }
//
//
//    //MARK: USER ---------------------------
//    func login(username:String, password:String) -> Observable<BTResponseObject<UserInfo>>{
//        let userInfo:Observable<BTResponseObject<UserInfo>> = RxAlamofireClient.shared.requestT(method: .post, endpoint: APIPath.user_login.url, parameters: ["username":username, "password":password], encoding: nil, mappable: UserInfo())
//        return userInfo
//    }
//
//    func getUserInfo(auth_token:String) -> Observable<BTResponseObject<UserInfo>>{
//        let userInfo:Observable<BTResponseObject<UserInfo>> = RxAlamofireClient.shared.requestT(method: .get, endpoint: APIPath.user_info.url, parameters: ["auth_token":auth_token], encoding: nil, mappable: UserInfo())
//               return userInfo
//    }
//
//    func updateUserInfo(auth_token:String, firstname_kanji:String, lastname_kanji:String, lastname_kana:String, firstname_kana:String, sex:Int, birthday:String, email:String, phone_number:String, postcode:String, province:String, district:String, street:String, apartment_number:String) -> Observable<BTResponseObject<UserInfo>>{
//        let userInfo:Observable<BTResponseObject<UserInfo>> = RxAlamofireClient.shared.requestT(method: .post, endpoint: APIPath.user_update.url, parameters: ["auth_token":auth_token, "firstname_kanji":firstname_kanji, "lastname_kanji":lastname_kanji, "lastname_kana":lastname_kana, "firstname_kana":firstname_kana, "sex":sex, "birthday":birthday, "email":email, "phone_number":phone_number, "postcode":postcode, "province":province, "district":district, "street":street, "apartment_number":apartment_number], encoding: nil, mappable: UserInfo())
//        return userInfo
//    }
//
//    func changePassword(old_password:String, new_password:String, password_confirm:String) -> Observable<BTResponseObject<UserInfo>>{
//        let result:Observable<BTResponseObject<UserInfo>> = RxAlamofireClient.shared.requestT(method: .post, endpoint: APIPath.user_change_password.url, parameters: ["old_password":old_password, "new_password":new_password, "password_confirm":password_confirm], encoding: nil, mappable: UserInfo())
//        return result
//    }
//
//    //MARK: MEAL --------------------------
//    func mealList(day:String, start_time:String, end_time:String) -> Observable<BTResponseList<Meal>>{
//          let listMeal:Observable<BTResponseList<Meal>> = RxAlamofireClient.shared.requestTList(method: .get, endpoint: APIPath.meal_list.url, parameters: ["day":day, "start_time":start_time, "end_time":end_time], encoding: nil, mappable: Meal())
//          return listMeal
//      }
//
//    func mealDetail(meal_id:Int, per:Int, page:Int) -> Observable<BTResponseObject<Meal>>{
//           let meal:Observable<BTResponseObject<Meal>> = RxAlamofireClient.shared.requestT(method: .get, endpoint: APIPath.meal_detail.url, parameters: ["meal_id":meal_id, "per":per, "page":page], encoding: nil, mappable: Meal())
//                  return meal
//       }
//
//    func mealCreate(thumb:String, time_eat:String, content:String, type:Int) -> Observable<BTResponseObject<Meal>>{
//           let meal:Observable<BTResponseObject<Meal>> = RxAlamofireClient.shared.requestT(method: .post, endpoint: APIPath.meal_create.url, parameters: ["thumb":thumb, "time_eat":time_eat, "content":content, "type":type], encoding: nil, mappable: Meal())
//                  return meal
//       }
//
//    func mealUpdate(id:Int, thumb:String?, time_eat:String?, content:String?, type:Int?) -> Observable<BTResponseObject<Meal>>{
//           let params = configParams(old: ["thumb":thumb, "time_eat":time_eat, "content":content, "type":type])
//           let meal:Observable<BTResponseObject<Meal>> = RxAlamofireClient.shared.requestT(method: .post, endpoint: APIPath.meal_create.url, parameters: params, encoding: nil, mappable: Meal())
//                  return meal
//       }
//
//    func mealComment(id:Int, content:String?, media:String?, type:Int) -> Observable<BTResponseObject<Comment>>{
//            let params = configParams(old: ["id":id, "content":content, "media":media, "type":type])
//            let meal:Observable<BTResponseObject<Comment>> = RxAlamofireClient.shared.requestT(method: .post, endpoint: APIPath.meal_comment.url, parameters: params, encoding: nil, mappable: Comment())
//                    return meal
//    }
//
//
//
//}
