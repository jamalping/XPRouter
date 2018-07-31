//
//  URLRouter.swift
//  AKURLRouter
//
//  Created by jamalping on 2018/5/23.
//
import UIKit

public let Router = URLRouter.shared

open class URLRouter: URLRouterType {
    
    public static let shared = URLRouter()
    
    open let matcher = URLMatcher()
    open weak var delegate: URLRouterDelegate?
    
    private var viewControllerFactories = [URLPattern: ViewControllerFactory]()
    private var handlerFactories = [URLPattern: URLOpenHandlerFactory]()
    
    open var fallBack: URLFallBackType = URLFallBack(plugins: [])
    
    private init() { }
    
    /// 给URL模式注册一个返回ViewController的处理闭包.
    open func register(_ pattern: URLPattern, _ factory: @escaping ViewControllerFactory) {
        self.viewControllerFactories[pattern] = factory
    }
    
    /// 给URL模式注册一个处理方式闭包.
    open func handle(_ pattern: URLPattern, _ factory: @escaping URLOpenHandlerFactory) {
        self.handlerFactories[pattern] = factory
    }
    
    
    /// 根据URL返回UIViewController
    ///
    /// - Parameters:
    ///   - url: 具体的url
    ///   - context: 传入的上下文内容
    /// - Returns: UIViewController
    open func viewController(for url: URLConvertible, context: Any? = nil) -> UIViewController? {
        let urlPatterns = Array(self.viewControllerFactories.keys)
        guard let match = self.matcher.match(url, from: urlPatterns) else { return nil }
        guard !self.fallBack.containsFallBack(match.pattern) else {
            self.fallBack.handleFallBack(match.pattern)
            return nil
        }
        guard let factory = self.viewControllerFactories[match.pattern] else { return nil }
        return factory(url, match.values, context)
    }
    
    /// 根据URL返回URLOpenHandler
    ///
    /// - Parameters:
    ///   - url: 具体的url
    ///   - context: 传入的上下文内容
    /// - Returns: URLOpenHandler
    open func handler(for url: URLConvertible, context: Any?) -> URLOpenHandler? {
        let urlPatterns = Array(self.handlerFactories.keys)
        guard let match = self.matcher.match(url, from: urlPatterns) else { return nil }
        guard !self.fallBack.containsFallBack(match.pattern) else {
            self.fallBack.handleFallBack(match.pattern)
            return nil
        }
        guard let handler = self.handlerFactories[match.pattern] else { return nil }
        return { handler(url, match.values, context) }
    }
}

// MARK: - 调用的方法
extension URLRouter {
    
    /// 根据url push一个UIViewController
    ///
    /// - Parameters:
    ///   - url: 具体的url
    ///   - context: 传入的上下文
    ///   - from: UINavigationController的类型，可自定义
    ///   - animated: 是否有动画
    /// - Returns: 是否有符合url的UIViewController
    @discardableResult
    public func push(_ url: URLConvertible, context: Any? = nil, from: UINavigationControllerType? = nil, animated: Bool = true) -> UIViewController? {
        return self.pushURL(url, context: context, from: from, animated: animated)
    }
    
    /// push一个UIViewController
    ///
    /// - Parameters:
    ///   - viewController: 被push的viewController
    ///   - context: 传入的上下文
    ///   - from: UINavigationController的类型，可自定义
    ///   - animated: 是否有动画
    /// - Returns: 是否有符合url的UIViewController
    @discardableResult
    public func push(_ viewController: UIViewController, from: UINavigationControllerType? = nil, animated: Bool = true) -> UIViewController? {
        return self.pushViewController(viewController, from: from, animated: animated)
    }
    
    /// 根据url present一个UIViewController
    ///
    /// - Parameters:
    ///   - url: 具体的url
    ///   - context: 传入的上下文
    ///   - wrap: 是否需要包裹UINavigationController
    ///   - from: UIViewController的类型，可自定义
    ///   - animated: 是否有动画
    ///   - completion: 完成的回调
    /// - Returns: 是否有符合url的UIViewController
    @discardableResult
    public func present(_ url: URLConvertible, context: Any? = nil, wrap: UINavigationController.Type? = nil, from: UIViewControllerType? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> UIViewController? {
        return self.presentURL(url, context: context, wrap: wrap, from: from, animated: animated, completion: completion)
    }
    
    /// present一个UIViewController
    ///
    /// - Parameters:
    ///   - viewController: 被present的viewController
    ///   - context: 传入的上下文
    ///   - wrap: 是否需要包裹UINavigationController
    ///   - from: UIViewController的类型，可自定义
    ///   - animated: 是否有动画
    ///   - completion: 完成的回调
    /// - Returns: 是否有符合url的UIViewController
    @discardableResult
    public func present(_ viewController: UIViewController, wrap: UINavigationController.Type? = nil, from: UIViewControllerType? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> UIViewController? {
        return self.presentViewController(viewController, wrap: wrap, from: from, animated: animated, completion: completion)
    }
    
    /// 打开一个url，调用handle方法
    ///
    /// - Parameters:
    ///   - url: 具体的url
    ///   - context: 传入的上下文
    /// - Returns: 是否执行
    @discardableResult
    public func open(_ url: URLConvertible, context: Any? = nil) -> Bool {
        return self.openURL(url, context: context)
    }
}

