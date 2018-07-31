//
//  ModuleMediator.swift
//  XPRouter
//
//  Created by jamalping on 2018/5/23.
//

import Foundation

public final class ModuleMediator {
    
    public static let shared = ModuleMediator()
    
    fileprivate var modules: [ModuleLifeCycleProtocol] = []
    
    /// 手动注册的module做一层保护，以及方便去重
    fileprivate var selfRegisterModules: [String] = []
    
    public private(set) var context: ModuleContext = ModuleContext()
    
    private init() { }
    
    func registerAll(_ array: [String]) {
        selfRegisterModules = array
        
        self.modules = self.selfRegisterModules
            .compactMap{ NSClassFromString($0) as? ModuleLifeCycleEntry.Type }
            .map{ $0.init() }
        
    }
}

//MARK: ModuleMediatorType
extension ModuleMediator: ModuleMediatorType {
    
    public func load() {
        ModuleRegister.runOnce()
    }
    
    /// 注册一个继承自ModuleLifeCycleEntry的类，以获取App的生命周期
    ///
    /// - Parameter module: 继承自ModuleLifeCycleEntry的类，EG: ModuleA.self 
    public func register<S>(_ module: S.Type) where S : ModuleLifeCycleEntry {
        let strings = [module]
            .map{ String(reflecting: $0) }

        let array = strings
            .compactMap{ NSClassFromString($0) as? ModuleLifeCycleEntry.Type }
            .map{ $0.init() }
        
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        if let moduleEntry = array.first,
            let moduleName = strings.first {
            if !self.selfRegisterModules.contains(moduleName) {
                self.modules.append(moduleEntry)
                self.selfRegisterModules.append(moduleName)
            }
        }
        
    }
}

//MARK: ModuleLifeCycleDelegate
extension ModuleMediator: ModuleLifeCycleProtocol {

    public func initialize() {
        modules.forEach{ $0.initialize?() }
    }
    
    @discardableResult
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        return !modules
            .compactMap{
                $0.configure?(self.context)
                return $0.application?(application, didFinishLaunchingWithOptions: launchOptions)
            }
            .contains(false)
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        modules.forEach{ $0.applicationDidBecomeActive?(application) }
    }
    
    public func applicationWillResignActive(_ application: UIApplication) {
        modules.forEach{ $0.applicationWillResignActive?(application) }
    }
    
    public func applicationDidEnterBackground(_ application: UIApplication) {
        modules.forEach{ $0.applicationDidEnterBackground?(application) }
    }
    
    public func applicationWillEnterForeground(_ application: UIApplication) {
        modules.forEach{ $0.applicationWillEnterForeground?(application) }
    }
    
    public func applicationWillTerminate(_ application: UIApplication) {
        modules.forEach{ $0.applicationWillEnterForeground?(application) }
    }
    
    @available(iOS, introduced: 2.0, deprecated: 9.0, message: "Please use application:openURL:options:")
    @discardableResult
    public func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return !modules
            .compactMap{
                $0.application?(application, handleOpen: url)
            }
            .contains(false)
    }
    
    @available(iOS, introduced: 4.2, deprecated: 9.0, message: "Please use application:openURL:options:")
    @discardableResult
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return !modules
            .compactMap{
                $0.application?(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
            }
            .contains(false)
    }
    
    @available(iOS 9.0, *)
    @discardableResult
    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return !modules
            .compactMap{
                $0.application?(app, open: url, options: options)
            }
            .contains(false)
    }
    
    @available(iOS, introduced: 8.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenter requestAuthorizationWithOptions:completionHandler:]")
    public func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        modules.forEach{ $0.application?(application, didRegister: notificationSettings) }
    }
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        modules.forEach{ $0.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken) }
    }
    
    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        modules.forEach{ $0.application?(application, didFailToRegisterForRemoteNotificationsWithError: error) }
    }
    
    @available(iOS, introduced: 3.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:] for user visible notifications and -[UIApplicationDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:] for silent remote notifications")
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        modules.forEach{ $0.application?(application, didReceiveRemoteNotification: userInfo) }
    }
    
    @available(iOS, introduced: 4.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
    public func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        modules.forEach{ $0.application?(application, didReceive: notification) }
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void) {
        modules.forEach{ $0.application?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler) }
    }
    
    public func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void) {
        modules.forEach{ $0.application?(application, performFetchWithCompletionHandler: completionHandler) }
    }
    
    @available(iOS 9.0, *)
    public func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Swift.Void) {
        modules.forEach{ $0.application?(application, performActionFor: shortcutItem, completionHandler: completionHandler) }
    }
    
    public func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Swift.Void) {
        modules.forEach{ $0.application?(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler) }
    }
    
    @discardableResult
    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Swift.Void) -> Bool {
        return !modules
            .compactMap{
                $0.application?(application, continue: userActivity, restorationHandler: restorationHandler)
            }
            .contains(false)
    }
}
