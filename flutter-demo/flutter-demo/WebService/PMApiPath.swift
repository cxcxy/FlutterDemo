//
//  PMApiPath.swift
//  XBPMDev
//
//  Created by mac on 2018/3/28.
//  Copyright © 2018年 mac-cx. All rights reserved.
//
import Foundation
/****************************API_URL接口**********************************/
extension RequestApi {
    // api 地址
    public var path:String{
        switch self {
        case .api_exchangekey:          return "public/exchangekey"
        case .api_face: return "aipface/adduser"
            
        case .api_flutter(let url,_ ): return url
        default:
            return ""
        }
    }
}


