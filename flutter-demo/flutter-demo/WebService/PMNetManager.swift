//
//  PMNetManager.swift
//  XBPMDev
//
//  Created by mac on 2018/3/28.
//  Copyright © 2018年 mac-cx. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper
import Moya
import Result
import SwiftyJSON;
class XBBaseResModel: Mappable {
    var privatefield: String?   // 返回客户端生成的唯一序号
    var restime: String?        // 响应时间
    
    //======
    var requestId: String?      // 返回客户端的请求ID
    var sign: String?           // 签名（requestId+restime）
    //======
    
    var message: String?        // 返回消息
    var code: Int?              // 返回代码
    var resdata:AnyObject?      // 若返回无数据，returnObject字段也得带上,可为空值
    
    required init?(map: Map) {
    }
    func mapping(map: Map) {
        privatefield        <-    map["privatefield"]
        restime             <-    map["restime"]
        
        requestId           <-    map["requestId"]
        sign                <-    map["sign"]
        
        code                <-    map["code"]
        message             <-    map["msg"]
        resdata             <-    map["resdata"]
    }
}
class XBBaseModel: NSObject {

}

/**
 *   封装一层 Mappable， 直接使用NSObject 放在请求体-resdata里面，映射不到json ，
 *   所有请求的model体，都继承此类
 */
class XBDataModel: Mappable {
    required init?(map: Map) {
        
    }
    init() {
        
    }
    func mapping(map: Map) {
    }
}

/**
 *   前后端约定的请求服务端报文格式 ， 主要参数为 resdata -> XBDataModel
 */
class XBBaseReqModel:NSObject, Mappable {
    var privatefield : String? = "" //客户端生成的唯一序号
//    var requestId    : String = ""//请求唯一ID（保证每次提交ID不能重复 最长32位）
    //var reqtime    : String? = Date.init().toString(format: "yyyy-MM-dd HH:mm:ss")//请求时间
    var reqtime      : String? = ""///请求时间
    
    //======
    var sign         : String?  = ""
    var clientId     : String  = "" //客户端ID
    //======
    
    var version      : String? = "2"//接口版本号
    var accesstoken  : String  = "" //AccessToken加密(服务器公钥)
    var reqdata      : XBDataModel? //请求版本体，没有可不传
    
    required init?(map: Map) {
        
    }
    override init() {
        
    }
    func mapping(map: Map) {

        privatefield <- map["privatefield"]
//        requestId <- map["requestId"]
        reqtime <- map["reqtime"]
        
        sign <- map["sign"]
//        deviceno <- map["deviceno"]
        clientId <- map["clientId"]

        version <- map["version"]
        accesstoken <- map["accesstoken"]
        reqdata <- map["reqdata"]
    }
}
typealias FailClosure               = (_ code: Int?, _ errorMsg:String?) -> ()
typealias SuccessClosure            = (_ result:AnyObject, _ code: Int?,_ message: String?) ->()

enum RequestCode: Int{
    case Success                                = 1000           // 数据请求成功
    case RefreshTokenError                      = 1004           // RefreshToken传入有误,弹出框提醒用户，用户确认后退出系统。
    case AccessTokenTimeout                     = 1005           // AccessToken已过期，客户端获取这个代码后需主动刷新Token。
    case AccessTokenError                       = 1006           // AccessToken传入有误，弹出框提醒用户，用户确认后退出系统。
    case userDisable                            = 1009           // 用户被禁用
    case RefreshTokenTimeout                    = 1015           // RefreshToken已过期，直接退出系统。
    case FailError                              = 2000           // 其他错误信息，直接显示即可
    case PubKeyError                            = 3501           // 密钥信息有误，重新交换密钥
    case ExcRateError                           = 10001          // 汇率有误
    case SecuError                              = 21002          // 安全密钥有误
    
    case SystemError                            = 9999           // 系统错误
}

extension Task {
    /**
     *   拿到Task 里面的请求参数
     */
   internal func getTaskParams()  -> String {
           switch self {
           case .requestParameters(let params, _):
               let json_str = JSON(params)
               return json_str.rawString([.castNilToNSNull: true]) ?? ""
           default:
               return ""
           }
       }
}

