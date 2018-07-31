//
//  URLFallBack.swift
//  XPRouter
//
//  Created by jamalping on 2018/5/23.
//

import Foundation

public protocol URLFallBackType: URLFallBackPluginType {
    func appendFallBack(_ url: URLPattern)
    func containsFallBack(_ url: URLPattern) -> Bool
}

public protocol URLFallBackPluginType {
    func handleFallBack(_ url: URLPattern)
}


public class URLFallBack: URLFallBackType {
   
    private var fallBackURLs: [URLPattern] = []
    
    private var plugins: [URLFallBackPluginType] = []
    
    public init(plugins: [URLFallBackPluginType]) {
        self.plugins = plugins
    }
    
    public func appendFallBack(_ url: URLPattern) {
        self.fallBackURLs.append(url)
    }
    
    public func containsFallBack(_ url: URLPattern) -> Bool {
        return fallBackURLs.contains(url)
    }
    
    public func handleFallBack(_ url: URLPattern) {
        plugins.forEach{ $0.handleFallBack(url) }
    }
}
