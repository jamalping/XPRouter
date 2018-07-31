//
//  RouterDelegate.swift
//  XPRouter
//
//  Created by jamalping on 2018/5/23.
//
import UIKit

public protocol URLRouterDelegate: class {
    /// 返回router是否应该push这个viewController,默认返回true
    func shouldPush(viewController: UIViewController, from: UINavigationControllerType) -> Bool
    
    /// 返回router是否应该present这个viewController,默认返回true
    func shouldPresent(viewController: UIViewController, from: UIViewControllerType) -> Bool
}

extension URLRouterDelegate {
    public func shouldPush(viewController: UIViewController, from: UINavigationControllerType) -> Bool {
        return true
    }
    
    public func shouldPresent(viewController: UIViewController, from: UIViewControllerType) -> Bool {
        return true
    }
}

