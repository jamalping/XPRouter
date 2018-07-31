//
//  URLRouterType.swift
//  XPRouter
//
//  Created by jamalping on 2018/5/23.
//

import UIKit

public typealias URLPattern = String
public typealias ViewControllerFactory = (_ url: URLConvertible, _ values: [String: Any], _ context: Any?) -> UIViewController?
public typealias URLOpenHandlerFactory = (_ url: URLConvertible, _ values: [String: Any], _ context: Any?) -> Bool
public typealias URLOpenHandler = () -> Bool

public protocol URLRouterType {
    var matcher: URLMatcher { get }
    weak var delegate: URLRouterDelegate? { get set }
    
    /// 给URL模式注册一个返回ViewController的处理闭包.
    func register(_ pattern: URLPattern, _ factory: @escaping ViewControllerFactory)
    
    /// 给URL模式注册一个处理方式闭包.
    func handle(_ pattern: URLPattern, _ factory: @escaping URLOpenHandlerFactory)
    
    /// 根据确定的URL返回一个ViewController.
    ///
    /// - parameter url: 需要匹配ViewController的URL.
    ///
    /// - returns: 匹配到URL的ViewController，没匹配到返回nil.
    func viewController(for url: URLConvertible, context: Any?) -> UIViewController?
    
    /// 根据确定的URL返回一个处理URL的闭包.
    ///
    /// - parameter url: 需要匹配URL处理闭包的URL.
    ///
    /// - returns: 匹配到URL的处理闭包，没匹配到返回nil.
    func handler(for url: URLConvertible, context: Any?) -> URLOpenHandler?
    
    /// 根据URL推一个ViewController.
    ///
    /// - note: 不建议使用，仅做mocking时候用
    @discardableResult
    func pushURL(_ url: URLConvertible, context: Any?, from: UINavigationControllerType?, animated: Bool) -> UIViewController?
    
    /// 推一个ViewController.
    ///
    /// - note: 不建议使用，仅做mocking时候用
    @discardableResult
    func pushViewController(_ viewController: UIViewController, from: UINavigationControllerType?, animated: Bool) -> UIViewController?
    
    /// 根据URL Presents一个ViewController.
    ///
    /// - note: 不建议使用，仅做mocking时候用
    @discardableResult
    func presentURL(_ url: URLConvertible, context: Any?, wrap: UINavigationController.Type?, from: UIViewControllerType?, animated: Bool, completion: (() -> Void)?) -> UIViewController?
    
    /// Presents一个ViewController.
    ///
    /// - note: 不建议使用，仅做mocking时候用
    @discardableResult
    func presentViewController(_ viewController: UIViewController, wrap: UINavigationController.Type?, from: UIViewControllerType?, animated: Bool, completion: (() -> Void)?) -> UIViewController?
    
    /// 执行一个 URL 处理闭包.
    ///
    /// - note: 不建议使用，仅做mocking时候用
    @discardableResult
    func openURL(_ url: URLConvertible, context: Any?) -> Bool
}


// MARK: - 实现

extension URLRouterType {
    public func viewController(for url: URLConvertible) -> UIViewController? {
        return self.viewController(for: url, context: nil)
    }
    
    public func handler(for url: URLConvertible) -> URLOpenHandler? {
        return self.handler(for: url, context: nil)
    }
    
    @discardableResult
    public func pushURL(_ url: URLConvertible, context: Any? = nil, from: UINavigationControllerType? = nil, animated: Bool = true) -> UIViewController? {
        guard let viewController = self.viewController(for: url, context: context) else { return nil }
        return self.pushViewController(viewController, from: from, animated: animated)
    }
    
    @discardableResult
    public func pushViewController(_ viewController: UIViewController, from: UINavigationControllerType?, animated: Bool) -> UIViewController? {
        guard (viewController is UINavigationController) == false else { return nil }
        guard let navigationController = from ?? UIViewController.topMost?.navigationController else { return nil }
        guard self.delegate?.shouldPush(viewController: viewController, from: navigationController) != false else { return nil }
        navigationController.pushViewController(viewController, animated: animated)
        return viewController
    }
    
    @discardableResult
    public func presentURL(_ url: URLConvertible, context: Any? = nil, wrap: UINavigationController.Type? = nil, from: UIViewControllerType? = nil, animated: Bool = true, completion: (() -> Void)? = nil) -> UIViewController? {
        guard let viewController = self.viewController(for: url, context: context) else { return nil }
        return self.presentViewController(viewController, wrap: wrap, from: from, animated: animated, completion: completion)
    }
    
    @discardableResult
    public func presentViewController(_ viewController: UIViewController, wrap: UINavigationController.Type?, from: UIViewControllerType?, animated: Bool, completion: (() -> Void)?) -> UIViewController? {
        guard let fromViewController = from ?? UIViewController.topMost else { return nil }
        
        let viewControllerToPresent: UIViewController
        if let navigationControllerClass = wrap, (viewController is UINavigationController) == false {
            viewControllerToPresent = navigationControllerClass.init(rootViewController: viewController)
        } else {
            viewControllerToPresent = viewController
        }
        
        guard self.delegate?.shouldPresent(viewController: viewController, from: fromViewController) != false else { return nil }
        fromViewController.present(viewControllerToPresent, animated: animated, completion: completion)
        return viewController
    }
    
    @discardableResult
    public func openURL(_ url: URLConvertible, context: Any?) -> Bool {
        guard let handler = self.handler(for: url, context: context) else { return false }
        return handler()
    }
}


