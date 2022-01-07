//
//  NexusManager.swift
//  Demo
//
//  Created by yupao_ios_macmini05 on 2021/12/2.
//

import RxSwift
import RxCocoa
import UIKit

// MARK: 刷新管理器

public class NexusRefreshManager {
    /// 单例
    public static let shared = NexusRefreshManager()

    private init() {}

    /// 可用刷新池
    private var availableRefreshPool = NSMapTable<AnyObject, Observer>(keyOptions: .weakMemory, valueOptions: .strongMemory)

    /// 等待刷新池
    private var waitRefreshPool = NSHashTable<AnyObject>.init(options: .weakMemory)

    // MARK: 添加刷新监听

    /// 添加刷新监听
    /// - Parameters:
    ///   - target: 刷新目标
    ///   - tags: 标签列表
    ///   - refreshBlock: 刷新回调
    public func add(_ target: AnyObject, tags: Set<Tag>, refreshBlock: @escaping () -> Void) {
        let observerModel = Observer(target: target, tags: tags, refreshBlock: refreshBlock)
        NexusRefreshManager.shared.availableRefreshPool.setObject(observerModel, forKey: target)
        // 如果是VC进行特殊处理
        if let vc = target as? UIViewController {
            // VC出现时再刷新
            vc.rx.nr_viewDidAppear.subscribe(onNext: { [weak target] _ in
                guard let target = target else { return }
                // 判断刷新池是否存在
                
                if NexusRefreshManager.shared.waitRefreshPool.contains(target),
                   let observerModel = NexusRefreshManager.shared.availableRefreshPool.object(forKey: target)
                {
                    // 刷新
                    observerModel.refreshBlock()
                    // 移除等待刷新池
                    NexusRefreshManager.shared.waitRefreshPool.remove(observerModel.target)
                }
            }).disposed(by: vc.rx.nr_disposeBag)
        }
    }

    // MARK: 刷新

    /// 刷新
    /// - Parameters:
    ///   - tags: 标签列表
    ///   - filtObjects: 过滤列表
    ///   - force: 强制刷新，会直接刷新，不会等待出现（仅对VC有用）
    public func refresh(tags: Set<Tag>, filtObjects: [AnyObject] = [], force: Bool = false) {
        // 遍历可刷新池
        NexusRefreshManager.shared.availableRefreshPool.objectEnumerator()?.forEach { object in
            // 判断是否可以刷新
            if let observerModel = object as? Observer,
               tags.intersection(observerModel.tags).count > 0,
               !filtObjects.contains(where: { $0.isEqual(observerModel) })
            {
                if !force, let vc = observerModel.target as? UIViewController {
                    // 不可见VC加入等待刷新池；可见VC直接刷新。
                    if vc.isViewLoaded, vc.view.window != nil {
                        observerModel.refreshBlock()
                    } else {
                        NexusRefreshManager.shared.waitRefreshPool.add(observerModel.target)
                    }
                } else {
                    // 不是VC直接刷新
                    observerModel.refreshBlock()
                }
            }
        }
    }
    
    // MARK: 移除监听
    
    /// 移除监听
    /// - Parameter target: 观察者
    public func remove(_ target: AnyObject) {
        NexusRefreshManager.shared.availableRefreshPool.removeObject(forKey: target)
        NexusRefreshManager.shared.waitRefreshPool.remove(target)
    }
    
}

// MARK: 刷新管理器扩展
extension NexusRefreshManager {
    
    // MARK: 标签
    public struct Tag: Hashable, Equatable, RawRepresentable {
        public var rawValue: String

        public init(_ rawValue: String) {
            self.rawValue = rawValue
        }

        public init(rawValue: String) {
            self.rawValue = rawValue
        }
    }
    
    // MARK: 纽带观察模型

    class Observer {
        /// 观察者
        weak var target: AnyObject?

        /// 标签列表
        var tags: Set<Tag> = []

        /// 刷新回调
        var refreshBlock: () -> Void

        init(target: AnyObject, tags: Set<Tag>, refreshBlock: @escaping () -> Void) {
            self.target = target
            self.tags = tags
            self.refreshBlock = refreshBlock
        }
    }

    // MARK: 纽带刷新数据模型

    public class Object {
        /// 标签列表
        public var tags: Set<Tag> = []
        
        /// 数据
        public var data: Any?

        init(tags: Set<Tag>, data: Any?) {
            self.tags = tags
            self.data = data
        }
    }
}

// MARK: UIViewController扩展
public extension Reactive where Base: UIViewController {
    /// UIViewController将要出现
    var nr_viewDidAppear: ControlEvent<Bool> {
        let source = self.methodInvoked(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
        return ControlEvent(events: source)
    }
}

// MARK: DisposeBag扩展
fileprivate var nr_disposeBagContext: UInt8 = 0

extension Reactive where Base: AnyObject {
    func nr_synchronizedBag<T>( _ action: () -> T) -> T {
        objc_sync_enter(self.base)
        let result = action()
        objc_sync_exit(self.base)
        return result
    }
}

extension Reactive where Base: AnyObject {

    /// a unique DisposeBag that is related to the Reactive.Base instance only for Reference type
    var nr_disposeBag: DisposeBag {
        get {
            return nr_synchronizedBag {
                if let disposeObject = objc_getAssociatedObject(base, &nr_disposeBagContext) as? DisposeBag {
                    return disposeObject
                }
                let disposeObject = DisposeBag()
                objc_setAssociatedObject(base, &nr_disposeBagContext, disposeObject, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return disposeObject
            }
        }
        
        set {
            nr_synchronizedBag {
                objc_setAssociatedObject(base, &nr_disposeBagContext, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}

