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

class ViewController: UIViewController {

    var messageChannel:FlutterMethodChannel?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickToFlutterAction(_ sender: Any) {
        
        let vc = FLBFlutterViewContainer.init();
        vc.setName("first", params:  ["key1": "Flutter打开Native"]);
        // 使用 methodChannel 和 Dart 进行通信
        messageChannel = FlutterMethodChannel.init(name: "com.pages.your/native_get", binaryMessenger: vc.binaryMessenger)
        messageChannel?.setMethodCallHandler { (call, result) in
            print("回调啊",call,result)
            if call.method == "FlutterToNative" {
//                let para = call.arguments
                print(call.arguments)
                
                result("我是原生返回数据")
            }else{
                result(FlutterMethodNotImplemented)
            }
        }
        nativeToFlutter()
        FlutterBoostPlugin.open("first", urlParams: ["key1": "Flutter打开Native"], exts: ["animated": true], onPageFinished: { (result) in
            print("call me when page finished, and your result is:", result)
        }) { (completion) in
            print("page is opened")
        }
        
//        FlutterBoostPlugin.sharedInstance().sendEvent(<#T##eventName: String##String#>, arguments: T##[AnyHashable : Any])
        
//        FlutterBoostPlugin.sharedInstance().addEventListener({ (str, params) in
//
//        }, forName: "FlutterBoostChannel")
        

    }
    /// native 向  flutter 传值
    func nativeToFlutter() {
        XBDelay.start(delay: 5) {
            self.messageChannel?.invokeMethod("NativeToFlutter", arguments: "native向flutter传值")
        }
    }
    
    
}
