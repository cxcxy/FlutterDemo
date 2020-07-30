//
//  FlutterManager.swift
//  flutter-demo
//
//  Created by mac on 2020/7/30.
//  Copyright © 2020 mac-cx. All rights reserved.
//

import UIKit
import Flutter
import flutter_boost
extension UIView: NibLoadable {
}
protocol NibLoadable {
    
}
extension NibLoadable where Self: UIView {
    /**
     *   返回带有Xib的视图View
     */
    static func loadFromNib() -> Self{
        return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.first as! Self
    }
}
class FlutterManager: NSObject {
    static let share = FlutterManager()
    func addBillInfoAction()  {
        /// iOS端监听方法 一定要加上 _ = 这个前缀， 否则会报返回的接收错误， 因为 addEventListener 返回的是一个 void 的block
        _ = FlutterBoostPlugin.sharedInstance().addEventListener ( {[weak self] (str, params) in
            //            if str == "FlutterToNativeWithFlutterBoost" {
            //                let view = XBLoginOutView.loadFromNib()
            //                view.show()
            //                return
            //            }
            //            print("iOS接收到 Flutter boost 发来的消息",str,params)
            if let params = params as? [String: Any] {
                if let url = params["url"] as? String, let req = params["req"] as? [String: Any] {
                    self?.flutterBoostRequestMessage(url: url, req: req)
                }
                if let showView = params["showView"] as? Bool{
                    let view = XBLoginOutView.loadFromNib()
                    view.show()
                    return
                }
            }
            
            }, forName: "FlutterToNativeWithFlutterBoost")
    }
    func addShowToastAction() {
        /// iOS端监听方法 一定要加上 _ = 这个前缀， 否则会报返回的接收错误， 因为 addEventListener 返回的是一个 void 的block
        _ = FlutterBoostPlugin.sharedInstance().addEventListener ( {[weak self] (str, params) in
            let dic = ["message": "native消息"]
            //            FlutterBoostPlugin.sharedInstance().sendEvent("showToast", arguments: dic)
            let view = XBLoginOutView.loadFromNib()
            view.show()
            }, forName: "alert")
    }
    func flutterBoostRequestMessage(url: String, req: [String: Any])  {
        XBNetManager.shared.requestWithTarget(.api_flutter(url: url, req: req), successClosure: { (result, code, message) in
            if let dic = result as? [AnyHashable : Any] {
                FlutterBoostPlugin.sharedInstance().sendEvent(url, arguments: dic)
            }
        })
    }
    func addFlutterRequest(url: String, req: [String: Any], flutterResult: @escaping FlutterResult) {
        XBNetManager.shared.requestWithTarget(.api_flutter(url: url, req: req), successClosure: { (result, code, message) in
            if let dic = result as? [AnyHashable : Any] {
                //                FlutterBoostPlugin.sharedInstance().sendEvent("ToFlutterWithFlutterBoost", arguments: dic)
                flutterResult(dic)
            }
        })
    }
}
