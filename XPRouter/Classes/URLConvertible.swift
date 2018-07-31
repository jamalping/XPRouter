//
//  URLConvertible.swift
//  XPRouter
//
//  Created by jamalping on 2018/5/23.
//

import Foundation

/// url的便利类型
public protocol URLConvertible {
    var urlValue: URL? { get }
    var urlStringValue: String { get }
    
    /// 返回URL的查询参数，便利起见不会返回nil而是返回[].
    /// 如需查看重复的keys，请使用 `queryItems`
    ///
    /// - seealso: `queryItems`
    var queryParameters: [String: String] { get }
    
    /// 返回URLComponents实例的queryItems属性
    ///
    /// - seealso: `queryParameters`
    @available(iOS 8, *)
    var queryItems: [URLQueryItem]? { get }
}

extension URLConvertible {
    public var queryParameters: [String: String] {
        var parameters = [String: String]()
        self.urlValue?.query?.components(separatedBy: "&").forEach {
            let keyAndValue = $0.components(separatedBy: "=")
            if keyAndValue.count == 2 {
                let key = keyAndValue[0]
                let value = keyAndValue[1].removingPercentEncoding ?? keyAndValue[1]
                parameters[key] = value
            }
        }
        return parameters
    }
    
    @available(iOS 8, *)
    public var queryItems: [URLQueryItem]? {
        return URLComponents(string: self.urlStringValue)?.queryItems
    }
}

extension String: URLConvertible {
    public var urlValue: URL? {
        if let url = URL(string: self) {
            return url
        }
        var set = CharacterSet()
        set.formUnion(.urlHostAllowed)
        set.formUnion(.urlPathAllowed)
        set.formUnion(.urlQueryAllowed)
        set.formUnion(.urlFragmentAllowed)
        return self.addingPercentEncoding(withAllowedCharacters: set).flatMap { URL(string: $0) }
    }
    
    public var urlStringValue: String {
        return self
    }
}

extension URL: URLConvertible {
    public var urlValue: URL? {
        return self
    }
    
    public var urlStringValue: String {
        return self.absoluteString
    }
}

