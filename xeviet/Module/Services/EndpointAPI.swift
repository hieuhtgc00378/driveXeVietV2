//
//  EndpointAPI.swift
//  anecel
//
//  Created by NhatQuang on 5/21/18.
//  Copyright © 2018 Paditech. All rights reserved.
//

import Foundation

enum APIPath: String {
    //MARK: User
    case user_login = "passenger/login"
    case user_info = "passenger/me"
    case user_register = "passenger/register"
    /*
    case user_register_temporary = "user/register-temporary"
    case user_change_password = "user/change-password"
    case user_forget_password = "user/forgot-password"
    case user_reset_password = "user/reset-password"
    case user_login_sns = "user/login-sns"
    case user_change_email = "setting/change-email"
//    case user_update_info = "setting/update-profile"
    
    case user_register_deviceId = "user/add-player-id"
 */
    case user_change_avatar = "setting/change-avatar"
    
    
    case user_update_info = "passenger/update-info"
    
    case list_coupon = "passenger/promotion/active"
    
    //MARK: province
    case list_position = "passenger/position"
    case routeList = "passenger/route/city"
    case rideList = "passenger/route/specific"
    case caculate_ride = "passenger/booking/route/calculate"
    case booking_ride = "passenger/booking/route"
    
    //MARK: booking
    case booking_airport = "passenger/booking/airport"
    
    case list_booking = "passenger/booking-list"
    
    case calculate_airport = "passenger/booking/airport/calculate"
    case vehicle_list = "passenger/booking/list-car"
    
    //FastBooking
    case vehicle_type = "passenger/booking/fast/calculate"
    case booking_fast = "passenger/booking/fast"
    case booking_detail = "passenger/booking-detail"
    case cancel_booking = "passenger/booking-cancel"
    case checkBooking = "passenger/check-booking"
    
    //MARK: - Promotion
    case promotion_list = "passenger/promotions"
    
    /// Register Device
    case registerToken = "notification/playid"
    
    // Notification
    case notifications = "notifications"
    case notification_unread = "notification_unread"
    case read_notification = "notification/read?id="

    case documents = "documents"
    case agendas = "agendas"
    case photo = "photo"
    case author = "author"
    case splash = "splash"
    
    // Media
    case media_upload = "media/upload"
    
    // Chat
    case list_chat = "chat/list-group"
    case chat_delete = "chat/delete-group"
    
    
    // Setting
    case list_staff = "setting/staff-list"
    
    //Staff
    case connect_staff = "setting/staff-connect"
    
    //Notification
    case list_notification = "notification/get-notification"
    
}

// MARK: - Get absolute url
extension APIPath {
	var url: String {
		let baseURL = AppEnvironment.shared.current.baseURL
		return String(format: "%@/%@", baseURL, self.rawValue)
	}
}























