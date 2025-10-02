# LWZipArchive

[![Build Status](https://travis-ci.org/ZipArchive/ZipArchive.svg?branch=master)](https://travis-ci.org/ZipArchive/ZipArchive)

LWZipArchive 是一个简单实用的工具类,用于在 iOS、macOS、tvOS 和 watchOS 平台上进行文件压缩和解压缩操作。它基于 SSZipArchive 项目,提供了完整的 ZIP 文件处理功能。

## 主要特性

- ✓ 解压 ZIP 文件
- ✓ 解压密码保护的 ZIP 文件
- ✓ 解压 AES 加密的 ZIP 文件
- ✓ 创建 ZIP 压缩文件
- ✓ 创建密码保护的 ZIP 文件
- ✓ 创建 AES 加密的 ZIP 文件
- ✓ 自定义压缩级别
- ✓ 压缩 NSData 实例(指定文件名)
- ✓ 支持进度回调
- ✓ 支持委托模式

## 系统要求

- **iOS**: 9.0 及以上
- **tvOS**: 9.0 及以上
- **macOS**: 10.8 及以上
- **watchOS**: 2.0 及以上
- **Xcode**: 7-11 及以上
- **语言**: 支持 Objective-C 和 Swift 3+

## 安装方式

### CocoaPods

在您的 `Podfile` 中添加:

```ruby
pod 'LWZipArchive'
```

建议明确指定最低部署目标:

```ruby
platform :ios, '9.0'
```

推荐使用 CocoaPods 1.7.5 或更高版本。

### Carthage

在您的 `Cartfile` 中添加:

```
github "ZipArchive/ZipArchive"
```

### 手动安装

1. 将 `SSZipArchive` 和 `minizip` 文件夹添加到您的项目中
2. 在目标中添加 `libz` 和 `libiconv` 库
3. 在目标中添加 `Security` 框架
4. 添加以下预处理器宏定义 `GCC_PREPROCESSOR_DEFINITIONS`:
   ```
   HAVE_INTTYPES_H HAVE_PKCRYPT HAVE_STDINT_H HAVE_WZAES HAVE_ZLIB $(inherited)
   ```

**注意**: LWZipArchive 需要 ARC (自动引用计数) 支持。

## 使用方法

### Objective-C

#### 基本压缩和解压

```objective-c
#import "SSZipArchive.h"

// 创建 ZIP 文件
[SSZipArchive createZipFileAtPath:zipPath withContentsOfDirectory:sampleDataPath];

// 解压 ZIP 文件
[SSZipArchive unzipFileAtPath:zipPath toDestination:unzipPath];
```

#### 密码保护

```objective-c
// 创建密码保护的 ZIP 文件
[SSZipArchive createZipFileAtPath:zipPath
           withContentsOfDirectory:directoryPath
                      withPassword:@"your_password"];

// 解压密码保护的 ZIP 文件
NSError *error = nil;
[SSZipArchive unzipFileAtPath:zipPath
                toDestination:unzipPath
                    overwrite:YES
                     password:@"your_password"
                        error:&error];
```

#### 使用委托模式

```objective-c
// 使用委托获取解压进度
[SSZipArchive unzipFileAtPath:zipPath
                toDestination:unzipPath
                     delegate:self];

// 实现委托方法
- (void)zipArchiveWillUnzipArchiveAtPath:(NSString *)path
                                 zipInfo:(unz_global_info)zipInfo {
    NSLog(@"开始解压: %@", path);
}

- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path
                                zipInfo:(unz_global_info)zipInfo
                           unzippedPath:(NSString *)unzippedPath {
    NSLog(@"解压完成: %@", unzippedPath);
}

- (void)zipArchiveProgressEvent:(unsigned long long)loaded
                          total:(unsigned long long)total {
    float progress = (float)loaded / (float)total;
    NSLog(@"解压进度: %.2f%%", progress * 100);
}
```

#### 使用进度回调

```objective-c
// 使用 block 回调获取进度
[SSZipArchive unzipFileAtPath:zipPath
                toDestination:unzipPath
              progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
                  NSLog(@"正在解压: %@ (%ld/%ld)", entry, entryNumber, total);
              }
            completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
                  if (succeeded) {
                      NSLog(@"解压成功: %@", path);
                  } else {
                      NSLog(@"解压失败: %@", error);
                  }
              }];
```

#### 高级压缩选项

```objective-c
// 自定义压缩级别和加密方式
[SSZipArchive createZipFileAtPath:zipPath
          withContentsOfDirectory:directoryPath
              keepParentDirectory:YES
                 compressionLevel:Z_BEST_COMPRESSION  // 最高压缩级别
                         password:@"password"
                              AES:YES  // 使用 AES 加密
                  progressHandler:^(NSUInteger entryNumber, NSUInteger total) {
                      NSLog(@"压缩进度: %lu/%lu", entryNumber, total);
                  }];
```

#### 实例化方式使用

```objective-c
// 创建 ZIP 归档实例
SSZipArchive *zipArchive = [[SSZipArchive alloc] initWithPath:zipPath];
[zipArchive open];

// 写入文件
[zipArchive writeFile:filePath withPassword:nil];

// 写入文件夹
[zipArchive writeFolderAtPath:folderPath
               withFolderName:@"MyFolder"
                 withPassword:nil];

// 写入数据
NSData *data = [@"Hello, World!" dataUsingEncoding:NSUTF8StringEncoding];
[zipArchive writeData:data
             filename:@"hello.txt"
         withPassword:nil];

// 关闭归档
[zipArchive close];
```

### Swift

#### 基本压缩和解压

```swift
import SSZipArchive

// 创建 ZIP 文件
SSZipArchive.createZipFile(atPath: zipPath, withContentsOfDirectory: sampleDataPath)

// 解压 ZIP 文件
SSZipArchive.unzipFile(atPath: zipPath, toDestination: unzipPath)
```

#### 密码保护

```swift
// 创建密码保护的 ZIP 文件
SSZipArchive.createZipFile(atPath: zipPath,
                           withContentsOfDirectory: directoryPath,
                           withPassword: "your_password")

// 解压密码保护的 ZIP 文件
do {
    var error: NSError?
    let success = SSZipArchive.unzipFile(atPath: zipPath,
                                         toDestination: unzipPath,
                                         overwrite: true,
                                         password: "your_password",
                                         error: &error)
    if !success {
        print("解压失败: \(error?.localizedDescription ?? "未知错误")")
    }
} catch {
    print("解压出错: \(error)")
}
```

#### 使用进度回调

```swift
// 使用闭包回调
SSZipArchive.unzipFile(atPath: zipPath,
                       toDestination: unzipPath,
                       progressHandler: { (entry, zipInfo, entryNumber, total) in
                           print("正在解压: \(entry) (\(entryNumber)/\(total))")
                       },
                       completionHandler: { (path, succeeded, error) in
                           if succeeded {
                               print("解压成功: \(path)")
                           } else {
                               print("解压失败: \(error?.localizedDescription ?? "未知错误")")
                           }
                       })
```

#### 高级压缩选项

```swift
// 自定义压缩级别
SSZipArchive.createZipFile(atPath: zipPath,
                           withContentsOfDirectory: directoryPath,
                           keepParentDirectory: true,
                           compressionLevel: Z_BEST_COMPRESSION,
                           password: "password",
                           aes: true,
                           progressHandler: { (entryNumber, total) in
                               print("压缩进度: \(entryNumber)/\(total)")
                           })
```

## API 参考

### 工具类方法

#### 密码验证

```objective-c
// 检查文件是否有密码保护
+ (BOOL)isFilePasswordProtectedAtPath:(NSString *)path;

// 验证密码是否正确
+ (BOOL)isPasswordValidForArchiveAtPath:(NSString *)path
                               password:(NSString *)pw
                                  error:(NSError **)error;
```

#### 获取压缩包信息

```objective-c
// 获取压缩包的总大小
+ (NSNumber *)payloadSizeForArchiveAtPath:(NSString *)path
                                    error:(NSError **)error;
```

### 委托协议

实现 `SSZipArchiveDelegate` 协议可以监听解压过程:

```objective-c
@protocol SSZipArchiveDelegate <NSObject>
@optional

// 即将开始解压归档
- (void)zipArchiveWillUnzipArchiveAtPath:(NSString *)path
                                 zipInfo:(unz_global_info)zipInfo;

// 已完成解压归档
- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path
                                zipInfo:(unz_global_info)zipInfo
                           unzippedPath:(NSString *)unzippedPath;

// 是否应该解压指定文件
- (BOOL)zipArchiveShouldUnzipFileAtIndex:(NSInteger)fileIndex
                              totalFiles:(NSInteger)totalFiles
                             archivePath:(NSString *)archivePath
                                fileInfo:(unz_file_info)fileInfo;

// 即将解压指定文件
- (void)zipArchiveWillUnzipFileAtIndex:(NSInteger)fileIndex
                            totalFiles:(NSInteger)totalFiles
                           archivePath:(NSString *)archivePath
                              fileInfo:(unz_file_info)fileInfo;

// 已完成解压指定文件
- (void)zipArchiveDidUnzipFileAtIndex:(NSInteger)fileIndex
                           totalFiles:(NSInteger)totalFiles
                          archivePath:(NSString *)archivePath
                             fileInfo:(unz_file_info)fileInfo;

// 已完成解压文件(包含解压后的文件路径)
- (void)zipArchiveDidUnzipFileAtIndex:(NSInteger)fileIndex
                           totalFiles:(NSInteger)totalFiles
                          archivePath:(NSString *)archivePath
                      unzippedFilePath:(NSString *)unzippedFilePath;

// 解压进度事件
- (void)zipArchiveProgressEvent:(unsigned long long)loaded
                          total:(unsigned long long)total;

@end
```

### 错误处理

LWZipArchive 定义了以下错误代码:

```objective-c
typedef NS_ENUM(NSInteger, SSZipArchiveErrorCode) {
    SSZipArchiveErrorCodeFailedOpenZipFile      = -1,  // 打开 ZIP 文件失败
    SSZipArchiveErrorCodeFailedOpenFileInZip    = -2,  // 打开 ZIP 中的文件失败
    SSZipArchiveErrorCodeFileInfoNotLoadable    = -3,  // 无法加载文件信息
    SSZipArchiveErrorCodeFileContentNotReadable = -4,  // 无法读取文件内容
    SSZipArchiveErrorCodeFailedToWriteFile      = -5,  // 写入文件失败
    SSZipArchiveErrorCodeInvalidArguments       = -6,  // 参数无效
};
```

错误域: `SSZipArchiveErrorDomain`

## 注意事项

### 关于 AES 加密

- 如果需要与 macOS 原生的 `unzip` 命令和归档工具兼容,请不要使用 AES 加密
- AES 加密提供更强的安全性,但兼容性较差
- 默认情况下,使用密码创建的 ZIP 文件会使用 AES 加密

### 压缩级别

压缩级别使用 zlib 标准:
- `Z_NO_COMPRESSION` (0): 不压缩
- `Z_BEST_SPEED` (1): 最快速度
- `Z_BEST_COMPRESSION` (9): 最高压缩率
- `Z_DEFAULT_COMPRESSION` (-1): 默认压缩级别(推荐)

### 性能优化建议

1. 对于大文件,建议使用进度回调以提供用户反馈
2. 在后台线程执行压缩/解压操作,避免阻塞主线程
3. 根据需求选择合适的压缩级别,平衡速度和压缩率

## 示例代码

### 完整的解压示例

```objective-c
NSString *zipPath = @"/path/to/archive.zip";
NSString *destination = NSTemporaryDirectory();

NSError *error = nil;
BOOL success = [SSZipArchive unzipFileAtPath:zipPath
                                toDestination:destination
                           preserveAttributes:YES
                                    overwrite:YES
                               nestedZipLevel:0
                                     password:nil
                                        error:&error
                                     delegate:self
                              progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      // 更新 UI 进度
                                      float progress = (float)entryNumber / (float)total;
                                      NSLog(@"解压进度: %.2f%%", progress * 100);
                                  });
                              }
                            completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (succeeded) {
                                        NSLog(@"解压成功!");
                                    } else {
                                        NSLog(@"解压失败: %@", error.localizedDescription);
                                    }
                                });
                            }];
```

### 完整的压缩示例

```objective-c
NSString *sourcePath = @"/path/to/folder";
NSString *zipPath = @"/path/to/output.zip";

BOOL success = [SSZipArchive createZipFileAtPath:zipPath
                         withContentsOfDirectory:sourcePath
                             keepParentDirectory:YES
                                compressionLevel:Z_DEFAULT_COMPRESSION
                                        password:@"secure_password"
                                             AES:YES
                                 progressHandler:^(NSUInteger entryNumber, NSUInteger total) {
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         float progress = (float)entryNumber / (float)total;
                                         NSLog(@"压缩进度: %.2f%%", progress * 100);
                                     });
                                 }];

if (success) {
    NSLog(@"压缩成功!");
} else {
    NSLog(@"压缩失败!");
}
```

## 技术架构

LWZipArchive 基于以下核心技术:

- **Minizip**: 用于底层 ZIP 文件操作的 C 库
- **zlib**: 提供压缩和解压缩功能
- **Security Framework**: 用于 AES 加密
- **iconv**: 字符编码转换

## 版本信息

- **当前版本**: 2.2.3
- **主要分支**: 支持 Objective-C 和 Swift 3+

## 许可证

LWZipArchive 使用 [MIT 许可证](https://github.com/samsoffes/ssziparchive/raw/master/LICENSE)。

内部使用的 Minizip 库使用 [Zlib 许可证](https://www.zlib.net/zlib_license.html)。

版权所有 (c) 2010-2015, Sam Soffes, https://soff.es

## 致谢

- 感谢 **aish** 创建了 [ZipArchive](https://code.google.com/archive/p/ziparchive/) 项目,它是 SSZipArchive 的灵感来源
- 感谢 [@soffes](https://github.com/soffes) 为项目命名
- 感谢 [@randomsequence](https://github.com/randomsequence) 实现了创建功能
- 感谢 [@johnezang](https://github.com/johnezang) 在整个过程中提供的帮助
- 感谢 [@nmoinvaz](https://github.com/nmoinvaz) 提供 minizip,这是 ZipArchive 的核心
- 感谢[所有贡献者](https://github.com/ZipArchive/ZipArchive/graphs/contributors)

## 相关链接

- GitHub 仓库: https://github.com/ZipArchive/ZipArchive
- 问题反馈: https://github.com/ZipArchive/ZipArchive/issues
- CocoaPods: https://cocoapods.org/pods/SSZipArchive

## 常见问题

### Q: 如何处理大文件压缩?
A: 对于大文件,建议使用实例化方式,逐个添加文件到归档中,并在后台线程执行操作。

### Q: 为什么解压后中文文件名乱码?
A: LWZipArchive 内部使用 iconv 进行字符编码转换,支持中文文件名。确保原始文件使用 UTF-8 编码。

### Q: 如何取消正在进行的解压操作?
A: 实现委托方法 `zipArchiveShouldUnzipFileAtIndex:` 并返回 `NO` 可以停止解压过程。

### Q: 是否支持分卷压缩?
A: 当前版本不支持创建分卷压缩文件,但可以读取分卷压缩信息。

### Q: 压缩后的文件比原文件大?
A: 对于已经压缩过的文件(如图片、视频),再次压缩可能会增大文件体积。可以使用 `Z_NO_COMPRESSION` 仅打包不压缩。
