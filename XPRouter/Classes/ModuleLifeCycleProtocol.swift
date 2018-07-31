//
//  ModuleLifeCycleProtocol.swift
//  XPRouter
//
//  Created by jamalping on 2018/5/23.
//

import UIKit

@objc public protocol ModuleLifeCycleProtocol: ModuleCustomProtocol, ModuleLifeCycleDelegate {}


/// 自定义的配置功能
@objc public protocol ModuleCustomProtocol {
    @objc optional func configure(_ context: ModuleContext)
    
    /// 初始化方法
    @objc optional func initialize()
    
}

/// 与AppDelegate一致的代理api
@objc public protocol ModuleLifeCycleDelegate {
    
    @objc optional func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool
    
    @objc optional func applicationDidBecomeActive(_ application: UIApplication)
    
    @objc optional func applicationWillResignActive(_ application: UIApplication)
    
    @objc optional func applicationDidEnterBackground(_ application: UIApplication)
    
    @objc optional func applicationWillEnterForeground(_ application: UIApplication)
    
    @objc optional func applicationWillTerminate(_ application: UIApplication)
    
    @available(iOS, introduced: 2.0, deprecated: 9.0, message: "Please use application:openURL:options:")
    @objc optional func application(_ application: UIApplication, handleOpen url: URL) -> Bool
    
    @available(iOS, introduced: 4.2, deprecated: 9.0, message: "Please use application:openURL:options:")
    @objc optional func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    
    @available(iOS 9.0, *)
    @objc optional func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool
    
    @available(iOS, introduced: 8.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenter requestAuthorizationWithOptions:completionHandler:]")
    @objc optional func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings)
    
    @objc optional func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    
    @objc optional func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    
    @available(iOS, introduced: 3.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:] for user visible notifications and -[UIApplicationDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:] for silent remote notifications")
    @objc optional func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any])
    
    @available(iOS, introduced: 4.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
    @objc optional func application(_ application: UIApplication, didReceive notification: UILocalNotification)
    
    @available(iOS 7.0, *)
    @objc optional func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void)
    
    @available(iOS 7.0, *)
    @objc optional func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void)
    
    @available(iOS 9.0, *)
    @objc optional func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Swift.Void)
    
    @available(iOS 7.0, *)
    @objc optional func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Swift.Void)
    
    @available(iOS 8.0, *)
    @objc optional func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Swift.Void) -> Bool
    
}

