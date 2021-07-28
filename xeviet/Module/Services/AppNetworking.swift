//
//  AppNetworking.swift
//  furarepi
//
//  Created by nhatquangz on 5/8/19.
//  Copyright © 2019 paditech. All rights reserved.
//

import Alamofire
import Foundation
import RxCocoa
import RxSwift
import RxSwiftExt
import SwiftyJSON

typealias PARAM = [String : Any]

enum APIError: Error {
    case serverError(Any?)
    case offline
    case message(String?)
}

extension APIError {
    /// Get default message returned by server
    var message: String {
        switch self {
        case .serverError(let data):
            guard let data = data as? Data, let serverMessage = try? JSON(data: data)["message"].stringValue else {
                return "SOMETHING WRONG".localized()
            }
            if serverMessage != "" {
                return serverMessage
            } else {
                return "SOMETHING WRONG".localized()
            }
            
        case .offline:
            return "NO INTERNET".localized()
        case .message(let message):
            return message ?? ""
        }
    }
}

class Networking: NSObject {
    static let shared = Networking()
    
    var sessionManager: Session!
    let kTimeoutIntervalForRequest = 30
    var reachabilityService: DefaultReachabilityService!
    
    let myBag = DisposeBag()
    
    override init() {
        super.init()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(kTimeoutIntervalForRequest)
        //configuration.httpAdditionalHeaders?.updateValue("application/json",forKey: "Content-Type")
        sessionManager = Session(configuration: configuration)
        reachabilityService = try! DefaultReachabilityService()
        _ = reachabilityService.reachability
            .map { $0.reachable }
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
            .subscribe(onNext: { reachable in
                print("Network state: \(reachable)")
                if !reachable {
                    DispatchQueue.main.async {
                        AppMessagesManager.shared.showNoInternetConnection()
                    }
                }
			})
    }
}

// MARK: - Method

extension Networking {
    
