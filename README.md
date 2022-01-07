# NexusRefresh - iOS跨页面按需刷新

[![iOS Version](https://img.shields.io/badge/iOS-10.0%2B-blueviolet)](https://cocoapods.org/pods/NexusRefresh)
[![Language](https://img.shields.io/badge/swift-5.0-ff501e)](https://cocoapods.org/pods/NexusRefresh)
[![Version](https://img.shields.io/cocoapods/v/NexusRefresh.svg?style=flat)](https://cocoapods.org/pods/NexusRefresh)
[![License](https://img.shields.io/cocoapods/l/NexusRefresh.svg?style=flat)](https://cocoapods.org/pods/NexusRefresh)

## 背景
多页面数据关联，页面重新出现时都需要刷新，不需要刷新时也刷新，所以有很多无效请求。如果使用通知，通知是立即直接刷新，没有在页面出现时刷新，也有很多无效请求。如果当数据更改时，通知VC在出现时刷新，且只刷新一次，就好了。

## NexusRefresh介绍
专注为页面刷新设计。当页面被通知需要刷新时，页面出现时才刷新（只刷新一次），而不是通知一次刷新一次。可以给页面添加多个标签，当该标签需要刷新时，所有含有该标签的页面都可以刷新。

## 安装
```ruby
pod 'NexusRefresh', '2.0.4'
```

## 使用
1. 定义刷新标签
```swift
import NexusRefresh

// MARK: 刷新标签扩展
extension NexusRefreshManager.Tag {
  /// 首页
  static let Home = NexusRefreshManager.Tag("Home")
   
}
```

2. 监听刷新
```swift
class HomeViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    // 将自己加入可刷新池
    NexusRefreshManager.shared.add(self, tags: [.Home]) { object in
        // "tags: \(object.tags), data: \(object.data)"
        print("HomeViewController 刷新了")
    }
  }
}
```

3. 通知刷新
```swift
// 调用
NexusRefreshManager.shared.refresh(tags: [.Home])

/// 刷新方法详情
/// - Parameters:
///  - tags: 标签列表
///  - data: 传递数据
///  - filtObjects: 过滤列表
///  - force: 强制刷新，会直接刷新，不会等待出现（仅对VC有用）
public func refresh(tags: Set<Tag>, data: Any? = nil, filtObjects: [AnyObject] = [], force: Bool = false)
```

## Q&A
1. 可以刷新除`UIViewController`以外的对象么？
  可以，但是他们会在立即刷新，而不是出现时刷新

2. 什么时候刷新？
  `UIViewController`若不在顶层，出现时刷新，在顶层，立即刷新。
  非UIViewController立即刷新。
  
3. 同一个对象可以多次添加刷新通知吗？
  不可以，会以最后一次添加为准
  
4. 和`NotificationCenter`异同

- `NotificationCenter`在一个对象中可以有多个观察者。
`NexusRefreshManager`在一个对象中仅支持一个观察者。

- `NotificationCenter`观察一个NotificationName。
`NexusRefreshManager`可以观察多个Tag。

- `NotificationCenter`发送通知观察者立刻收到。
`NexusRefreshManager`如果不是强制刷新，未展示的UIViewController会在viewDidAppear时收到，且只会收到最后一次的通知。

- `NotificationCenter`可以接受数据，
`NexusRefreshManager`也可以接受数据。

   
## 更新日志
### 2.0.4
1. 降低RxSwift版本

### 2.0.3
1. 优化代码

### 2.0.2
1. 代码完善

### 2.0.1
1. 单例支持

### 2.0.0
1. 重构刷新管理器

### 1.0.2
1. UIViewController增加NexusRefreshDelegate默认实现

### 1.0.1
1. 增加错误提示
2. 更新文档

## Author

可以通过邮箱联系我： 664454335@qq.com

## License

NexusRefresh is available under the MIT license. See the LICENSE file for more info.
