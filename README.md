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

1. 添加刷新监听

```swift
class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // 将自己加入可刷新池
        NexusRefreshManager.add(self, tags: ["ViewController"]) { data in
            print("ViewController 刷新了")
        }
    }
}
```

2. 刷新

```swift
NexusRefreshManager.refresh(tags: ["ViewController", "TestVC"])
```

## Q&A

1. 可以刷新除UIViewController以外的对象么？

   可以，但是他们会在通知刷新时刷新，而不是出现时刷新

2. 什么时候刷新？

   **UIViewController**若**不在顶层，出现时刷新**，**在顶层，直接刷新**。

   **非UIViewController**直接刷新。
   
3. 同一个对象可以添加多次吗？

   不可以，会以最后一次添加为准
   
## 更新日志
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
