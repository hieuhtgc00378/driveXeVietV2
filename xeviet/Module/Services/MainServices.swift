//
//  MainServices.swift
//  htxviet
//
//  Created by NhatQuang on 8/20/18.
//  Copyright © 2018 nhatquang. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxCocoa
import RxSwift
import Alamofire

class MainServices {
	
    static let myBag = DisposeBag()
    // MARK: - User Action
    
//    // Register
//    static func userRegister(_ params: [String: Any]) -> Observable<Result<UserInfo, APIError>>{
//        return Networking.shared.request(method: .post, endpoint: APIPath.user_register.url, parameters: params)
//        .map { result -> Result<UserInfo, APIError> in
//            return result.map { UserInfo(fromJson: $0["data"]) }
//        }
//    }
//
    
    static func registerDevice(_ param: [String: Any]) -> Observable<Result<Void, APIError>> {
        return Networking.shared.request(method: .post,
                                         endpoint: APIPath.registerToken.url,
                                         parameters: param)
            .map { result -> Result<Void, APIError> in
                return result.map { _ in return }
        }
    }
    
    static func getPosition(type:Int) -> Observable<Result<[Position], APIError>>{
        //type 1 = city , type 2 = airport
        return Networking.shared.request(method: .get, endpoint: "\(APIPath.list_position.url)?type=\(type)", parameters: [String:Any]())
           .map { result -> Result<[Position], APIError> in
                return result.map {  $0.arrayValue.map { Position(fromJson: $0) } }
           }
       }
//
    static func userLogin(_ params: [String: Any]) -> Observable<Result<UserInfo, APIError>>{
           return Networking.shared.request(method: .post, endpoint: APIPath.user_register.url, parameters: params)
           .map { result -> Result<UserInfo, APIError> in
               return result.map { UserInfo(fromJson: $0["user"]) }
           }
       }
    
    static func userUpdateProfile(_ params: [String: Any]) -> Observable<Result<Bool, APIError>>{
              return Networking.shared.request(method: .put, endpoint: APIPath.user_update_info.url, parameters: params)
              .map { result -> Result<Bool, APIError> in
                return result.map { $0["success"] == 1 ? true : false }
              }
          }
    
    /// get user info
    class func getUserInfo() -> Observable<Result<UserInfo, APIError>> {

        return Networking.shared.request(method: .get,
                                         endpoint: APIPath.user_info.url)
            .map { result -> Result<UserInfo, APIError> in
                return result.map { UserInfo(fromJson: $0)}
        }
    }
    
    //MARK: Booking
    static func bookingAirPort(_ params: [String: Any]) -> Observable<Result<Booking, APIError>>{
             return Networking.shared.requestHttpBody(method: .post, endpoint: APIPath.booking_airport.url, parameters: params)
             .map { result -> Result<Booking, APIError> in
                 return result.map { Booking(fromJson: $0["user"]) }
             }
         }
    
    static func listBooking(page: Int) -> Observable<Result<[Booking], APIError>>{
        return Networking.shared.request(method: .get, endpoint: "\(APIPath.list_booking.url)/\(page)", parameters: [String:Any]())
        .map { result -> Result<[Booking], APIError> in
            return result.map { $0["data"].arrayValue.map { Booking(fromJson: $0) } }
        }
    }
        
    static func listCoupon() -> Observable<Result<[Coupon], APIError>>{
          return Networking.shared.request(method: .get, endpoint: APIPath.list_coupon.url, parameters: [String:Any]())
          .map { result -> Result<[Coupon], APIError> in
              return result.map { $0.arrayValue.map { Coupon(fromJson: $0) } }
          }
      }
    
    static func calculatePriceAirPort(_ params: [String: Any]) -> Observable<Result<Calculate, APIError>>{
              return Networking.shared.requestHttpBody(method: .post, endpoint: APIPath.calculate_airport.url, parameters: params)
              .map { result -> Result<Calculate, APIError> in
                  return result.map { Calculate(fromJson: $0) }
              }
          }
    