class XBNetManager {
    static let shared = XBNetManager()
    fileprivate init(){}
    public static func endpointClosure(target: RequestApi) -> Endpoint {
        let method = target.method
        
        let endpoint = Endpoint.init(url: target.baseURL.appendingPathComponent(target.path).absoluteString,
                                     sampleResponseClosure: {.networkResponse(200, target.sampleData)},
                                     method: method,
                                     task: target.task,
                                     httpHeaderFields: target.headers)
        
        return endpoint
    }
    public static let requestTimeoutClosure = { (endpoint: Endpoint, done: @escaping MoyaProvider<RequestApi>.RequestResultClosure) in
        guard var request = try? endpoint.urlRequest() else { return }
        request.timeoutInterval = TimeInterval(15) //设置请求超时时间
        done(.success(request))
    }
    let requestProvider = MoyaProvider<RequestApi>(endpointClosure: XBNetManager.endpointClosure,
                                                   requestClosure:  XBNetManager.requestTimeoutClosure)

    func requestWithTarget(
        _ target:RequestApi,
        isShowLoding: Bool              = true,  // 是否弹出loading框， 默认是
        isDissmissLoding: Bool          = true,  // 是否消失loading框， 默认是
        isShowErrorMessage: Bool        = true,  // 是否弹出错误提示， 默认是
        successClosure: @escaping SuccessClosure,
        failClosure: FailClosure? = nil
    ){
        // 之所以封装了一层，是为了区分，有一些接口，不需要此 判断本地Token 逻辑的时候，  直接调用 requestBaseWithTarget
        /// 本地刷新token逻辑
        
        self.requestBaseWithTarget(target, isShowLoding: isShowLoding, isDissmissLoding: isDissmissLoding, isShowErrorMessage: isShowErrorMessage, successClosure: successClosure, failClosure: failClosure)
    }
    func requestBaseWithTarget(
        _ target:RequestApi,
        isShowLoding:    Bool        = true,  // 是否弹出loading框， 默认是
        isDissmissLoding:    Bool    = true,  // 是否消失loading框， 默认是
        isShowErrorMessage: Bool     = true,  // 是否弹出错误提示， 默认是
        successClosure: @escaping SuccessClosure,
        failClosure: FailClosure? = nil
    ){
        self.requestFinalWithTarget(target, isShowLoding: isShowLoding, isDissmissLoding: isDissmissLoding, isShowErrorMessage: isShowErrorMessage, successClosure: successClosure, failClosure: failClosure)
    }
    func requestFinalWithTarget(
        _ target:RequestApi,
        isShowLoding:    Bool        = true,  // 是否弹出loading框， 默认是
        isDissmissLoding:    Bool    = true,  // 是否消失loading框， 默认是
        isShowErrorMessage: Bool     = true,  // 是否弹出错误提示， 默认是
        successClosure: @escaping SuccessClosure,
        failClosure: FailClosure? = nil
    ){
        
        
//        requestProvider.request(<#T##target: RequestApi##RequestApi#>, completion: <#T##Completion##Completion##(Result<Response, MoyaError>) -> Void#>)
        
    let task_log = "request target： \n请求的URL：\(target.path)\n请求的参数：\(target.task.getTaskParams())\n"
        print("target",task_log)
        _ =  requestProvider.request(target) { (result) in
            if isDissmissLoding {
            }
      
            switch result{
            case let .success(response):
                _ = response.data
                _ = response.statusCode
                guard let jsonString = try? response.mapString() else {
                    
                    if let failClosure = failClosure{
                        failClosure(0, "服务器内部错误")
                    }
                    return
                }
                print("jsonString",jsonString)
                let info = Mapper<XBBaseResModel>().map(JSONString:jsonString)
                //                               self.log_print(jsonString, info)
                 print("info",info)
                guard let code = info?.code else {
                    
                    if let failClosure = failClosure{
                        failClosure(0, "服务器内部错误")
                    }
                    return
                }
                let res = info?.resdata ?? [] as AnyObject
                successClosure(res, info?.code,info?.message)
            case .failure(_):
                if let failClosure = failClosure{
                    failClosure(0, "网络错误")
                }
                break
            }
        }
    }
    
    
}
extension XBNetManager {
    /**
     *  停止刷新动作
     */
    func endRrefreshing()  {
        DispatchQueue.main.async {
            //            (UIApplication.currentViewController() as? XBBaseViewController)?.endRefresh()
        }
    }
    /**
     *  配置默认图显示
     */
    func configEmptyDataSet() {
        //        (UIApplication.currentViewController() as? XBBaseViewController)?.loading       = true
    }
    /**
     *  取消所有的网络请求
     */
    func cancelAllRequest() {
        //XBHud.dismiss()
        //        requestProvider.manager.session.getAllTasks { (dataTasks) in
        //            dataTasks.forEachEnumerated{ $1.cancel() }
        //        }
    }
}
