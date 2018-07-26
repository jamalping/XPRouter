//
//  URLPathComponentMatchResult.swift
//  AKRouter
//
//  Created by shayuan on 2018/5/23.
//

import Foundation

enum URLPathComponentMatchResult {
    case matches((key: String, value: Any)?)
    case notMatches
}