    static func getListVehicle() -> Observable<Result<[VehicleTypeModel], APIError>>{
        return Networking.shared.request(method: .get, endpoint: APIPath.vehicle_list.url)
        .map { result -> Result<[VehicleTypeModel], APIError> in
            return result.map { $0.arrayValue.map { VehicleTypeModel(fromJson: $0) }}
        }
    }
    
    
    static func listnotificationPaging(page: Int) -> Observable<Result<[NotificationModel], APIError>>{
        return Networking.shared.request(method: .get, endpoint: APIPath.list_notification.url)
        .map { result -> Result<[NotificationModel], APIError> in
            return result.map { $0.arrayValue.map { NotificationModel(fromJson: $0) } }
        }
    }
    
//
//    static func userLoginSNS(_ params: [String: Any]) -> Observable<Result<UserModel, APIError>>{
//             return Networking.shared.request(method: .post, endpoint: APIPath.user_login_sns.url, parameters: params)
//             .map { result -> Result<UserModel, APIError> in
//                return result.map { UserModel(json: $0["data"]) }
//             }
//         }
//
//    static func userChangeEmail(_ params: [String: Any]) -> Observable<Result<String, APIError>>{
//               return Networking.shared.request(method: .post, endpoint: APIPath.user_change_email.url, parameters: params)
//               .map { result -> Result<String, APIError> in
//                   return result.map { $0["message"].stringValue }
//               }
//           }
//
//    static func userUpdateInfo(_ params: [String: Any]) -> Observable<Result<String, APIError>>{
//        return Networking.shared.request(method: .post, endpoint: APIPath.user_update_info.url, parameters: params)
//        .map { result -> Result<String, APIError> in
//            return result.map { $0["message"].stringValue }
//        }
//    }
//
//    static func userUpdateInfoSNS(userInfo:UserModel) -> Observable<Result<String, APIError>>{
//        let params = userInfo.toJSON()
//        return Networking.shared.request(method: .post, endpoint: APIPath.user_update_info.url, parameters: params)
//               .map { result -> Result<String, APIError> in
//                   return result.map { $0["message"].stringValue }
//               }
//           }
//
//    static func userUpdateAvatar(_ image: UIImage) -> Observable<Result<String, APIError>>{
//        var data: Data?
//        if let img : UIImage = image {
//            data = img.resizeWithWidth(width: 1000)?.pngData()
//        }
//        return Networking.shared.uploadAvatar("avatar\(Date().timestamp())", "jpg", imageData: data)
//              .map { result -> Result<String, APIError> in
//                  return result.map { $0["data"].stringValue }
//              }
//    }
//
//    static func userGetInfo(_ params: [String: Any]) -> Observable<Result<UserModel, APIError>>{
//            return Networking.shared.request(method: .get, endpoint: APIPath.user_info.url, parameters: params)
//            .map { result -> Result<UserModel, APIError> in
//                return result.map { UserModel(json: $0["data"]) }
//            }
//        }
//
//    static func userChangePassword(_ params: [String: Any]) -> Observable<Result<String, APIError>>{
//        return Networking.shared.request(method: .post, endpoint: APIPath.user_change_password.url, parameters: params)
//        .map { result -> Result<String, APIError> in
//            return result.map { $0["message"].stringValue }
//        }
//    }
//
//    static func userForgotPassword(_ params: [String: Any], retry: Int = 1) -> Observable<Result<String, APIError>>{
//        return Networking.shared.request(method: .post, endpoint: APIPath.user_forget_password.url, parameters: params, retryCount: retry)
//        .map { result -> Result<String, APIError> in
//            return result.map { $0["message"].stringValue }
//        }
//    }
//
//    static func userResetPassword(_ params: [String: Any]) -> Observable<Result<String, APIError>>{
//           return Networking.shared.request(method: .post, endpoint: APIPath.user_reset_password.url, parameters: params)
//           .map { result -> Result<String, APIError> in
//               return result.map { $0["message"].stringValue }
//           }
//       }
//
//    //MARK: - Statistical
//    //Weight
//    static func statisticalGetWeight(_ params: [String: Any]) -> Observable<Result<WeightModel, APIError>>{
//               return Networking.shared.request(method: .get, endpoint: APIPath.statistical_weight.url, parameters: params)
//               .map { result -> Result<WeightModel, APIError> in
//                   return result.map { WeightModel(fromJson: $0["data"]) }
//               }
//           }
//
//    static func statisticalCreateWeight(_ params: [String: Any]) -> Observable<Result<String, APIError>>{
//                 return Networking.shared.request(method: .post, endpoint: APIPath.statistical_weight_create.url, parameters: params)
//                 .map { result -> Result<String, APIError> in
//                     return result.map { $0["message"].stringValue }
//                 }
//             }
//
//    static func statisticalGetOther(_ params: [String: Any]) -> Observable<Result<[OtherIndexModel], APIError>> {
//        return Networking.shared.request(method: .get,
//                                         endpoint: APIPath.statistical_other.url,
//                                         parameters: params)
//            .map { result -> Result<[OtherIndexModel], APIError> in
//                return result.map { $0["data"].arrayValue.map { OtherIndexModel(fromJson: $0) } }
//        }
//    }
//
//    static func statisticalCreateOther(_ params: [String: Any]) -> Observable<Result<String, APIError>>{
//                  return Networking.shared.request(method: .post, endpoint: APIPath.statistical_other_create.url, parameters: params)
//                  .map { result -> Result<String, APIError> in
//                      return result.map { $0["message"].stringValue }
//                  }
//              }
//
//    static func statisticalGetTraining(_ params: [String: Any]) -> Observable<Result<TrainingPageModel, APIError>> {
//        return Networking.shared.request(method: .get, endpoint: APIPath.statistical_training.url, parameters: params)
//           .map { result -> Result<TrainingPageModel, APIError> in
//               return result.map { TrainingPageModel(fromJson: $0["data"]) }
//           }
//       }
//
//    static func statisticalCreateTraining(_ params: [String: Any]) -> Observable<Result<String, APIError>>{
//                  return Networking.shared.request(method: .post, endpoint: APIPath.statistical_training_create.url, parameters: params)
//                  .map { result -> Result<String, APIError> in
//                      return result.map { $0["message"].stringValue }
//                  }
//              }
//
//    static func statisticalListTraining(_ params: [String: Any]) -> Observable<Result<[MenuModel], APIError>>{
//        return Networking.shared.request(method: .get, endpoint: APIPath.statistical_training_menu.url, parameters: params)
//        .map { result -> Result<[MenuModel], APIError> in
//            return result.map { $0["data"].arrayValue.map { MenuModel(json: $0) } }
//        }
//    }
//
//    // MARK: Booking
//
//    static func bookingGetCalendar(_ params: [String: Any]) -> Observable<Result<JSON, APIError>> {
//          return Networking.shared.request(method: .get, endpoint: APIPath.booking_calendar.url, parameters: params)
//            .map { result -> Result<JSON, APIError> in
//                return result.map {
//                    $0["data"]
//                }
//             }
//         }
//
//    static func registerFirstTime(_ params: [String: Any]) -> Observable<Result<JSON, APIError>> {
//     return Networking.shared.request(method: .post, endpoint: APIPath.register_shop_firsttime.url, parameters: params)
//       .map { result -> Result<JSON, APIError> in
//           return result.map {
//               $0["data"]
//           }
//        }
//    }
//
//    // MARK: Staff
//    static func staffList(_ params: [String: Any]) -> Observable<Result<[PTModel], APIError>> {
//          return Networking.shared.request(method: .get,
//                                           endpoint: APIPath.list_staff.url,
//                                           parameters: params)
//              .map { result -> Result<[PTModel], APIError> in
//                return result.map { $0["data"].dictionaryValue["list_staff"]!.arrayValue.map { PTModel(json: $0) } }
//          }
//      }
//
//    static func staffConnect(_ params: [String: Any]) -> Observable<Result<String, APIError>>{
//        return Networking.shared.request(method: .post, endpoint: APIPath.connect_staff.url, parameters: params)
//        .map { result -> Result<String, APIError> in
//            return result.map { $0["message"].stringValue }
//        }
//    }
//
//
//    // MARK: Chat
//    static func listChat(_ params: [String: Any]) -> Observable<Result<[BTChatModel], APIError>> {
//        return Networking.shared.request(method: .get,
//                                         endpoint: APIPath.list_chat.url,
//                                         parameters: params)
//            .map { result -> Result<[BTChatModel], APIError> in
//              return result.map { $0["data"].arrayValue.map { BTChatModel(json: $0) } }
//        }
//    }
//
//    static func chatDelete(_ params: [String: Any]) -> Observable<Result<String, APIError>>{
//                  return Networking.shared.request(method: .post, endpoint: APIPath.chat_delete.url, parameters: params)
//                  .map { result -> Result<String, APIError> in
//                      return result.map { $0["message"].stringValue }
//                  }
//              }
//
//
//
//
//    //Notification
//    static func getNotificationList(_ params: [String: Any]) -> Observable<Result<ServerNotificationModel, APIError>> {
//        return Networking.shared.request(method: .get,
//                                         endpoint: APIPath.list_notification.url,
//                                         parameters: params)
//            .map { result -> Result<ServerNotificationModel, APIError> in
//                return result.map { ServerNotificationModel(json: $0["data"]) }
//        }
//    }
//
//    static func getMealDetail(id: Int) -> Observable<Result<FoodModel, APIError>> {
//           let params = ["id":id]
//           return Networking.shared.request(method: .get,
//                                            endpoint: APIPath.meal_detail.url,
//                                            parameters: params)
//               .map { result -> Result<FoodModel, APIError> in
//                   return result.map { FoodModel(fromJson: $0["data"]) }
//           }
//       }
//
//    static func readNotification(_ id: Int) -> Observable<Result<String, APIError>>{
//        return Networking.shared.request(method: .get, endpoint: "\(APIPath.read_notification.url)\(id)", parameters: [String:Any]())
//                    .map { result -> Result<String, APIError> in
//                        return result.map { $0["message"].stringValue }
//                    }
//                }
//
//	// MARK: - AppSetting
//	/**
//	App setting
//	**/
////	static func appSetting(retry: Int = 1) -> Observable<Result<JSON, APIError>> {
////		return Networking.shared.request(method: .get, endpoint: APIPath.appSetting.url, retryCount: retry)
////			.do(onNext: { result in
////				// Check version update
////				if let json = try? result.get() {
////					let version = json["current_ios_version"].stringValue
////					let force = AppVersionManage.UpdateFlagType(rawValue: json["force_update_flag"].intValue) ?? .nothing
////					AppVersionManage.shared.check(version: version, type: force)
////				}
////			})
////			.map { result -> Result<JSON, APIError> in
////				return result.map { $0["data"] }
////		}
////	}
////
////	static func websetting(_ param: [String: Any]) -> Observable<Result<WebSettingModel, APIError>> {
////		return Networking.shared.request(method: .get, endpoint: APIPath.websetting.url, parameters: param)
////			.map { result -> Result<WebSettingModel, APIError> in
////				return result.map { WebSettingModel(fromJson: $0["data"]) }
////		}
////	}
////
////	static func holidays() -> Observable<Result<JSON, APIError>> {
////		return Networking.shared.request(method: .get, endpoint: APIPath.holidays.url)
////			.map { result -> Result<JSON, APIError> in
////				return result.map { $0["data"] }
////		}
////	}
////
////
////	// MARK: - User
////	/**
////	User
////	**/
////	static func createUser(retry: Int = 1) -> Observable<Result<UserModel, APIError>> {
////		return Networking.shared.request(method: .post, endpoint: APIPath.createUser.url, retryCount: retry)
////			.map { result -> Result<UserModel, APIError> in
////				return result.map { UserModel(fromJson: $0["data"]) }
////		}
////	}
////
////
////	static func profile(retry: Int = 1) -> Observable<Result<UserModel, APIError>> {
////		return Networking.shared.request(method: .get, endpoint: APIPath.profile.url, retryCount: retry)
////			.map { result -> Result<UserModel, APIError> in
////				return result.map { UserModel(fromJson: $0["data"]) }
////		}
////	}
////
////	static func updateProfile(_ param: [String: Any]) -> Observable<Result<UserModel, APIError>> {
////		return Networking.shared.request(method: .post,
////										 endpoint: APIPath.profile.url,
////										 parameters: param)
////			.map { result -> Result<UserModel, APIError> in
////				return result.map { UserModel(fromJson: $0["data"]) }
////		}
////	}
////
////    static func updateStoreNotification(_ param: [String: Any]) -> Observable<Result<[StoreModel], APIError>> {
////        return Networking.shared.request(method: .post,
////                                         endpoint: APIPath.setShopNotification.url,
////                                         parameters: param)
////            .map { result -> Result<[StoreModel], APIError> in
////                return result.map { $0["data"].arrayValue.map { StoreModel(fromJson: $0) } }
////        }
////    }
////
////	static func modelChangeInfo() -> Observable<Result<JSON, APIError>> {
//		return Networking.shared.request(method: .get, endpoint: APIPath.modelChange.url)
//			.map { $0.map { $0["data"] } }
//	}
//
//	static func changeModel(_ param: [String: Any]) -> Observable<Result<UserModel, APIError>> {
//		return Networking.shared.request(method: .post,
//										 endpoint: APIPath.modelChange.url,
//										 parameters: param)
//			.map { result -> Result<UserModel, APIError> in
//				return result.map { UserModel(fromJson: $0["data"]) }
//		}
//	}
//
//	static func changeModelBySocial(_ param: [String: Any]) -> Observable<Result<UserModel, APIError>> {
//		return Networking.shared.request(method: .post,
//										 endpoint: APIPath.socialModelChange.url,
//										 parameters: param)
//			.map { result -> Result<UserModel, APIError> in
//				return result.map { UserModel(fromJson: $0["data"]) }
//		}
//	}
//
//	static func logout() -> Observable<Result<String, APIError>> {
//		return Networking.shared.request(method: .get, endpoint: APIPath.logout.url)
//			.map { $0.map { $0["message"].stringValue } }
//	}
//
//	static func registerDevice(_ param: [String: Any]) -> Observable<Result<Void, APIError>> {
//		return Networking.shared.request(method: .post,
//										 endpoint: APIPath.registerDevice.url,
//										 parameters: param)
//			.map { result -> Result<Void, APIError> in
//				return result.map { _ in return }
//		}
//	}
//
//	static func linkSocial(_ param: [String: Any]) -> Observable<Result<Void, APIError>> {
//		return Networking.shared.request(method: .post,
//										 endpoint: APIPath.linkSocial.url,
//										 parameters: param)
//			.map { result -> Result<Void, APIError> in
//				return result.map { _ in return }
//		}
//	}
//
//	static func memberLogin(_ param: [String: Any]) -> Observable<Result<UserModel, APIError>> {
//		return Networking.shared.request(method: .post,
//										 endpoint: APIPath.memberLogin.url,
//										 parameters: param)
//			.map { result -> Result<UserModel, APIError> in
//				return result.map { UserModel(fromJson: $0["data"]) }
//		}
//	}
//
//
//	// MARK: - Shop
//	/**
//	Shop
//	**/
//	static func shopAreas() -> Observable<Result<[ShopArea], APIError>> {
//		return Networking.shared.request(method: .get, endpoint: APIPath.shops.url)
//			.map { result -> Result<[ShopArea], APIError> in
//				return result.map { $0["data"].arrayValue.map { ShopArea(fromJson: $0) } }
//		}
//	}
//
//
//	static func branchs(retry: Int) -> Observable<Result<[StoreModel], APIError>> {
//		return Networking.shared.request(method: .get, endpoint: APIPath.branchs.url, retryCount: retry)
//			.map { result -> Result<[StoreModel], APIError> in
//				return result.map { $0["data"].arrayValue.map { StoreModel(fromJson: $0) }
//				}
//		}
//	}
//
//
//
//
//	// MARK: - Magic pot
//	static func magicpotPackage() -> Observable<Result<MagicpotModel, APIError>> {
//		return Networking.shared.request(method: .get, endpoint: APIPath.magicpotPackage.url)
//			.map { result -> Result<MagicpotModel, APIError> in
//				return result.map { MagicpotModel(fromJson: $0["data"]) }
//		}
//	}
//
//    static func changeToNextMagicpotContract() -> Observable<Result<MagicpotModel, APIError>> {
//        return Networking.shared.request(method: .get, endpoint: APIPath.changeToNextMagicpotContract.url)
//            .map { result -> Result<MagicpotModel, APIError> in
//                return result.map { MagicpotModel(fromJson: $0["data"]) }
//        }
//    }
//
//	static func addFlower(_ param: [String: Any]) -> Observable<Result<MagicpotModel, APIError>> {
//		return Networking.shared.request(method: .post,
//										 endpoint: APIPath.addFlower.url,
//										 parameters: param)
//			.map { result -> Result<MagicpotModel, APIError> in
//				return result.map { MagicpotModel(fromJson: $0["data"]) }
//		}
//	}
//
//	static func buyMagicPackage(_ param: [String: Any]) -> Observable<Result<MagicpotModel, APIError>> {
//		return Networking.shared.request(method: .post,
//										 endpoint: APIPath.buyMagicPackage.url,
//										 parameters: param)
//			.map { result -> Result<MagicpotModel, APIError> in
//				return result.map { MagicpotModel(fromJson: $0["data"]) }
//		}
//	}
//
//
//
//	// MARK: - Reserve
//	/**
//	Create reserve and feedback
//	**/
//	static func feedback(_ param: [String: Any]) -> Observable<Result<Void, APIError>> {
//		return Networking.shared.request(method: .post,
//										 endpoint: APIPath.feedback.url,
//										 parameters: param)
//			.map { $0.map { _ in return } }
//	}
//
//	static func reserve(_ param: [String: Any]) -> Observable<Result<Void, APIError>> {
//		return Networking.shared.request(method: .post,
//										 endpoint: APIPath.reserve.url,
//										 parameters: param)
//			.map { $0.map { _ in return } }
//	}
//
//
//
//	// MARK: - Notice
//	static func getInfos(_ param: [String: Any]) -> Observable<Result<[InfoModel], APIError>> {
//		return Networking.shared.request(method: .get,
//										 endpoint: APIPath.infos.url,
//										 parameters: param)
//			.map { result -> Result<[InfoModel], APIError> in
//				return result.map { $0["data"]["data"].arrayValue.map { InfoModel(fromJson: $0) } }
//		}
//	}
//
//	static func infoFavorite(_ param: [String: Any]) -> Observable<Result<Bool, APIError>> {
//		return Networking.shared.request(method: .post,
//										 endpoint: APIPath.likeInfo.url,
//										 parameters: param)
//			.map { result -> Result<Bool, APIError> in
//				return result.map { $0["data"]["is_favorite"].boolValue }
//		}
//	}
//
//	static func getComments(_ param: [String: Any]) -> Observable<Result<[CommentModel], APIError>> {
//		return Networking.shared.request(method: .get,
//										 endpoint: APIPath.comments.url,
//										 parameters: param)
//			.map { result -> Result<[CommentModel], APIError> in
//				return result.map { $0["data"].arrayValue.map { CommentModel(fromJson: $0) }
//				}
//		}
//	}
//
//	static func createComment(_ param: [String: Any]) -> Observable<Result<CommentModel, APIError>> {
//		return Networking.shared.request(method: .post,
//										 endpoint: APIPath.createComment.url,
//										 parameters: param)
//			.map { result -> Result<CommentModel, APIError> in
//				return result.map { CommentModel(fromJson: $0["data"]) }
//		}
//	}
//
//
//	static func deleteComment(_ param: [String: Any]) -> Observable<Result<Int, APIError>> {
//		return Networking.shared.request(method: .delete,
//										 endpoint: APIPath.deleteComment.url,
//										 parameters: param)
//			.map { result -> Result<Int, APIError> in
//				return result.map { _ in param["comment_id"] as? Int ?? 0 }
//		}
//	}
//
//	static func reportComment(_ param: [String: Any]) -> Observable<Result<Void, APIError>> {
//		return Networking.shared.request(method: .post,
//										 endpoint: APIPath.report.url,
//										 parameters: param)
//			.map { result -> Result<Void, APIError> in
//				return result.map { _ in return }
//		}
//	}
//
//	static func editComment(_ param: [String: Any]) -> Observable<Result<Void, APIError>> {
//		return Networking.shared.request(method: .put,
//										 endpoint: APIPath.editComment.url,
//										 parameters: param)
//			.map { result -> Result<Void, APIError> in
//				return result.map { _ in return }
//		}
//	}
//
//	static func readNotice(_ param: [String: Any]) -> Observable<Result<Void, APIError>> {
//		return Networking.shared.request(method: .get,
//										 endpoint: APIPath.info.url,
//										 parameters: param)
//			.map { result -> Result<Void, APIError> in
//				return result.map { _ in return }
//		}
//	}
//
//
//
//
//	// MARK: - Point card
//	static func pointCard(_ param: [String: Any]) -> Observable<Result<PointModel, APIError>> {
//		return Networking.shared.request(method: .get,
//										 endpoint: APIPath.pointCard.url,
//										 parameters: param)
//			.map { result -> Result<PointModel, APIError> in
//				return result.map { PointModel(fromJson: $0["data"]) }
//		}
//	}
//
//	static func pointInfo() -> Observable<Result<PointModel, APIError>> {
//		return Networking.shared.request(method: .get,
//										 endpoint: APIPath.pointInfo.url)
//			.map { result -> Result<PointModel, APIError> in
//				return result.map { PointModel(fromJson: $0["data"]) }
//		}
//	}
//
//	static func pointHistory(_ param: [String: Any]) -> Observable<Result<[PointHistory], APIError>> {
//		return Networking.shared.request(method: .get,
//										 endpoint: APIPath.pointHistory.url,
//										 parameters: param)
//			.map { result -> Result<[PointHistory], APIError> in
//				return result.map { $0["data"]["data"].arrayValue.map { PointHistory(fromJson: $0) } }
//		}
//	}
//
//	static func updatePoint(_ param: [String: Any]) -> Observable<Result<PointModel, APIError>> {
//		return Networking.shared.request(method: .post,
//										 endpoint: APIPath.updatePoint.url,
//										 parameters: param)
//			.map { result -> Result<PointModel, APIError> in
//				return result.map { PointModel(fromJson: $0["data"]) }
//		}
//	}
//
//
//
//	// MARK: - Stamp
//	static func stamp() -> Observable<Result<StampModel, APIError>> {
//		return Networking.shared.request(method: .get,
//										 endpoint: APIPath.stamp.url)
//			.map { result -> Result<StampModel, APIError> in
//				return result.map { StampModel(fromJson: $0["data"]) }
//		}
//	}
//
//	static func addStamp(_ param: [String: Any]) -> Observable<Result<StampModel, APIError>> {
//		return Networking.shared.request(method: .post,
//										 endpoint: APIPath.addStamp.url,
//										 parameters: param)
//			.map { result -> Result<StampModel, APIError> in
//				return result.map { StampModel(fromJson: $0["data"]) }
//		}
//	}
//
//    static func updateRallyUser() -> Observable<Result<StampModel, APIError>> {
//        return Networking.shared.request(method: .post,
//                                         endpoint: APIPath.updateRallyUser.url)
//            .map { result -> Result<StampModel, APIError> in
//                return result.map { StampModel(fromJson: $0["data"]) }
//        }
//    }
//
//
//	// MARK: - Coupon
//	static func coupons(_ param: [String: Any]) -> Observable<Result<[CouponModel], APIError>> {
//		return Networking.shared.request(method: .get,
//										 endpoint: APIPath.coupons.url,
//										 parameters: param)
//			.map { result -> Result<[CouponModel], APIError> in
//				return result.map { $0["data"].arrayValue.map { CouponModel(fromJson: $0) }
//				}
//		}
//	}
//
//
//	static func useCoupon(_ param: [String: Any]) -> Observable<Result<String, APIError>> {
//		return Networking.shared.request(method: .post,
//										 endpoint: APIPath.useCoupon.url,
//										 parameters: param)
//			.map { result -> Result<String, APIError> in
//				return result.map { $0["message"].stringValue }
//		}
//	}
}



































