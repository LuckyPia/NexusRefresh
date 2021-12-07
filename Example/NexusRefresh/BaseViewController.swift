//
//  BaseViewController.swift
//  NexusRefresh_Example
//
//  Created by yupao_ios_macmini05 on 2021/12/7.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import NexusRefresh

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NexusRefreshManager.add(self)
    }
}
