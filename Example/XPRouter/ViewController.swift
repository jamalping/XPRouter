//
//  ViewController.swift
//  XPRouter
//
//  Created by open . on 07/25/2018.
//  Copyright (c) 2018 open .. All rights reserved.
//

import UIKit
import XPRouter

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let module = ModuleContext.init()
        module.appKey = "key"
        print(XPRouterVersionNumber)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

