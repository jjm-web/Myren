//
//  AppDelegate.swift
//  Myren
//
//  Created by 장준명 on 2022/08/11.
//

import UIKit
import Firebase
import GoogleMaps
import IQKeyboardManagerSwift
import GooglePlaces
import MapKit
import FirebaseAuth
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 0.6)
        //IQKeyboardManager.shared.enable = true
        // 구글지도 사용 키 - 운영
        GMSServices.provideAPIKey("AIzaSyAq_sEAc4iuxINE14PT74tktBA0Nw41YQ0")
        GMSPlacesClient.provideAPIKey("AIzaSyAq_sEAc4iuxINE14PT74tktBA0Nw41YQ0")
        GMSServices.provideAPIKey("AIzaSyAq_sEAc4iuxINE14PT74tktBA0Nw41YQ0")
        FirebaseApp.configure()
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.sound,.alert], completionHandler: { (granted,error) in })
        application.registerForRemoteNotifications()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]){ _, _ in
                    
        }
        
        application.registerForRemoteNotifications()
        
//        window = UIWindow(frame:UIScreen.main.bounds)
//        window?.makeKeyAndVisible()
//           
//        let rootViewcontroller = UINavigationController(rootViewController: CMMotionViewController())
//           
//        window?.rootViewController = rootViewcontroller
             
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass device token to auth
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
        // Further handling of the device token if needed by the app
        // ...
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification notification: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if Auth.auth().canHandleNotification(notification) {
            completionHandler(.noData)
            return
          }
    
    }
    
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        if Auth.auth().canHandle(url) {
           return true
         }
        return false

    }

    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}


 



