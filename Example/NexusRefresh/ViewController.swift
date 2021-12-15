//
//  ViewController.swift
//  NexusRefresh
//
//  Created by LuckyPia on 12/03/2021.
//  Copyright (c) 2021 LuckyPia. All rights reserved.
//

import UIKit
import NexusRefresh
import SnapKit

class ViewController: UIViewController {
    
    lazy var toTestVCBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.cornerRadius = 4
        btn.layer.borderWidth = 1
        btn.setTitle("前往测试页面", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(toTestVC), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        
        NexusRefreshManager.shared.add(self, tags: ["ViewController"]) { data in
            print("ViewController 刷新了")
        }
        
    }
    
    func makeUI() {
        
        view.backgroundColor = .white
        view.addSubview(toTestVCBtn)
        toTestVCBtn.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc func toTestVC() {
        self.navigationController?.pushViewController(TestVC(), animated: true)
    }

}

