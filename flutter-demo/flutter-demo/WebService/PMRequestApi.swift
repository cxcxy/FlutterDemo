//
//  PMRequestApi.swift
//  XBPMDev
//
//  Created by mac on 2018/3/28.
//  Copyright © 2018年 mac-cx. All rights reserved.
//
import UIKit
import Moya
/**
 *   定义一个接口的 Api 格式
 */
enum RequestApi{
    //MARK: 登录注册相关接口
  
    case api_exchangekey(req: [String: Any])
    case api_face(req: [String: Any])
    

    case api_flutter(url: String,req:[String: Any])
}
extension RequestApi {
    /**
     *   格式化 请求服务器的 json model 格式
     */
//    fileprivate func format(m: XBDataModel? = nil) -> [String: Any]{
//        let baseReq         = XBBaseReqModel.init()
//        baseReq.reqdata     = m
//        return baseReq.toJSON()
//    }
    /**
     *   格式化 请求服务器的 json dic 字典格式
     */
    fileprivate func formatDic(dic: [String: Any]? = nil) -> [String: Any]{
        var params_task         = [String: Any]()
        params_task             = XBBaseReqModel.init().toJSON()
        params_task["reqdata"]  = dic
        return params_task
    }
//    /**
//     *   格式化 请求服务器的 json 字典格式
//     */
//    fileprivate func formatArr(dic: [Any]? = nil) -> [String: Any]{
//        var params_task         = [String: Any]()
//        params_task             = XBBaseReqModel.init().toJSON()
//        params_task["reqdata"]  = dic
//        return params_task
//    }
}
extension RequestApi:TargetType{
    
//    public var path: String {
//        return ""
//    }
    
    // 服务器地址
    public var baseURL:URL{
        //return URL(string: ConfigManager.getServiceUrl())!
//        let
        let baseURLStr = "http://192.168.11.45:8085"

        return URL(string: baseURLStr)!
    }
    
    //请求任务事件（这里附带上参数）
    public var task: Task {
        var params_task = [String: Any]()
         switch self {
        case .api_exchangekey(let req):
//            params_task = formatDic(dic: req)
            params_task = req
            break
         case .api_face(let req):
            //            params_task = formatDic(dic: req)
            params_task = req
            break
         case .api_flutter(url: let url, req: let req):
            params_task = req
            break
        }
        return .requestParameters(parameters: params_task,
                                  encoding: JSONEncoding.default)
    }
    // 请求头信息
    public var headers: [String : String]? {
        return nil
    }
    // 接口请求类型
    public var method:Moya.Method{
        switch self {
        default:
            return .post
        }
    }
    //  单元测试用
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
}
