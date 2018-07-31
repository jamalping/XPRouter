//
//  ModuleRegister.swift
//  XPRouter
//
//  Created by jamalping on 2018/5/23.
//

import Foundation


private let mapName = "ModuleMap"

public final class ModuleRegister: NSObject {
    
    @objc public class func runOnce() {
        
        if let filePath = Bundle.main.path(forResource: mapName, ofType: "plist"),
            let moduleNames = NSArray(contentsOfFile: filePath) as? [String] {
            ModuleMediator.shared.registerAll(moduleNames)
        } else {
            print("""
                🙈🙈🙈================🐞🐞🐞🐞🐞🐞===================🙈🙈🙈

                oops, it seems you don't have the \(mapName).plist file, 😂😂😂
                check out whether you have dragged this file to your project or not.
                You loser! 🙄🙄🙄

                """)
        }   
    }
}

