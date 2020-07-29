//
//  ViewController.swift
//  flutter-demo
//
//  Created by mac on 2020/7/9.
//  Copyright © 2020 mac-cx. All rights reserved.
//

import UIKit
import Flutter
import flutter_boost

//MARK:   延迟多少秒 回掉
struct XBDelay {
    static func start(delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
}
typealias CallBack = (_ name: String,_ params: [String: String]) -> ()
typealias NoneBack = () -> ()
class ViewController: UIViewController {
    
    var messageChannel:FlutterMethodChannel?
    override func viewDidLoad() {
        super.viewDidLoad()
        addBillInfoAction()
    }
    func addBillInfoAction()  {
        /// iOS端监听方法 一定要加上 _ = 这个前缀， 否则会报返回的接收错误， 因为 addEventListener 返回的是一个 void 的block
        _ = FlutterBoostPlugin.sharedInstance().addEventListener ( {[weak self] (str, params) in
            //            print("iOS接收到 Flutter boost 发来的消息",str,params)
            if let params = params as? [String: Any] {
                if let url = params["url"] as? String, let req = params["req"] as? [String: Any] {
                    self?.flutterBoostRequestMessage(url: url, req: req)
                }
                
            }
            }, forName: "FlutterToNativeWithFlutterBoost")
    }
    func addShowToastAction() {
        /// iOS端监听方法 一定要加上 _ = 这个前缀， 否则会报返回的接收错误， 因为 addEventListener 返回的是一个 void 的block
        _ = FlutterBoostPlugin.sharedInstance().addEventListener ( {[weak self] (str, params) in
            let dic = ["message": "native消息"]
            FlutterBoostPlugin.sharedInstance().sendEvent("showToast", arguments: dic)
            }, forName: "alert")
    }
    func flutterBoostRequestMessage(url: String, req: [String: Any])  {
        XBNetManager.shared.requestWithTarget(.api_flutter(url: url, req: req), successClosure: { (result, code, message) in
            if let dic = result as? [AnyHashable : Any] {
                FlutterBoostPlugin.sharedInstance().sendEvent("ToFlutterWithFlutterBoost", arguments: dic)
                //                flutterResult(dic)
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
    @IBAction func clickToFlutterAction(_ sender: Any) {
        
        //        let vc = FLBFlutterViewContainer.init();
        //        vc.setName("contentPage", params:  ["key1": "Flutter打开Native"]);
        //        // 使用 methodChannel 和 Dart 进行通信
        //        messageChannel = FlutterMethodChannel.init(name: "com.pages.your/native_get", binaryMessenger: vc.binaryMessenger)
        //        messageChannel?.setMethodCallHandler {[weak self] (call, result) in
        //            if call.method == "FlutterToNativeWithFlutterBoost" {
        //                print(call.arguments)
        //                if let params = call.arguments as? [String: Any] {
        //                    if let url = params["url"] as? String, let req = params["req"] as? [String: Any] {
        //                        self?.addFlutterRequest(url: url, req: req, flutterResult: result)
        //                    }
        //
        //                }
        //                //                        result("我是原生返回数据")
        //            }else{
        //                result(FlutterMethodNotImplemented)
        //            }
        //        }
        //        nativeToFlutter()
        FlutterBoostPlugin.open("BillProviderDemo", urlParams: ["key1": "Flutter打开Native"], exts: ["animated": true], onPageFinished: { (result) in
            print("call me when page finished, and your result is:", result)
        }) { (completion) in
            print("page is opened")
        }
    }
    /// native 向  flutter 传值
    func nativeToFlutter() {
        XBDelay.start(delay: 5) {
            // 使用Flutter 自带的 methodChannel 进行传值
            //            self.messageChannel?.invokeMethod("NativeToFlutter", arguments: "native向flutter传值")
            // 使用FlutterBoost 进行传值
            FlutterBoostPlugin.sharedInstance().sendEvent("ToFlutterWithFlutterBoost", arguments: ["key": "native向flutter传值"])
        }
    }
    
    
}
