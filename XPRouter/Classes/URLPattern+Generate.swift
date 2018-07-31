//
//  URLPattern+Generate.swift
//  XPRouter
//
//  Created by jamalping on 2018/5/24.
//

import Foundation

public enum URLParamType {
    case string(String)
}

extension URLPattern {
    /// 便捷URL配置，支持2种形式
    /// 如果params 是[String: Any]类型且个数为 1，那么生成的URL是Get形式的
    /// 如果params 是 string, int, float, double, path, uuid类型的数组，会替换尖括号内的占位符 
    public func generate(_ params: Any...) -> String {
        
        if let dict = params.first as? [String: Any] {
            return generateGet(dict)
        }
        
        let components = self.components(separatedBy: "/")
        var indexOfParams = 0
        var container: [String] = []
        
        for component in components {
            if component.hasPrefix("<") && component.hasSuffix(">") {
                if indexOfParams < params.count {
                    let param = params[indexOfParams]
                    guard param is String
                        || param is Int
                        || param is Float
                        || param is Double
                        || param is UUID
                    else {
                        print("❌❌❌ param: ", param, "的当前类型不支持❌❌❌")
                        return self
                    }
                    
                    container.append(String(describing: param))
                    indexOfParams += 1
                } else {
                    print("❌❌❌ 生成url时的params数组越界 ❌❌❌")
                }
            } else {
                container.append(component)
            }
        }
        
        return container.joined(separator: "/")
    }
    
    // GET类型请求的配置
    func generateGet(_ params: [String: Any]) -> String {
        return self + "?" + params.map{ $0 + "=" + String(describing: $1) }.joined(separator: "&")
    }
}
