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
    /// 单例
    public static let shared = NexusRefreshManager()

    private init() {}

    /// 可用刷新池
    var availableRefreshPool = NSMapTable<AnyObject, NexusRefreshObserverModel>(keyOptions: .weakMemory, valueOptions: .strongMemory)

    /// 等待刷新池
    var waitRefreshPool = NSMapTable<AnyObject, NexusRefreshObject>(keyOptions: .weakMemory, valueOptions: .strongMemory)

    // MARK: 添加刷新监听

    /// 添加刷新监听
    /// - Parameters:
    ///   - observer: 刷新目标
    ///   - tags: 标签列表
    ///   - refreshBlock: 刷新回调
    public static func add(_ observer: AnyObject, tags: Set<String>, refreshBlock: @escaping (_ data: Any?) -> Void) {
        let observerModel = NexusRefreshObserverModel(observer: observer, tags: tags, refreshBlock: refreshBlock)
        NexusRefreshManager.shared.availableRefreshPool.setObject(observerModel, forKey: observer)
        // 如果是VC进行特殊处理
        if let vc = observer as? UIViewController {
            // VC出现时再刷新
            vc.rx.viewDidAppear.subscribe(onNext: { [weak observer] _ in
                guard let observer = observer else { return }
                // 判断刷新池是否存在

                if let refreshObject = NexusRefreshManager.shared.waitRefreshPool.object(forKey: observer),
                   let observerModel = NexusRefreshManager.shared.availableRefreshPool.object(forKey: observer)
                {
                    // 刷新
                    observerModel.refreshBlock(refreshObject)
                    // 移除等待刷新池
                    NexusRefreshManager.shared.waitRefreshPool.removeObject(forKey: observer)
                }
            }).disposed(by: vc.rx.disposeBag)
        }
    }

    // MARK: 刷新

    /// 刷新
    /// - Parameters:
    ///   - tags: 标签列表
    ///   - data: 传递数据
    ///   - filtObjects: 过滤列表
    ///   - force: 强制刷新，会直接刷新，不会等待出现（仅对VC有用）
    public static func refresh(tags: Set<String>, data: Any? = nil, filtObjects: [AnyObject] = [], force: Bool = false) {
        // 遍历可刷新池
        NexusRefreshManager.shared.availableRefreshPool.objectEnumerator()?.forEach { object in
            // 判断是否可以刷新
            if let observerModel = object as? NexusRefreshObserverModel,
               tags.intersection(observerModel.tags).count > 0,
               !filtObjects.contains(where: { $0.isEqual(observerModel) })
            {
                let refreshObject = NexusRefreshObject(tags: tags, data: data)
                if !force, let vc = observerModel.observer as? UIViewController {
                    // 不可见VC加入等待刷新池；可见VC直接刷新。
                    if vc.isViewLoaded, vc.view.window != nil {
                        observerModel.refreshBlock(refreshObject)
                    } else {
                        NexusRefreshManager.shared.waitRefreshPool.setObject(refreshObject, forKey: observerModel.observer)
                    }
                } else {
                    // 不是VC直接刷新
                    observerModel.refreshBlock(refreshObject)
                }
            }
        }
    }
    
    // MARK: 移除监听
    
    /// 移除监听
    /// - Parameter observer: 观察者
    public static func remove(_ observer: AnyObject) {
        NexusRefreshManager.shared.availableRefreshPool.removeObject(forKey: observer)
        NexusRefreshManager.shared.waitRefreshPool.removeObject(forKey: observer)
    }
}

// MARK: 纽带刷新模型

class NexusRefreshObserverModel {
    /// 观察者
    weak var observer: AnyObject?

    /// 标签列表
    var tags: Set<String> = []

    /// 刷新回调
    var refreshBlock: (NexusRefreshObject) -> Void

    init(observer: AnyObject, tags: Set<String>, refreshBlock: @escaping (NexusRefreshObject) -> Void) {
        self.observer = observer
        self.tags = tags
        self.refreshBlock = refreshBlock
    }
}

// MARK: 纽带刷新等待数据模型

class NexusRefreshObject {
    /// 标签列表
    var tags: Set<String> = []
    
    /// 数据
    var data: Any?

    init(tags: Set<String>, data: Any?) {
        self.tags = tags
        self.data = data
    }
}
