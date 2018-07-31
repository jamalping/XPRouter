//
//  URLMatchResult.swift
//  XPRouter
//
//  Created by jamalping on 2018/5/23.
//

import Foundation

///  URL 匹配.
public struct URLMatchResult {
    /// 匹配到的URL模式.
    public let pattern: String
    
    /// URL模式中占位符与实际url中的value 一一对应的字典
    public let values: [String: Any]
}
