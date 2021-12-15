//
//  BaseViewController.swift
//  NexusRefresh_Example
//
//  Created by yupao_ios_macmini05 on 2021/12/7.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import NexusRefresh

// MARK: 测试VC
class TestVC: UIViewController {
    
    lazy var refreshBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.cornerRadius = 4
        btn.layer.borderWidth = 1
        btn.setTitle("刷新", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        
        NexusRefreshManager.add(self, tags: ["TestVC"]) { data in
            print("TestVC 刷新了")
        }
    }
    
    func makeUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(refreshBtn)
        refreshBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc func refresh() {
        NexusRefreshManager.refresh(tags: ["ViewController", "TestVC"])
    }
}