    func requestHttpBody(method: HTTPMethod,
                  endpoint: String,
                  parameters: [String: Any]? = nil,
                  withToken: Bool = true,
                  encoding: ParameterEncoding = JSONEncoding.default,
                  retryCount: Int = 1) -> Observable<Result<JSON, APIError>> {
         let aParameters: [String: Any] = parameters ?? [:]
      
         var headers: HTTPHeaders?
         if let token = AppManager.shared.accessToken, withToken {
             headers = HTTPHeaders()
             headers?["Authorization"] = "Token \(token)"
         }
         
         // Log
         print("\(method.rawValue): \(endpoint)")
         print("PARAMS: \(aParameters)")
         
         return Observable<Result<JSON, APIError>>.create { observer -> Disposable in
             self.sessionManager.request(endpoint, method: method, parameters: aParameters, encoding: encoding, headers: headers)
                 .validate(statusCode: 200..<300)
                 .responseJSON { response in
                     switch response.result {
                     case .success(let value):
                         let json = JSON(value)
                         print("json from \(endpoint): \(value)")
                         
                         if let token:String? = json["token"].stringValue{
                             if token != ""{
                                 AppManager.shared.accessToken = token
                             }
                         }
                         observer.onNext(.success(JSON(value)))
                     case .failure(let error):
                         print("Error api call to \(endpoint): \(error.localizedDescription)")
                         observer.onError(APIError.serverError(response.data))
                     }
                 }
             return Disposables.create()
         }.retry(.delayed(maxCount: UInt(retryCount), time: 5))
             .catchError { error -> Observable<Result<JSON, APIError>> in
                 Observable.just(.failure(error as! APIError))
             }
     }
    
    
    func request(method: HTTPMethod,
                 endpoint: String,
                 parameters: [String: Any]? = nil,
                 withToken: Bool = true,
                 encoding: ParameterEncoding = URLEncoding.default,
                 retryCount: Int = 1) -> Observable<Result<JSON, APIError>> {
        let aParameters: [String: Any] = parameters ?? [:]
     
        var headers: HTTPHeaders?
        if let token = AppManager.shared.accessToken, withToken {
            headers = HTTPHeaders()
            headers?["Authorization"] = "Token \(token)"
        }
        
        // Log
        print("\(method.rawValue): \(endpoint)")
        print("PARAMS: \(aParameters)")
        
        return Observable<Result<JSON, APIError>>.create { observer -> Disposable in
            self.sessionManager.request(endpoint, method: method, parameters: aParameters, encoding: encoding, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        print("json from \(endpoint): \(value)")
                        
                        if let token:String? = json["token"].stringValue{
                            if token != ""{
                                AppManager.shared.accessToken = token
                            }
                        }
                        observer.onNext(.success(JSON(value)))
                    case .failure(let error):
                        print("Error api call to \(endpoint): \(error.localizedDescription)")
                        observer.onError(APIError.serverError(response.data))
                    }
                }
            return Disposables.create()
        }.retry(.delayed(maxCount: UInt(retryCount), time: 5))
            .catchError { error -> Observable<Result<JSON, APIError>> in
                Observable.just(.failure(error as! APIError))
            }
    }
    
    func loadFileSync(url: URL, completion: @escaping (String?, Error?) -> Void) {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        
        if FileManager().fileExists(atPath: destinationUrl.path) {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl.path, nil)
        } else if let dataFromURL = NSData(contentsOf: url) {
            if dataFromURL.write(to: destinationUrl, atomically: true) {
                print("file saved [\(destinationUrl.path)]")
                completion(destinationUrl.path, nil)
            } else {
                print("error saving file")
                let error = NSError(domain: "Error saving file", code: 1001, userInfo: nil)
                completion(destinationUrl.path, error)
            }
        } else {
            let error = NSError(domain: "Error downloading file", code: 1002, userInfo: nil)
            completion(destinationUrl.path, error)
        }
    }
    
    func loadFileAsync(url: URL, dir: String, name: String, ext: String, completion: @escaping (String?, Error?) -> Void) {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let file = "\(name).\(ext)"
        
        let destinationUrl = documentsUrl.appendingPathComponent("\(dir)/\(file)")
        
        if FileManager().fileExists(atPath: destinationUrl.path) {
            print("File already exists [\(destinationUrl.path)]")
            completion(destinationUrl.path, nil)
        } else {
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler:
                {
                    data, response, error in
                    if error == nil {
                        if let response = response as? HTTPURLResponse {
                            if response.statusCode == 200 {
                                if let data = data {
                                    if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic) {
                                        completion(destinationUrl.path, error)
                                    } else {
                                        completion(destinationUrl.path, error)
                                    }
                                } else {
                                    completion(destinationUrl.path, error)
                                }
                            }
                        }
                    } else {
                        completion(destinationUrl.path, error)
                    }
               })
            task.resume()
        }
    }
    /*
    func uploadChatMedia(_ name: String, _ ext: String, parameters: [String: Any]? = nil, mediaData: Data? = nil, retryCount: Int = 1) -> Observable<Result<JSON, APIError>> {
        var params: [String: Any] = parameters ?? [:]
        
        var headers: HTTPHeaders?
        if let token = AppManager.shared.accessToken {
            headers = HTTPHeaders()
            headers?["Authorization"] = token
            headers?["Content-type"] = "multipart/form-data"
            headers?["Content-Disposition"] = "form-data"
        }
        
        if ext == "jpg" {
            params["type"] = "1"
        } else {
            params["type"] = "2"
        }
        
        return Observable<Result<JSON, APIError>>.create { observer -> Disposable in
            
            self.sessionManager.upload(multipartFormData: { multipartFormData in
                if let data = mediaData {
                    let fileName = "\(name).\(ext)"
                    if ext == "jpg" {
                        multipartFormData.append(data, withName: "media", fileName: fileName, mimeType: "image/jpeg")
                    } else {
                        multipartFormData.append(data, withName: "media", fileName: fileName, mimeType: "video/mp4")
                    }
                }
                
                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
                }, usingThreshold: UInt64(), to: APIPath.media_upload.url, method: .post, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        // Update server time
                        //                        AppManager.shared.serverTime = json["current_time"].doubleValue
                        
                        if json["code"].intValue == 0 {
                            observer.onNext(.success(JSON(value)))
                        } else {
                            /// Detect via error message, actually we need a better way in future :)))
                            if APIError.serverError(response.data).message == "Authorization fail" {
                                //                                AppCoordinator.shared.invalidToken.onNext(())
                                observer.onCompleted()
                            }
                            
                            observer.onError(APIError.serverError(response.data))
                        }
                    case .failure(let error):
                        print("Error api media upload: \(error.localizedDescription)")
                        /// Notify if error is invalid token
                        //                        if 401 == error.responseCode {
                        //                            AppCoordinator.shared.invalidToken.onNext(())
                        //                            observer.onCompleted()
                        //                        }
                        observer.onError(APIError.serverError(response.data))
                    }
                    observer.onCompleted()
                }
            return Disposables.create()
        }
        .retry(.delayed(maxCount: UInt(retryCount), time: 5))
        .catchError { error -> Observable<Result<JSON, APIError>> in
            Observable.just(.failure(error as! APIError))
        }
    }
    
    func upload(_ name: String, _ ext: String, parameters: [String: Any]? = nil, imageParam: String, imageData: Data? = nil, retryCount: Int = 1) -> Observable<Result<JSON, APIError>> {
        let params: [String: Any] = parameters ?? [:]
        
        var headers: HTTPHeaders?
        if let token = AppManager.shared.accessToken {
            headers = HTTPHeaders()
            headers?["Authorization"] = token
            headers?["Content-type"] = "multipart/form-data"
            headers?["Content-Disposition"] = "form-data"
        }
        
        return Observable<Result<JSON, APIError>>.create { observer -> Disposable in
            
            self.sessionManager.upload(multipartFormData: { multipartFormData in
                if let data = imageData {
                    let fileName = "\(name).\(ext)"
                    if ext == "jpg" {
                        multipartFormData.append(data, withName: "media", fileName: fileName, mimeType: "image/jpeg")
                    } else {
                        multipartFormData.append(data, withName: "media", fileName: fileName, mimeType: "video/mp4")
                    }
                }
                
                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
            }, usingThreshold: UInt64(), to: APIPath.media_upload.url, method: .post, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        // Update server time
//                        AppManager.shared.serverTime = json["current_time"].doubleValue
                        
                        if json["code"].intValue == 0 {
                            observer.onNext(.success(JSON(value)))
                        } else {
                            /// Detect via error message, actually we need a better way in future :)))
                            if APIError.serverError(response.data).message == "Authorization fail" {
//                                AppCoordinator.shared.invalidToken.onNext(())
                                observer.onCompleted()
                            }
                            
                            observer.onError(APIError.serverError(response.data))
                        }
                    case .failure(let error):
                        print("Error api media upload: \(error.localizedDescription)")
                        /// Notify if error is invalid token
//                        if 401 == error.responseCode {
//                            AppCoordinator.shared.invalidToken.onNext(())
//                            observer.onCompleted()
//                        }
                        observer.onError(APIError.serverError(response.data))
                    }
                    observer.onCompleted()
                }
            return Disposables.create()
        }
        .retry(.delayed(maxCount: UInt(retryCount), time: 5))
        .catchError { error -> Observable<Result<JSON, APIError>> in
            Observable.just(.failure(error as! APIError))
        }
    }
    
     func uploadAvatar(_ name: String, _ ext: String, parameters: [String: Any]? = nil, imageData: Data? = nil, retryCount: Int = 1) -> Observable<Result<JSON, APIError>> {
            let params: [String: Any] = parameters ?? [:]
            
            var headers: HTTPHeaders?
            if let token = AppManager.shared.accessToken {
                headers = HTTPHeaders()
                headers?["Authorization"] = token
                headers?["Content-type"] = "multipart/form-data"
                headers?["Content-Disposition"] = "form-data"
            }
            
            return Observable<Result<JSON, APIError>>.create { observer -> Disposable in
                
                self.sessionManager.upload(multipartFormData: { multipartFormData in
                    if let data = imageData {
                        let fileName = "\(name).\(ext)"
                        multipartFormData.append(data, withName: "avatar", fileName: fileName, mimeType: "image/jpeg")
                    }
                    
                    for (key, value) in params {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                }, usingThreshold: UInt64(), to: APIPath.user_change_avatar.url, method: .post, headers: headers)
                    .validate(statusCode: 200..<300)
                    .responseJSON { response in
                        switch response.result {
                        case .success(let value):
                            let json = JSON(value)
                            // Update server time
    //                        AppManager.shared.serverTime = json["current_time"].doubleValue
                            
                            if json["code"].intValue == 0 {
                                observer.onNext(.success("アバターを正常に置き換えました"))
                            } else {
                                /// Detect via error message, actually we need a better way in future :)))
                                if APIError.serverError(response.data).message == "Authorization fail" {
    //                                AppCoordinator.shared.invalidToken.onNext(())
                                    observer.onCompleted()
                                }
                                
                                observer.onError(APIError.serverError(response.data))
                            }
                        case .failure(let error):
                            print("Error api media upload: \(error.localizedDescription)")
                            /// Notify if error is invalid token
    //                        if 401 == error.responseCode {
    //                            AppCoordinator.shared.invalidToken.onNext(())
    //                            observer.onCompleted()
    //                        }
                            observer.onError(APIError.serverError(response.data))
                        }
                        observer.onCompleted()
                    }
                return Disposables.create()
            }
            .retry(.delayed(maxCount: UInt(retryCount), time: 5))
            .catchError { error -> Observable<Result<JSON, APIError>> in
                Observable.just(.failure(error as! APIError))
            }
        }
    
    func upload(_ name: String, _ ext: String, api: APIPath, parameters: [String: Any]? = nil, mediaParam: String, imageData: Data? = nil, retryCount: Int = 1) -> Observable<Result<JSON, APIError>> {
        let params: [String: Any] = parameters ?? [:]
        
        var headers: HTTPHeaders?
        if let token = AppManager.shared.accessToken {
            headers = HTTPHeaders()
            headers?["Authorization"] = token
            headers?["Content-type"] = "multipart/form-data"
            headers?["Content-Disposition"] = "form-data"
        }
        
        return Observable<Result<JSON, APIError>>.create { observer -> Disposable in
            self.sessionManager.upload(multipartFormData: { multipartFormData in
                if let data = imageData {
                    let fileName = "\(name).\(ext)"
                    if ext == "jpg" {
                        multipartFormData.append(data, withName: mediaParam, fileName: fileName, mimeType: "image/jpeg")
                    } else {
                        multipartFormData.append(data, withName: mediaParam, fileName: fileName, mimeType: "video/mp4")
                    }
                }
                
                for (key, value) in params {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
            }, usingThreshold: UInt64(), to: api.url, method: .post, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        // Update server time
                        //                        AppManager.shared.serverTime = json["current_time"].doubleValue
                        
                        if json["code"].intValue == 0 {
                            observer.onNext(.success(JSON(value)))
                        } else {
                            /// Detect via error message, actually we need a better way in future :)))
                            if APIError.serverError(response.data).message == "Authorization fail" {
                                //                                AppCoordinator.shared.invalidToken.onNext(())
                                observer.onCompleted()
                            }
                            
                            observer.onError(APIError.serverError(response.data))
                        }
                    case .failure(let error):
                        print("Error api media upload: \(error.localizedDescription)")
                        /// Notify if error is invalid token
                        //                        if 401 == error.responseCode {
                        //                            AppCoordinator.shared.invalidToken.onNext(())
                        //                            observer.onCompleted()
                        //                        }
                        observer.onError(APIError.serverError(response.data))
                    }
                    observer.onCompleted()
                }
            return Disposables.create()
        }
        .retry(.delayed(maxCount: UInt(retryCount), time: 5))
        .catchError { error -> Observable<Result<JSON, APIError>> in
            Observable.just(.failure(error as! APIError))
        }
    }
 */
}
