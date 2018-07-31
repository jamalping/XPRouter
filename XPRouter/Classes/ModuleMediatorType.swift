//
//  ModuleMediatorType.swift
//  XPRouter
//
//  Created by jamalping on 2018/5/23.
//

import Foundation

public protocol ModuleMediatorType {
    
    /// 注册一个继承自ModuleLifeCycleEntry的类，以获取App的生命周期
    ///
    /// - Parameter module: 继承自ModuleLifeCycleEntry的类，EG: ModuleA.self 
    func register<S>(_ module: S.Type) where S: ModuleLifeCycleEntry
}
