//
//  ViewController.swift
//  NexusRefresh
//
//  Created by LuckyPia on 12/03/2021.
//  Copyright (c) 2021 LuckyPia. All rights reserved.
//

import UIKit
import NexusRefresh

class ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            NexusRefreshManager.refresh(tags: [ViewController.defaultNexusTag])
        }
        
    }
    
    override func nexusRefresh(data: Any?) {
        print("ViewController nexusRefreshed!")
    }

}

