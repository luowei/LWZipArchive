# LWZipArchive Swift Version

[English](#english) | [中文](#中文)

---

## English

### Overview

`LWZipArchive_swift` is the modern Swift version of the LWZipArchive library, providing a comprehensive Swift API for zipping and unzipping files on Apple platforms. It offers a more idiomatic Swift interface with support for modern Swift features like async/await, Combine, and SwiftUI.

### Features

- **Swift-Native API**: Modern Swift API with Result types and comprehensive error handling
- **Async/Await Support**: Native async/await support for iOS 13.0+ and macOS 10.15+
- **Combine Integration**: Publisher-based API for reactive programming
- **SwiftUI Components**: Ready-to-use SwiftUI views for zip operations with progress tracking
- **Encryption Support**: AES and PKWARE encryption/decryption
- **Progress Reporting**: Real-time progress updates and cancellation support
- **Thread-Safe**: Safe to use from multiple threads simultaneously
- **Cross-Platform**: Support for iOS, tvOS, macOS, and watchOS

### Requirements

- iOS 13.0+ / tvOS 13.0+ / macOS 10.15+ / watchOS 6.0+
- Swift 5.0+
- Xcode 11.0+

### Installation

Add the following line to your Podfile:

```ruby
pod 'LWZipArchive_swift'
```

Then run:

```bash
pod install
```

### Dependencies

- LWZipArchive (~> 2.2) - The underlying C implementation

### Usage

#### 1. Import the Module

```swift
import LWZipArchive_swift
```

#### 2. Basic Zip/Unzip Operations

```swift
import Foundation
import LWZipArchive_swift

// Zip a directory
let sourceDirectory = "/path/to/source"
let zipPath = "/path/to/output.zip"

do {
    try SSZipArchive.createZipFile(atPath: zipPath,
                                   withContentsOfDirectory: sourceDirectory)
    print("Successfully created zip file")
} catch {
    print("Error creating zip: \(error)")
}

// Unzip a file
let destinationPath = "/path/to/destination"

do {
    try SSZipArchive.unzipFile(atPath: zipPath,
                              toDestination: destinationPath)
    print("Successfully unzipped file")
} catch {
    print("Error unzipping: \(error)")
}
```

#### 3. Async/Await Support

```swift
import LWZipArchive_swift

// Async zip operation
Task {
    do {
        try await SSZipArchive.createZipFileAsync(
            atPath: zipPath,
            withContentsOfDirectory: sourceDirectory
        )
        print("Zip completed successfully")
    } catch {
        print("Zip failed: \(error)")
    }
}

// Async unzip with progress
Task {
    do {
        for try await progress in SSZipArchive.unzipFileAsyncWithProgress(
            atPath: zipPath,
            toDestination: destinationPath
        ) {
            print("Progress: \(progress.fractionCompleted * 100)%")
        }
        print("Unzip completed")
    } catch {
        print("Unzip failed: \(error)")
    }
}
```

#### 4. Combine Support

```swift
import Combine
import LWZipArchive_swift

var cancellables = Set<AnyCancellable>()

// Zip with Combine
SSZipArchive.createZipFilePublisher(
    atPath: zipPath,
    withContentsOfDirectory: sourceDirectory
)
.sink(
    receiveCompletion: { completion in
        switch completion {
        case .finished:
            print("Zip completed")
        case .failure(let error):
            print("Zip failed: \(error)")
        }
    },
    receiveValue: { progress in
        print("Progress: \(progress.fractionCompleted * 100)%")
    }
)
.store(in: &cancellables)

// Unzip with Combine
SSZipArchive.unzipFilePublisher(
    atPath: zipPath,
    toDestination: destinationPath
)
.sink(
    receiveCompletion: { completion in
        switch completion {
        case .finished:
            print("Unzip completed")
        case .failure(let error):
            print("Unzip failed: \(error)")
        }
    },
    receiveValue: { progress in
        print("Progress: \(progress.fractionCompleted * 100)%")
    }
)
.store(in: &cancellables)
```

#### 5. SwiftUI Integration

```swift
import SwiftUI
import LWZipArchive_swift

struct ContentView: View {
    @State private var isZipping = false
    @State private var zipProgress: Double = 0

    var body: some View {
        VStack {
            if isZipping {
                ZipProgressView(progress: zipProgress)
                    .padding()
            }

            Button("Create Zip") {
                createZip()
            }

            // Or use the built-in ZipArchiveView
            ZipArchiveView(
                sourcePath: "/path/to/source",
                zipPath: "/path/to/output.zip",
                operation: .zip
            )
        }
    }

    func createZip() {
        isZipping = true
        Task {
            do {
                for try await progress in SSZipArchive.createZipFileAsyncWithProgress(
                    atPath: "/path/to/output.zip",
                    withContentsOfDirectory: "/path/to/source"
                ) {
                    await MainActor.run {
                        zipProgress = progress.fractionCompleted
                    }
                }
                await MainActor.run {
                    isZipping = false
                }
            } catch {
                print("Error: \(error)")
                await MainActor.run {
                    isZipping = false
                }
            }
        }
    }
}
```

#### 6. Password Protection

```swift
// Zip with password
try SSZipArchive.createZipFile(
    atPath: zipPath,
    withContentsOfDirectory: sourceDirectory,
    password: "mySecretPassword"
)

// Unzip with password
try SSZipArchive.unzipFile(
    atPath: zipPath,
    toDestination: destinationPath,
    password: "mySecretPassword"
)
```

#### 7. Selective File Zipping

```swift
// Zip specific files
let filesToZip = [
    "/path/to/file1.txt",
    "/path/to/file2.jpg",
    "/path/to/file3.pdf"
]

try SSZipArchive.createZipFile(
    atPath: zipPath,
    withFilesAtPaths: filesToZip
)
```

### API Overview

#### SSZipArchive Main Methods

**Synchronous Operations:**
```swift
// Create zip
static func createZipFile(atPath path: String,
                         withContentsOfDirectory directory: String,
                         password: String? = nil) throws

// Unzip file
static func unzipFile(atPath path: String,
                     toDestination destination: String,
                     password: String? = nil) throws
```

**Async/Await Operations:**
```swift
// Create zip asynchronously
static func createZipFileAsync(atPath path: String,
                              withContentsOfDirectory directory: String,
                              password: String? = nil) async throws

// Unzip with progress stream
static func unzipFileAsyncWithProgress(atPath path: String,
                                      toDestination destination: String,
                                      password: String? = nil) -> AsyncThrowingStream<Progress, Error>
```

**Combine Publishers:**
```swift
// Zip publisher
static func createZipFilePublisher(atPath path: String,
                                   withContentsOfDirectory directory: String,
                                   password: String? = nil) -> AnyPublisher<Progress, Error>

// Unzip publisher
static func unzipFilePublisher(atPath path: String,
                              toDestination destination: String,
                              password: String? = nil) -> AnyPublisher<Progress, Error>
```

#### SwiftUI Views

**ZipProgressView:**
```swift
struct ZipProgressView: View {
    let progress: Double
    var label: String = "Processing..."
}
```

**ZipArchiveView:**
```swift
struct ZipArchiveView: View {
    let sourcePath: String
    let zipPath: String
    let operation: ZipOperation  // .zip or .unzip
    var password: String? = nil
    var onComplete: (() -> Void)? = nil
    var onError: ((Error) -> Void)? = nil
}
```

### Error Handling

All Swift APIs use proper Swift error handling:

```swift
enum ZipArchiveError: Error {
    case fileNotFound(path: String)
    case invalidPath(path: String)
    case unzipFailed(reason: String)
    case zipFailed(reason: String)
    case invalidPassword
    case cancelled
}
```

### API Differences from Objective-C Version

| Objective-C | Swift |
|-------------|-------|
| `[SSZipArchive createZipFileAtPath:withContentsOfDirectory:]` | `SSZipArchive.createZipFile(atPath:withContentsOfDirectory:)` |
| `[SSZipArchive unzipFileAtPath:toDestination:]` | `SSZipArchive.unzipFile(atPath:toDestination:)` |
| Delegate callbacks | Combine publishers / Async streams |
| `NSError **` | Swift `throws` |

### Performance Tips

1. **Use async/await for large files** to avoid blocking the UI thread
2. **Enable progress reporting** for better user experience with large archives
3. **Use Combine publishers** when integrating with reactive architectures
4. **Password protect sensitive data** using the built-in encryption support
5. **Cancel long operations** using the cancellation support in async operations

### Thread Safety

All operations are thread-safe and can be called from any thread. Progress callbacks and completion handlers are automatically dispatched to the main queue when using async/await or Combine.

### License

LWZipArchive_swift is available under the MIT license. See the LICENSE file for more info.

---

## 中文

### 概述

`LWZipArchive_swift` 是 LWZipArchive 库的现代 Swift 版本，为 Apple 平台上的文件压缩和解压缩提供了全面的 Swift API。它提供了更符合 Swift 习惯的接口，支持现代 Swift 特性，如 async/await、Combine 和 SwiftUI。

### 功能特性

- **Swift 原生 API**: 具有 Result 类型和全面错误处理的现代 Swift API
- **Async/Await 支持**: iOS 13.0+ 和 macOS 10.15+ 的原生 async/await 支持
- **Combine 集成**: 用于响应式编程的基于 Publisher 的 API
- **SwiftUI 组件**: 带进度跟踪的即用型 SwiftUI 视图
- **加密支持**: AES 和 PKWARE 加密/解密
- **进度报告**: 实时进度更新和取消支持
- **线程安全**: 可安全地从多个线程同时使用
- **跨平台**: 支持 iOS、tvOS、macOS 和 watchOS

### 系统要求

- iOS 13.0+ / tvOS 13.0+ / macOS 10.15+ / watchOS 6.0+
- Swift 5.0+
- Xcode 11.0+

### 安装

在 Podfile 中添加以下行：

```ruby
pod 'LWZipArchive_swift'
```

然后运行：

```bash
pod install
```

### 依赖项

- LWZipArchive (~> 2.2) - 底层 C 实现

### 使用方法

#### 1. 导入模块

```swift
import LWZipArchive_swift
```

#### 2. 基本压缩/解压操作

```swift
import Foundation
import LWZipArchive_swift

// 压缩目录
let sourceDirectory = "/path/to/source"
let zipPath = "/path/to/output.zip"

do {
    try SSZipArchive.createZipFile(atPath: zipPath,
                                   withContentsOfDirectory: sourceDirectory)
    print("成功创建压缩文件")
} catch {
    print("压缩错误: \(error)")
}

// 解压文件
let destinationPath = "/path/to/destination"

do {
    try SSZipArchive.unzipFile(atPath: zipPath,
                              toDestination: destinationPath)
    print("成功解压文件")
} catch {
    print("解压错误: \(error)")
}
```

#### 3. Async/Await 支持

```swift
import LWZipArchive_swift

// 异步压缩操作
Task {
    do {
        try await SSZipArchive.createZipFileAsync(
            atPath: zipPath,
            withContentsOfDirectory: sourceDirectory
        )
        print("压缩成功完成")
    } catch {
        print("压缩失败: \(error)")
    }
}

// 带进度的异步解压
Task {
    do {
        for try await progress in SSZipArchive.unzipFileAsyncWithProgress(
            atPath: zipPath,
            toDestination: destinationPath
        ) {
            print("进度: \(progress.fractionCompleted * 100)%")
        }
        print("解压完成")
    } catch {
        print("解压失败: \(error)")
    }
}
```

#### 4. Combine 支持

```swift
import Combine
import LWZipArchive_swift

var cancellables = Set<AnyCancellable>()

// 使用 Combine 压缩
SSZipArchive.createZipFilePublisher(
    atPath: zipPath,
    withContentsOfDirectory: sourceDirectory
)
.sink(
    receiveCompletion: { completion in
        switch completion {
        case .finished:
            print("压缩完成")
        case .failure(let error):
            print("压缩失败: \(error)")
        }
    },
    receiveValue: { progress in
        print("进度: \(progress.fractionCompleted * 100)%")
    }
)
.store(in: &cancellables)
```

#### 5. SwiftUI 集成

```swift
import SwiftUI
import LWZipArchive_swift

struct ContentView: View {
    @State private var isZipping = false
    @State private var zipProgress: Double = 0

    var body: some View {
        VStack {
            if isZipping {
                ZipProgressView(progress: zipProgress)
                    .padding()
            }

            Button("创建压缩文件") {
                createZip()
            }

            // 或使用内置的 ZipArchiveView
            ZipArchiveView(
                sourcePath: "/path/to/source",
                zipPath: "/path/to/output.zip",
                operation: .zip
            )
        }
    }

    func createZip() {
        isZipping = true
        Task {
            do {
                for try await progress in SSZipArchive.createZipFileAsyncWithProgress(
                    atPath: "/path/to/output.zip",
                    withContentsOfDirectory: "/path/to/source"
                ) {
                    await MainActor.run {
                        zipProgress = progress.fractionCompleted
                    }
                }
                await MainActor.run {
                    isZipping = false
                }
            } catch {
                print("错误: \(error)")
                await MainActor.run {
                    isZipping = false
                }
            }
        }
    }
}
```

#### 6. 密码保护

```swift
// 使用密码压缩
try SSZipArchive.createZipFile(
    atPath: zipPath,
    withContentsOfDirectory: sourceDirectory,
    password: "mySecretPassword"
)

// 使用密码解压
try SSZipArchive.unzipFile(
    atPath: zipPath,
    toDestination: destinationPath,
    password: "mySecretPassword"
)
```

### 注意事项

- 所有操作都是线程安全的
- 使用 async/await 或 Combine 时，进度回调会自动分派到主队列
- Swift 版本需要 iOS 13.0 或更高版本（相比 Objective-C 版本的 iOS 9.0）
- 通过 SwiftUI 视图提供即用型 UI 组件

### 许可证

LWZipArchive_swift 采用 MIT 许可证。详见 LICENSE 文件。
