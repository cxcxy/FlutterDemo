//
//  AppDelegate.swift
//  flutter-demo
//
//  Created by mac on 2020/7/9.
//  Copyright © 2020 mac-cx. All rights reserved.
//

import UIKit
import CoreData
import Flutter
import flutter_boost
// Used to connect plugins (only if you have plugins with iOS platform code).
import FlutterPluginRegistrant
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var flutterEngine : FlutterEngine?;
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.flutterEngine = FlutterEngine(name: "io.flutter", project: nil);
                      
        self.flutterEngine?.run(withEntrypoint: nil);
                      
        GeneratedPluginRegistrant.register(with: self.flutterEngine as! FlutterEngine);
        
//        PlatformRouterImp *router = [PlatformRouterImp new];
//         [FlutterBoostPlugin.sharedInstance startFlutterWithPlatform:router
//                                                             onStart:^(FlutterEngine *engine) {
//
//                                                             }];
//         UITabBarController *tabVC = [[UITabBarController alloc] init];
//         UINavigationController *rvc = [[UINavigationController alloc] initWithRootViewController:tabVC];
//         router.navigationController = rvc;
        let router = PlatformRouterImp.init()
        FlutterBoostPlugin.sharedInstance().startFlutter(with: router) { (engine) in
            print("engine",engine)
        }
        
        
//        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController;
//        let batteryChannel = FlutterMethodChannel.init(name: "samples.flutter.io/battery",
//                                                       binaryMessenger: controller);
//        batteryChannel.setMethodCallHandler({
//          (call: FlutterMethodCall, result: FlutterResult) -> Void in
//          // Handle battery messages.
//        });

//           GeneratedPluginRegistrant.register(with: self)
        
        return true
    }


    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "flutter_demo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

