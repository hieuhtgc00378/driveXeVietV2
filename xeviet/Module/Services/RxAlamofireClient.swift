////
////  RxAlamofireClient.swift
////  qldt2-utility
////
////  Created by NhatQuang on 4/10/18.
////  Copyright © 2018 NhatQuang. All rights reserved.
////
//
//import Foundation
//import Alamofire
//import RxAlamofire
//import RxCocoa
//import RxSwift
//import ObjectMapper
//import SwiftyJSON
//
////enum APIError: Error {
////    case invalidURL(url: String)
////    case invalidResponseData(data: Any)
////    case error(responseCode: Int, data: Any)
////}
//
//enum ResponseError: Error {
//    case noStatusCode
//    case invalidData(data: Any)
//
//    case unknown(statusCode: Int)
//    case notModified // 304
//    case invalidRequest // 400
//    case unauthorized // 401
//    case accessDenied // 403
//    case notFound // 404
//    case methodNotAllowed // 405
//    case validate // 422
//    case serverError // 500
//    case badGateway // 502
//    case serviceUnavailable // 503
//    case gatewayTimeout // 504
//}
//
//public let kPageSize = 20
//
//class RxAlamofireClient: NSObject {
//
//    static let shared = RxAlamofireClient()
//
//    var sessionManager: SessionManager!
//    var baseURL: String = AppEnvironment.shared.current.baseURL
//    var headers: [String : Any] = [
//        //"Content-Type":"application/json; charset=utf-8",
//        "Accept":"application/json"
//    ]
//    var reachabilityService: DefaultReachabilityService!
//    var disposeBag = DisposeBag()
//
//    fileprivate override init() {
//        super.init()
//
////        self.baseURL = kBaseURL
//        let configuration = URLSessionConfiguration.default
//        configuration.timeoutIntervalForRequest = kTimeoutRequest
//        sessionManager = Alamofire.SessionManager(configuration: configuration)
//
//        // setup reachability
//        self.reachabilityService = try! DefaultReachabilityService() // try! is only for simplicity sake
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.reachabilityService.reachability
//                .map { $0.reachable }
//                .subscribe(onNext: { (reachable) in
//                    print(reachable)
//                    if !reachable {
//                        AppMessagesManager.shared.showNoInternetConnection()
//                    } else {
//                        AppMessagesManager.shared.hideNoInternetConnection()
//                    }
//                }, onError: nil, onCompleted: nil, onDisposed: nil)
//                .disposed(by: self.disposeBag)
//        }
//    }
//}
//
//// MARK: - API Call
//extension RxAlamofireClient {
//
//    func request(method: HTTPMethod,
//                 endpoint: String,
//                 parameters: [String : Any]? = nil,
//                 encoding: ParameterEncoding = URLEncoding.default,
//                 headers: [String : String]? = nil) -> Observable<Any> {
//
//        let aParameters: [String: Any] = parameters ?? [:]
//
//        let aHeader: [String : String] = headers ?? [:]
////        if let token = PAppManager.shared.accessToken, !token.isEmpty {
////            aHeader["X-USER-TOKEN"] = token
////            aHeader["X-DEVICE-ID"] = PAppManager.shared.deviceID
////        }
//
//        print("\(method.rawValue) : \(endpoint)")
//        print("HEADERS:\n\(aHeader)")
//        print("PARAMS:\n\(aParameters)")
//
//        let urlString = (self.baseURL + endpoint).addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
//                ?? ""
//
//        return self.sessionManager.rx
//            .request(method, urlString, parameters: aParameters, encoding: encoding, headers: aHeader)
//            .flatMap { dataRequest -> Observable<DataResponse<Any>> in
//                dataRequest
//                    .rx.responseJSON()
//            }
//            .map { (dataResponse) -> Any in
//                return try self.process(dataResponse)
//            }
//    }
//
//    func requestT<T:Mappable>(method: HTTPMethod,
//                 endpoint: String,
//                 parameters: [String : Any]? = nil,
//                 encoding: ParameterEncoding?,
//                 headers: [String : String]? = nil,
//                 mappable:T) -> Observable<BTResponseObject<T>> {
//        let aParameters: [String: Any] = parameters ?? [:]
//        let aHeader: [String : String] = headers ?? [:]
//
//        var coding:ParameterEncoding = URLEncoding.default
//        if encoding != nil {coding = encoding!}
//
//        let urlString = (self.baseURL + endpoint).addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) ?? ""
//
//        return self.sessionManager.rx
//                  .request(method, urlString, parameters: aParameters, encoding: coding, headers: aHeader)
//                  .flatMap { dataRequest -> Observable<DataResponse<Any>> in
//                    dataRequest.rx.responseJSON()
//                  }
//                  .map { (dataResponse) -> BTResponseObject<T> in
//                    return try self.processT(dataResponse) as BTResponseObject<T>
//                  }
//    }
//
//
//    func requestTList<T:Mappable>(method: HTTPMethod,
//                    endpoint: String,
//                    parameters: [String : Any]? = nil,
//                    encoding: ParameterEncoding?,
//                    headers: [String : String]? = nil,
//                    mappable:T) -> Observable<BTResponseList<T>> {
//           let aParameters: [String: Any] = parameters ?? [:]
//           let aHeader: [String : String] = headers ?? [:]
//
//           var coding:ParameterEncoding = URLEncoding.default
//           if encoding != nil {coding = encoding!}
//
//           let urlString = (self.baseURL + endpoint).addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) ?? ""
//
//           return self.sessionManager.rx
//                     .request(method, urlString, parameters: aParameters, encoding: coding, headers: aHeader)
//                     .flatMap { dataRequest -> Observable<DataResponse<Any>> in
//                         dataRequest
//                             .rx.responseJSON()
//                     }
//                     .map { (dataResponse) -> BTResponseList<T> in
//                       return try self.processTList(dataResponse) as BTResponseList<T>
//                     }
//       }
//
//
//    /*
//    func upload(endpoint: String,
//                parameters: [String : Any]? = nil,
//                imagesData: [(key: String, value: Data)]) -> Observable<Any> {
//        return Observable.create({ observer in
//            self.sessionManager.upload(multipartFormData: { (multipartFormData) in
//                // image data
//                for image in imagesData {
//                    multipartFormData.append(image.value, withName: image.key, fileName: "file.png", mimeType: "image/png")
//                }
//                // Other params
//                for (key, value) in parameters! {
//                    multipartFormData.append(String(describing: value).data(using: .utf8)!, withName: key)
//                }
//                // token
//                if let authToken = PAppManager.shared.accessToken {
//                    multipartFormData.append(String(describing: authToken).data(using: .utf8)!, withName: "auth_token")
//                }
//            }, to: endpoint, encodingCompletion: { (encodingResult) in
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.uploadProgress(closure: { (progress) in
//                        print("Total byte writen: \(progress.completedUnitCount)")
//                    })
//
//                    upload.responseJSON { response in
//                        /*
//                         print(response.request!)  // original URL request
//                         print(response.response!) // URL response
//                         print(response.data!)     // server data
//                         print(response.result)   // result of response serialization
//                         */
//                        if let value = response.result.value {
//                            observer.onNext(value)
//                            observer.onCompleted()
//                        } else {
//                            observer.onError(response.result.error!)
//                        }
//                    }
//
//                    break
//                case .failure(let encodingError):
//                    observer.onError(encodingError)
//                    break
//                }
//            })
//
//            return Disposables.create()
//        })
//    }
//    */
//
//    private func process(_ response: DataResponse<Any>) throws -> Any {
//        let error: Error
//        switch response.result {
//        case .success(let value):
//            print("RESPONSE:\n\(value)")
//
//            if let statusCode = response.response?.statusCode {
//                switch statusCode {
//                case 200:
//                    return value
//                case 304:
//                    error = ResponseError.notModified
//                case 400:
//                    error = ResponseError.invalidRequest
//                case 401:
//                    error = ResponseError.unauthorized
//                case 403:
//                    error = ResponseError.accessDenied
//                case 404:
//                    error = ResponseError.notFound
//                case 405:
//                    error = ResponseError.methodNotAllowed
//                case 422:
//                    error = ResponseError.validate
//                case 500:
//                    error = ResponseError.serverError
//                case 502:
//                    error = ResponseError.badGateway
//                case 503:
//                    error = ResponseError.serviceUnavailable
//                case 504:
//                    error = ResponseError.gatewayTimeout
//                default:
//                    error = ResponseError.unknown(statusCode: statusCode)
//                }
//            } else {
//                error = ResponseError.noStatusCode
//            }
//        case .failure(let e):
//            error = e
//        }
//        throw error
//    }
//
//    private func processT<T:Mappable>(_ response: DataResponse<Any>) throws -> BTResponseObject<T> {
//          let error: Error
//          switch response.result {
//          case .success(let value):
//              print("RESPONSE:\n\(value)")
//
//              if let statusCode = response.response?.statusCode {
//                  switch statusCode {
//                  case 0:
//                    if let jsonString = value as? String{
////                        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
////                            if let json:JSON = try? JSON(data: dataFromString){
////                                if let data:String = json["data"].stringValue{
////                                    if let model:T = Mapper<T>().map(JSONString: data){
////                                        return model
////                                    }else{
////                                        if let message:String = json["message"].stringValue{
////                                            return
////                                        }else{
////                                            error = ResponseError.notFound
////                                        }
////                                    }
////                                }else{
////                                    throw ResponseError.invalidData(data: value)
////                                }
////                            }else{
////                                throw ResponseError.invalidData(data: value)
////                            }
////                        }else{
////                            throw ResponseError.invalidData(data: value)
////                        }
//
//                        if let model:BTResponseObject<T> = Mapper<BTResponseObject<T>>().map(JSONString: jsonString){
//                            return model
//                        }else{
//                            throw ResponseError.invalidData(data: value)
//                        }
//                    }else{
//                        throw ResponseError.invalidData(data: value)
//                    }
//                  case 304:
//                      error = ResponseError.notModified
//                  case 400:
//                      error = ResponseError.invalidRequest
//                  case 401:
//                      error = ResponseError.unauthorized
//                  case 403:
//                      error = ResponseError.accessDenied
//                  case 404:
//                      error = ResponseError.notFound
//                  case 405:
//                      error = ResponseError.methodNotAllowed
//                  case 422:
//                      error = ResponseError.validate
//                  case 500:
//                      error = ResponseError.serverError
//                  case 502:
//                      error = ResponseError.badGateway
//                  case 503:
//                      error = ResponseError.serviceUnavailable
//                  case 504:
//                      error = ResponseError.gatewayTimeout
//                  default:
//                      error = ResponseError.unknown(statusCode: statusCode)
//                  }
//              } else {
//                  error = ResponseError.noStatusCode
//              }
//          case .failure(let e):
//              error = e
//          }
//          throw error
//      }
//
//
//    private func processTList<T:Mappable>(_ response: DataResponse<Any>) throws -> BTResponseList<T> {
//           let error: Error
//           switch response.result {
//           case .success(let value):
//               print("RESPONSE:\n\(value)")
//
//               if let statusCode = response.response?.statusCode {
//                   switch statusCode {
//                   case 200:
//                    if let jsonString = value as? String{
////                                      if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false) {
////                                          if let json:JSON = try? JSON(data: dataFromString){
////                                              if let data:String = json["data"].stringValue{
////                                                  if let model:[T] = Mapper<T>().mapArray(JSONString: data){
////                                                      return model
////                                                  }else{
////                                                       throw ResponseError.invalidData(data: data)
////                                                  }
////                                              }else{
////                                                  throw ResponseError.invalidData(data: value)
////                                              }
////                                          }else{
////                                              throw ResponseError.invalidData(data: value)
////                                          }
////                                      }else{
////                                          throw ResponseError.invalidData(data: value)
////                                      }
//
//                                    if let model:BTResponseList<T> = Mapper<BTResponseList<T>>().map(JSONString: jsonString){
//                                         return model
//                                     }else{
//                                         throw ResponseError.invalidData(data: value)
//                                     }
//                                  }else{
//                                      throw ResponseError.invalidData(data: value)
//                                  }
//                   case 304:
//                       error = ResponseError.notModified
//                   case 400:
//                       error = ResponseError.invalidRequest
//                   case 401:
//                       error = ResponseError.unauthorized
//                   case 403:
//                       error = ResponseError.accessDenied
//                   case 404:
//                       error = ResponseError.notFound
//                   case 405:
//                       error = ResponseError.methodNotAllowed
//                   case 422:
//                       error = ResponseError.validate
//                   case 500:
//                       error = ResponseError.serverError
//                   case 502:
//                       error = ResponseError.badGateway
//                   case 503:
//                       error = ResponseError.serviceUnavailable
//                   case 504:
//                       error = ResponseError.gatewayTimeout
//                   default:
//                       error = ResponseError.unknown(statusCode: statusCode)
//                   }
//               } else {
//                   error = ResponseError.noStatusCode
//               }
//           case .failure(let e):
//               error = e
//           }
//           throw error
//       }
//
//    func download(endpoint: String, filename: String) -> Observable<Any> {
//        return Observable.create({ observer in
//            let destinationFile: DownloadRequest.DownloadFileDestination = { _, response in
//                let suggestedName = response.suggestedFilename ?? filename
//                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//                let saveURL = documentsURL.appendingPathComponent("files", isDirectory: true)
//                let fileURL = saveURL.appendingPathComponent(suggestedName)
//
//                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
//            }
//
//            self.sessionManager.download(endpoint, to: destinationFile)
//                .downloadProgress { progress in
//                    print("Download Progress: \(progress.fractionCompleted)")
//                }
//                .response { response in
//                    //print(response)
//
//                    if let error = response.error {
//                        observer.onError(error)
//                    } else {
//                        let statusCode = response.response?.statusCode ?? 200
//
//                        if statusCode == 200, let filePath = response.destinationURL?.path {
//                            observer.onNext(filePath)
//                            observer.onCompleted()
//                        } else {
//                            observer.onError( APIError.error(responseCode: statusCode, data: "Đã xảy ra lỗi trong quá trình lưu file!") )
//                        }
//                    }
//            }
//
//            return Disposables.create()
//        })
//    }
//}
//
//
//
//
//
//
//
//
