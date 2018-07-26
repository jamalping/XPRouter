//
//  UINavigationControllerType.swift
//  AKRouter
//
//  Created by shayuan on 2018/5/23.
//

import UIKit

public protocol UINavigationControllerType {
    func pushViewController(_ viewController: UIViewController, animated: Bool)
}

public protocol UIViewControllerType {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}

extension UINavigationController: UINavigationControllerType {}
extension UIViewController: UIViewControllerType {}

