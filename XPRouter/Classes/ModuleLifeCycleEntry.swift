//
//  ModuleLifeCycleEntry.swift
//  AKRouter
//
//  Created by shayuan on 2018/5/23.
//

import Foundation

/// 必须继承的Module入口
open class ModuleLifeCycleEntry: NSObject, ModuleLifeCycleProtocol {
    required public override init() {
        super.init()
    }
}

