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
        // Do any additional setup after loading the view.
        
//        _ =  FlutterBoostPlugin.sharedInstance().addEventListener({ (name, params) in
//
//        }, forName: "22")
//     _ =  self.addTest(listener: { (name, params) in
//
//        }, forName: "22")
    }
//    func addTest(listener: CallBack,forName: String) -> NoneBack {
//
//    }
    @IBAction func clickToFlutterAction(_ sender: Any) {
        
        let vc = FLBFlutterViewContainer.init();
        vc.setName("billInfo", params:  ["key1": "Flutter打开Native"]);
        // 使用 methodChannel 和 Dart 进行通信
        messageChannel = FlutterMethodChannel.init(name: "com.pages.your/native_get", binaryMessenger: vc.binaryMessenger)
        messageChannel?.setMethodCallHandler { (call, result) in
            print("回调啊",call,result)
            if call.method == "FlutterToNative" {
//                let para = call.arguments
                print(call.arguments)
//                let vc = TwoViewController ()
//                self.navigationController?.pushViewController(vc, animated: true)
                result("我是原生返回数据")
            }else{
                result(FlutterMethodNotImplemented)
            }
        }
        nativeToFlutter()
        FlutterBoostPlugin.open("billInfo", urlParams: ["key1": "Flutter打开Native"], exts: ["animated": true], onPageFinished: { (result) in
            print("call me when page finished, and your result is:", result)
        }) { (completion) in
            print("page is opened")
        }
        

        
        
        /// iOS端监听方法 一定要加上 _ = 这个前缀， 否则会报返回的接收错误， 因为 addEventListener 返回的是一个 void 的block
        _ = FlutterBoostPlugin.sharedInstance().addEventListener ( { (str, params) in
            print("iOS接收到 Flutter boost 发来的消息",str,params)

        }, forName: "FlutterToNativeWithFlutterBoost")

        
        
   
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
