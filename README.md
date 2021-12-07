# NexusRefresh - iOS跨页面按需刷新

[![iOS Version](https://img.shields.io/badge/iOS-10.0%2B-blueviolet)](https://cocoapods.org/pods/NexusRefresh)
[![Language](https://img.shields.io/badge/swift-5.0-ff501e)](https://cocoapods.org/pods/NexusRefresh)
[![Version](https://img.shields.io/cocoapods/v/NexusRefresh.svg?style=flat)](https://cocoapods.org/pods/NexusRefresh)
[![License](https://img.shields.io/cocoapods/l/NexusRefresh.svg?style=flat)](https://cocoapods.org/pods/NexusRefresh)

**问题**： 多页面数据关联，页面重新出现时都需要刷新，不需要刷新时也刷新，所以有很多无效请求。如果使用通知，通知是直接刷新，没有在页面出现时刷新，也有很多无效请求。

**解决方案**： 当数据更改时，通知VC在**出现时**刷新。

**优点**：避免无效请求。

**缺点**：需要增加通知刷新代码，若忘记增加，会导致数据不刷新。

## 安装

```ruby
pod 'NexusRefresh'
```

## 使用

1. 在BaseViewController中将自己添加到刷新池

```swift
class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // 将自己加入可刷新池，不添加到刷新池将无法刷新
        NexusRefreshManager.add(self)
    }
}
```

2. 在具体的ViewController中，实现刷新协议

```swift
extension DemoViewController: NexusRefreshDelegate {
    func nexusTags() -> Set<String> {
        // 刷新的标签列表，标签会作为刷新标识
        return ["home"]
    }
    
    func nexusRefresh(data: Any?) {
        // 页面出现时的刷新方法，可以传递数据
        self.loadData()
    }
    
}

```

3. 通知出现时刷新

```swift
// 标签列表中的都会被刷新
NexusRefreshManager.refresh(tags: ["home"])

/// 刷新方法详情
/// - Parameters:
///   - tags: 标签列表
///   - data: 传递数据
///   - filtObjects: 过滤列表
static func refresh(tags: Set<String>, data: Any? = nil, filtObjects: [AnyObject] = [])
```

## Q&A

1. 可以刷新除UIViewController以外的对象么？

   可以，只要对象实现NexusRefreshDelegate代理协议，并且加入到可刷新池中NexusRefreshManager.add(self)，但是他们会在通知刷新时刷新，而不是出现时刷新

2. 什么时候刷新？

   实现NexusRefreshDelegate的**UIViewController**, 若**不在顶层，出现时刷新**，**在顶层，直接刷新**。

   实现NexusRefreshDelegate的**非UIViewController**，直接刷新。
   
## 更新日志
### 1.0.1
1. 增加错误提示
2. 更新文档

## Author

可以通过邮箱联系我： 664454335@qq.com

## License

NexusRefresh is available under the MIT license. See the LICENSE file for more info.
