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
class ViewController: UIViewController,FlutterBinaryMessenger {
    func send(onChannel channel: String, message: Data?) {
        print("send(onChannel channel: String, message: Data?) ")
    }
    
    func send(onChannel channel: String, message: Data?, binaryReply callback: FlutterBinaryReply? = nil) {
        print("send(onChannel channel: String, message: Data?, binaryReply callback: FlutterBinaryReply? = nil)")
    }
    
    func setMessageHandlerOnChannel(_ channel: String, binaryMessageHandler handler: FlutterBinaryMessageHandler? = nil) {
          print("setMessageHandlerOnChannel(_ channel: String, binaryMessageHandler handler: FlutterBinaryMessageHandler? = nil) ")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func clickToFlutterAction(_ sender: Any) {
//               guard let flutterEngine = (UIApplication.shared.delegate as? AppDelegate)?.flutterEngine else { return  }
//        let flutterViewController =
//                FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
//
////             self.pushVC(flutterViewController)
//        self.navigationController?.pushViewController(flutterViewController, animated: true)
        
        
        
//        [FlutterBoostPlugin open:@"first" urlParams:@{kPageCallBackId:@"MycallbackId#1"} exts:@{@"animated":@(YES)} onPageFinished:^(NSDictionary *result) {
//            NSLog(@"call me when page finished, and your result is:%@", result);
//        } completion:^(BOOL f) {
//            NSLog(@"page is opened");
//        }];
//        let controller = self.window?.rootViewController as! FlutterViewController
           let channel = FlutterMethodChannel.init(name: "https://www.oyear.cn", binaryMessenger: self)
           channel.setMethodCallHandler { (call, result) in
               if call.method == "callNativeMethond" {
                   let para = call.arguments
                   print(para!)
                   
                   result("我是原生返回数据")
               }else{
                   result(FlutterMethodNotImplemented)
               }
           }
           
        FlutterBoostPlugin.open("first", urlParams: ["key1": "Flutter打开Native"], exts: ["animated": true], onPageFinished: { (result) in
            print("call me when page finished, and your result is:", result)
        }) { (completion) in
            print("page is opened")
        }
    }
    
    
    
    
}

