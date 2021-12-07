//
//  NexusManager.swift
//  Demo
//
//  Created by yupao_ios_macmini05 on 2021/12/2.
//

import NSObject_Rx
import RxViewController
import UIKit

// MARK: 纽带刷新管理器

public class NexusRefreshManager {
    private init() {}

    /// 可用刷新池
    public static var availableRefreshPool = NSHashTable<AnyObject>(options: .weakMemory)

    /// 等待刷新池
    static var waitRefreshPool = NSMapTable<AnyObject, NexusRefreshObject>(keyOptions: .weakMemory, valueOptions: .strongMemory)

    /// 添加到可用刷新池
    public static func add(_ obj: AnyObject) {
        if let dele = obj as? NexusRefreshDelegate {
            // 添加到可刷新列表
            NexusRefreshManager.availableRefreshPool.add(obj)

            if let vc = obj as? UIViewController {
                // 监听VC出现
                vc.rx.viewDidAppear.subscribe(onNext: { [weak dele] _ in
                    guard let `dele` = dele else { return }
                    // 判断刷新池是否存在

                    if let fromObj = NexusRefreshManager.waitRefreshPool.object(forKey: dele) {
                        // 刷新
                        dele.nexusRefresh(data: fromObj.data)
                        // 移除刷新池
                        NexusRefreshManager.waitRefreshPool.removeObject(forKey: dele)
                    }
                }).disposed(by: vc.rx.disposeBag)
            }
        }else {
            fatalError("AnyObject must implement NexusRefreshDelegate protocol!")
        }
    }

    /// 刷新
    /// - Parameters:
    ///   - tags: 标签列表
    ///   - data: 传递数据
    ///   - filtObjects: 过滤列表
    public static func refresh(tags: Set<String>, data: Any? = nil, filtObjects: [AnyObject] = []) {
        let list = NexusRefreshManager.availableRefreshPool.allObjects
        for obj in list {
            if let dele = obj as? NexusRefreshDelegate,
               dele.nexusTags().intersection(tags).count > 0,
               !filtObjects.contains(where: { $0.isEqual(obj) })
            {
                if let vc = obj as? UIViewController {
                    // 不可见VC加入等待刷新池，可见VC直接刷新。
                    if vc.isViewLoaded, vc.view.window != nil {
                        dele.nexusRefresh(data: data)
                    } else {
                        NexusRefreshManager.waitRefreshPool.setObject(NexusRefreshObject(data: data), forKey: obj)
                    }
                } else {
                    // 直接刷新
                    dele.nexusRefresh(data: data)
                }
            }
        }
    }
}

// MARK: 纽带刷新协议

@objc public protocol NexusRefreshDelegate {
    /// 纽带标签列表
    func nexusTags() -> Set<String>

    /// 刷新
    func nexusRefresh(data: Any?)
}

// MARK: 纽带刷新数据

class NexusRefreshObject {
    /// 数据
    var data: Any?

    init(data: Any?) {
        self.data = data
    }
}

// MARK: UIViewController扩展 - NexusRefreshDelegate默认实现

extension UIViewController: NexusRefreshDelegate {
    open func nexusTags() -> Set<String> {
        return [defaultNexusTag]
    }
    
    open func nexusRefresh(data: Any?) {
        // 刷新
    }
}

// MARK: NSObject扩展 - 获取默认标签

public extension NSObject {
    /// 默认标签
    var defaultNexusTag: String {
        // 返回当前类的名称
        return String(describing: type(of: self))
    }
    
    /// 静态获取默认标签
    static var defaultNexusTag: String {
        // 返回当前类的名称
        return "\(self)".components(separatedBy: ".").first!
    }
}
