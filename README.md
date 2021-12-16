# NexusRefresh - iOS跨页面按需刷新

[![iOS Version](https://img.shields.io/badge/iOS-10.0%2B-blueviolet)](https://cocoapods.org/pods/NexusRefresh)
[![Language](https://img.shields.io/badge/swift-5.0-ff501e)](https://cocoapods.org/pods/NexusRefresh)
[![Version](https://img.shields.io/cocoapods/v/NexusRefresh.svg?style=flat)](https://cocoapods.org/pods/NexusRefresh)
[![License](https://img.shields.io/cocoapods/l/NexusRefresh.svg?style=flat)](https://cocoapods.org/pods/NexusRefresh)

**问题**： 多页面数据关联，页面重新出现时都需要刷新，不需要刷新时也刷新，所以有很多无效请求。如果使用通知，通知是直接刷新，没有在页面出现时刷新，也有很多无效请求。

**解决方案**： 当数据更改时，通知VC在**出现时**刷新。

## 安装

```ruby
pod 'NexusRefresh'
```

## 使用

1. 添加刷新监听

```swift
class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // 将自己加入可刷新池
        NexusRefreshManager.shared.add(self, tags: ["ViewController"]) { data in
            print("ViewController 刷新了")
        }
    }
}
```

2. 刷新

```swift
NexusRefreshManager.shared.refresh(tags: ["ViewController", "TestVC"])
```

## Q&A

1. 可以刷新除UIViewController以外的对象么？

   可以，但是他们会在通知刷新时刷新，而不是出现时刷新

2. 什么时候刷新？

   **UIViewController**若**不在顶层，出现时刷新**，**在顶层，直接刷新**。

   **非UIViewController**直接刷新。
   
3. 同一个对象可以添加多次吗？

   不可以，会以最后一次添加为准
   
4. 和`NotificationCenter`异同
   - `NotificationCenter`在一个对象中可以有多个观察者，`NexusRefreshManager`在一个对象中仅支持一个观察者。
   - `NotificationCenter`观察一个`NotificationName`，`NexusRefreshManager`可以观察多个`tag`。
   - `NotificationCenter`发送通知观察者立刻收到，`NexusRefreshManager`如果不是强制刷新，未展示的`UIViewController`会在`viewDidAppear`时收到，且只会收到**最后一次的通知**。
   - `NotificationCenter`可以接受数据，`NexusRefreshManager`也可以接受数据。
   
## 更新日志
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
