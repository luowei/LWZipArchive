# LWZipArchive

[![Build Status](https://travis-ci.org/ZipArchive/ZipArchive.svg?branch=master)](https://travis-ci.org/ZipArchive/ZipArchive)

[English](./README.md) | [中文版](./README_ZH.md) | [Swift Version](./README_SWIFT_VERSION.md)

> **Note:** A modern Swift version of this library is now available! See [README_SWIFT_VERSION.md](./README_SWIFT_VERSION.md) for details on using `LWZipArchive_swift` with async/await, Combine, and SwiftUI support.

## Overview

LWZipArchive is a powerful and easy-to-use utility class for ZIP compression and decompression on iOS, macOS, tvOS, and watchOS platforms. Built on top of the proven SSZipArchive project, it provides comprehensive ZIP file handling capabilities with full support for password protection, encryption, and progress tracking.

**Key Highlights:**
- Battle-tested library used by thousands of apps
- Simple API for common tasks, advanced features when you need them
- Full Swift and Objective-C support
- Cross-platform compatibility (iOS, macOS, tvOS, watchOS)
- Industry-standard encryption and security

## Features

### Core Capabilities
- Unzip ZIP files with full format support
- Create ZIP archives from files and directories
- Compress NSData instances directly (with custom filenames)
- Stream API for incremental archive creation
- Delegate pattern for fine-grained control

### Security & Encryption
- Password-protected ZIP files (create and extract)
- AES-256 encryption support for maximum security
- Standard ZIP encryption for broad compatibility
- Password validation and verification utilities
- Secure file handling with proper error reporting

### Performance & Monitoring
- Multiple compression levels (0-9) for size/speed optimization
- Real-time progress tracking with callbacks
- Progress handlers for both compression and decompression
- Delegate methods for granular progress monitoring
- Efficient memory management for large files

### Advanced Features
- Preserve file attributes during extraction
- Selective file extraction with delegate filters
- Nested ZIP archive support
- Archive payload size calculation
- Overwrite control and error handling

## System Requirements

**Platform Support:**
- iOS 9.0 and above
- tvOS 9.0 and above
- macOS 10.8 and above
- watchOS 2.0 and above

**Development Environment:**
- Xcode 7-11 and above
- Objective-C and Swift 3+ support
- ARC (Automatic Reference Counting) required

## Installation

### CocoaPods (Recommended)

Add LWZipArchive to your `Podfile`:

```ruby
# Specify your deployment target
platform :ios, '9.0'

# Add the pod
pod 'LWZipArchive'

# Or use the original SSZipArchive
# pod 'SSZipArchive'
```

Then run:
```bash
pod install
```

**Requirements:** CocoaPods 1.7.5 or higher is recommended.

### Carthage

Add to your `Cartfile`:

```
github "ZipArchive/ZipArchive"
```

### Manual Installation

For projects not using dependency managers:

1. **Add Source Files**
   - Add the `SSZipArchive` and `minizip` folders to your project

2. **Link Required Libraries**
   - `libz` (compression)
   - `libiconv` (character encoding)
   - `Security.framework` (AES encryption)

3. **Configure Build Settings**

   Add to `GCC_PREPROCESSOR_DEFINITIONS`:
   ```
   HAVE_INTTYPES_H
   HAVE_PKCRYPT
   HAVE_STDINT_H
   HAVE_WZAES
   HAVE_ZLIB
   $(inherited)
   ```

4. **Enable ARC**

   LWZipArchive requires ARC (Automatic Reference Counting) to be enabled.

## Quick Start

Get started with LWZipArchive in just a few lines of code:

**Objective-C:**
```objective-c
#import "SSZipArchive.h"

// Compress a folder
[SSZipArchive createZipFileAtPath:@"/path/to/output.zip"
            withContentsOfDirectory:@"/path/to/folder"];

// Decompress a ZIP file
[SSZipArchive unzipFileAtPath:@"/path/to/archive.zip"
                toDestination:@"/path/to/destination"];
```

**Swift:**
```swift
import SSZipArchive

// Compress a folder
SSZipArchive.createZipFile(atPath: "/path/to/output.zip",
                           withContentsOfDirectory: "/path/to/folder")

// Decompress a ZIP file
SSZipArchive.unzipFile(atPath: "/path/to/archive.zip",
                       toDestination: "/path/to/destination")
```

## Usage

### Basic Zip Compression

#### Objective-C

```objective-c
// Zip a directory
[SSZipArchive createZipFileAtPath:@"/path/to/output.zip"
            withContentsOfDirectory:@"/path/to/folder"];

// Zip specific files
NSArray *filePaths = @[@"/path/to/file1.txt", @"/path/to/file2.jpg"];
[SSZipArchive createZipFileAtPath:@"/path/to/output.zip"
                 withFilesAtPaths:filePaths];

// Zip with compression level (0-9, where 0=no compression, 9=max compression)
[SSZipArchive createZipFileAtPath:@"/path/to/output.zip"
          withContentsOfDirectory:@"/path/to/folder"
              keepParentDirectory:YES
                 compressionLevel:Z_BEST_COMPRESSION
                         password:nil
                              AES:NO
                  progressHandler:nil];
```

#### Swift

```swift
// Zip a directory
SSZipArchive.createZipFile(atPath: "/path/to/output.zip",
                           withContentsOfDirectory: "/path/to/folder")

// Zip specific files
let filePaths = ["/path/to/file1.txt", "/path/to/file2.jpg"]
SSZipArchive.createZipFile(atPath: "/path/to/output.zip",
                           withFilesAtPaths: filePaths)

// Zip with compression level
SSZipArchive.createZipFile(atPath: "/path/to/output.zip",
                           withContentsOfDirectory: "/path/to/folder",
                           keepParentDirectory: true,
                           compressionLevel: Z_BEST_COMPRESSION,
                           password: nil,
                           aes: false,
                           progressHandler: nil)
```

### Basic Zip Decompression

#### Objective-C

```objective-c
// Simple unzip
[SSZipArchive unzipFileAtPath:@"/path/to/archive.zip"
                toDestination:@"/path/to/destination"];

// Unzip with overwrite option
NSError *error = nil;
[SSZipArchive unzipFileAtPath:@"/path/to/archive.zip"
                toDestination:@"/path/to/destination"
                    overwrite:YES
                     password:nil
                        error:&error];

if (error) {
    NSLog(@"Unzip failed: %@", error);
}
```

#### Swift

```swift
// Simple unzip
SSZipArchive.unzipFile(atPath: "/path/to/archive.zip",
                       toDestination: "/path/to/destination")

// Unzip with error handling
var error: NSError?
let success = SSZipArchive.unzipFile(atPath: "/path/to/archive.zip",
                                     toDestination: "/path/to/destination",
                                     overwrite: true,
                                     password: nil,
                                     error: &error)

if let error = error {
    print("Unzip failed: \(error)")
}
```

### Password Protection

#### Objective-C

```objective-c
// Create password-protected zip (AES encryption)
[SSZipArchive createZipFileAtPath:@"/path/to/protected.zip"
          withContentsOfDirectory:@"/path/to/folder"
                     withPassword:@"your_password"];

// Create password-protected zip (standard encryption, compatible with native tools)
[SSZipArchive createZipFileAtPath:@"/path/to/protected.zip"
          withContentsOfDirectory:@"/path/to/folder"
              keepParentDirectory:YES
                 compressionLevel:Z_DEFAULT_COMPRESSION
                         password:@"your_password"
                              AES:NO  // Use standard encryption for compatibility
                  progressHandler:nil];

// Unzip password-protected archive
NSError *error = nil;
[SSZipArchive unzipFileAtPath:@"/path/to/protected.zip"
                toDestination:@"/path/to/destination"
                    overwrite:YES
                     password:@"your_password"
                        error:&error];

// Check if file is password protected
BOOL isProtected = [SSZipArchive isFilePasswordProtectedAtPath:@"/path/to/archive.zip"];

// Verify password validity
NSError *error = nil;
BOOL isValid = [SSZipArchive isPasswordValidForArchiveAtPath:@"/path/to/protected.zip"
                                                    password:@"test_password"
                                                       error:&error];
```

#### Swift

```swift
// Create password-protected zip (AES encryption)
SSZipArchive.createZipFile(atPath: "/path/to/protected.zip",
                           withContentsOfDirectory: "/path/to/folder",
                           withPassword: "your_password")

// Create password-protected zip (standard encryption)
SSZipArchive.createZipFile(atPath: "/path/to/protected.zip",
                           withContentsOfDirectory: "/path/to/folder",
                           keepParentDirectory: true,
                           compressionLevel: Z_DEFAULT_COMPRESSION,
                           password: "your_password",
                           aes: false,  // Use standard encryption for compatibility
                           progressHandler: nil)

// Unzip password-protected archive
var error: NSError?
SSZipArchive.unzipFile(atPath: "/path/to/protected.zip",
                       toDestination: "/path/to/destination",
                       overwrite: true,
                       password: "your_password",
                       error: &error)

// Check if file is password protected
let isProtected = SSZipArchive.isFilePasswordProtected(atPath: "/path/to/archive.zip")

// Verify password validity
var error: NSError?
let isValid = SSZipArchive.isPasswordValid(forArchive: "/path/to/protected.zip",
                                           password: "test_password",
                                           error: &error)
```

### Progress Tracking

#### Objective-C

```objective-c
// Zip with progress tracking
[SSZipArchive createZipFileAtPath:@"/path/to/output.zip"
          withContentsOfDirectory:@"/path/to/folder"
              keepParentDirectory:YES
                     withPassword:nil
               andProgressHandler:^(NSUInteger entryNumber, NSUInteger total) {
    NSLog(@"Zipping: %lu of %lu", (unsigned long)entryNumber, (unsigned long)total);
}];

// Unzip with progress tracking
[SSZipArchive unzipFileAtPath:@"/path/to/archive.zip"
                toDestination:@"/path/to/destination"
              progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
    NSLog(@"Unzipping: %@ (%ld of %ld)", entry, entryNumber, total);
}
            completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
    if (succeeded) {
        NSLog(@"Unzip completed successfully");
    } else {
        NSLog(@"Unzip failed: %@", error);
    }
}];
```

#### Swift

```swift
// Zip with progress tracking
SSZipArchive.createZipFile(atPath: "/path/to/output.zip",
                           withContentsOfDirectory: "/path/to/folder",
                           keepParentDirectory: true,
                           withPassword: nil,
                           andProgressHandler: { (entryNumber, total) in
    print("Zipping: \(entryNumber) of \(total)")
})

// Unzip with progress tracking
SSZipArchive.unzipFile(atPath: "/path/to/archive.zip",
                       toDestination: "/path/to/destination",
                       progressHandler: { (entry, zipInfo, entryNumber, total) in
    print("Unzipping: \(entry) (\(entryNumber) of \(total))")
},
                       completionHandler: { (path, succeeded, error) in
    if succeeded {
        print("Unzip completed successfully")
    } else {
        print("Unzip failed: \(error?.localizedDescription ?? "")")
    }
})
```

### Advanced Usage - Delegate

#### Objective-C

```objective-c
// Implement SSZipArchiveDelegate
@interface MyClass : NSObject <SSZipArchiveDelegate>
@end

@implementation MyClass

- (void)zipArchiveWillUnzipArchiveAtPath:(NSString *)path zipInfo:(unz_global_info)zipInfo {
    NSLog(@"Will unzip archive at: %@", path);
}

- (BOOL)zipArchiveShouldUnzipFileAtIndex:(NSInteger)fileIndex
                              totalFiles:(NSInteger)totalFiles
                             archivePath:(NSString *)archivePath
                                fileInfo:(unz_file_info)fileInfo {
    // Return NO to skip certain files
    return YES;
}

- (void)zipArchiveDidUnzipArchiveAtPath:(NSString *)path
                               zipInfo:(unz_global_info)zipInfo
                          unzippedPath:(NSString *)unzippedPath {
    NSLog(@"Did unzip archive to: %@", unzippedPath);
}

- (void)unzipWithDelegate {
    [SSZipArchive unzipFileAtPath:@"/path/to/archive.zip"
                    toDestination:@"/path/to/destination"
                         delegate:self];
}

@end
```

#### Swift

```swift
// Implement SSZipArchiveDelegate
class MyClass: NSObject, SSZipArchiveDelegate {

    func zipArchiveWillUnzipArchive(atPath path: String, zipInfo: unz_global_info) {
        print("Will unzip archive at: \(path)")
    }

    func zipArchiveShouldUnzipFile(atIndex fileIndex: Int,
                                   totalFiles: Int,
                                   archivePath: String,
                                   fileInfo: unz_file_info) -> Bool {
        // Return false to skip certain files
        return true
    }

    func zipArchiveDidUnzipArchive(atPath path: String,
                                   zipInfo: unz_global_info,
                                   unzippedPath: String) {
        print("Did unzip archive to: \(unzippedPath)")
    }

    func unzipWithDelegate() {
        SSZipArchive.unzipFile(atPath: "/path/to/archive.zip",
                               toDestination: "/path/to/destination",
                               delegate: self)
    }
}
```

### Advanced Usage - Stream API

#### Objective-C

```objective-c
// Create zip archive incrementally
SSZipArchive *zipArchive = [[SSZipArchive alloc] initWithPath:@"/path/to/output.zip"];
[zipArchive open];

// Write individual files
[zipArchive writeFile:@"/path/to/file1.txt" withPassword:nil];
[zipArchive writeFileAtPath:@"/path/to/file2.jpg"
               withFileName:@"renamed.jpg"
               withPassword:@"password"];

// Write data directly
NSData *data = [@"Hello, World!" dataUsingEncoding:NSUTF8StringEncoding];
[zipArchive writeData:data filename:@"greeting.txt" withPassword:nil];

// Write with compression settings
[zipArchive writeData:data
             filename:@"compressed.txt"
     compressionLevel:Z_BEST_COMPRESSION
             password:@"secret"
                  AES:YES];

// Write empty folder
[zipArchive writeFolderAtPath:@"/path/to/folder"
               withFolderName:@"MyFolder"
                 withPassword:nil];

[zipArchive close];
```

#### Swift

```swift
// Create zip archive incrementally
guard let zipArchive = SSZipArchive(path: "/path/to/output.zip") else {
    return
}

zipArchive.open()

// Write individual files
zipArchive.writeFile("/path/to/file1.txt", withPassword: nil)
zipArchive.writeFile(atPath: "/path/to/file2.jpg",
                     withFileName: "renamed.jpg",
                     withPassword: "password")

// Write data directly
let data = "Hello, World!".data(using: .utf8)!
zipArchive.write(data, filename: "greeting.txt", withPassword: nil)

// Write with compression settings
zipArchive.write(data,
                 filename: "compressed.txt",
                 compressionLevel: Z_BEST_COMPRESSION,
                 password: "secret",
                 aes: true)

// Write empty folder
zipArchive.writeFolder(atPath: "/path/to/folder",
                       withFolderName: "MyFolder",
                       withPassword: nil)

zipArchive.close()
```

### Utility Functions

#### Objective-C

```objective-c
// Get total payload size of archive
NSError *error = nil;
NSNumber *payloadSize = [SSZipArchive payloadSizeForArchiveAtPath:@"/path/to/archive.zip"
                                                             error:&error];
if (payloadSize) {
    NSLog(@"Archive payload size: %@ bytes", payloadSize);
}
```

#### Swift

```swift
// Get total payload size of archive
var error: NSError?
if let payloadSize = SSZipArchive.payloadSize(forArchive: "/path/to/archive.zip",
                                               error: &error) {
    print("Archive payload size: \(payloadSize) bytes")
}
```

## Comprehensive Usage Examples

### Example 1: Complete File Backup System

**Objective-C:**
```objective-c
- (void)backupDocumentsWithPassword:(NSString *)password {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *backupPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"backup.zip"];

    // Create encrypted backup with progress tracking
    BOOL success = [SSZipArchive createZipFileAtPath:backupPath
                             withContentsOfDirectory:documentsPath
                                 keepParentDirectory:YES
                                    compressionLevel:Z_BEST_COMPRESSION
                                            password:password
                                                 AES:YES
                                     progressHandler:^(NSUInteger entryNumber, NSUInteger total) {
        dispatch_async(dispatch_get_main_queue(), ^{
            float progress = (float)entryNumber / (float)total;
            NSLog(@"Backup Progress: %.1f%%", progress * 100);
            // Update UI progress bar here
        });
    }];

    if (success) {
        NSLog(@"Backup created successfully at: %@", backupPath);
    }
}
```

**Swift:**
```swift
func backupDocuments(withPassword password: String) {
    guard let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return }
    let backupPath = NSTemporaryDirectory() + "backup.zip"

    // Create encrypted backup with progress tracking
    let success = SSZipArchive.createZipFile(
        atPath: backupPath,
        withContentsOfDirectory: documentsPath,
        keepParentDirectory: true,
        compressionLevel: Z_BEST_COMPRESSION,
        password: password,
        aes: true,
        progressHandler: { (entryNumber, total) in
            DispatchQueue.main.async {
                let progress = Float(entryNumber) / Float(total)
                print("Backup Progress: \(String(format: "%.1f", progress * 100))%")
                // Update UI progress bar here
            }
        }
    )

    if success {
        print("Backup created successfully at: \(backupPath)")
    }
}
```

### Example 2: Download and Extract ZIP with Progress UI

**Swift:**
```swift
class DownloadManager {
    func downloadAndExtract(url: URL, completion: @escaping (Bool) -> Void) {
        // Download ZIP file
        URLSession.shared.downloadTask(with: url) { localURL, response, error in
            guard let localURL = localURL, error == nil else {
                completion(false)
                return
            }

            // Move to temporary location
            let tempZipPath = NSTemporaryDirectory() + "downloaded.zip"
            let extractPath = NSTemporaryDirectory() + "extracted/"

            do {
                try? FileManager.default.removeItem(atPath: tempZipPath)
                try FileManager.default.moveItem(at: localURL, to: URL(fileURLWithPath: tempZipPath))

                // Extract with progress tracking
                SSZipArchive.unzipFile(
                    atPath: tempZipPath,
                    toDestination: extractPath,
                    progressHandler: { entry, zipInfo, entryNumber, total in
                        DispatchQueue.main.async {
                            let progress = Float(entryNumber) / Float(total)
                            print("Extracting: \(entry) (\(entryNumber)/\(total))")
                            // Update progress: NotificationCenter, delegate, or closure
                        }
                    },
                    completionHandler: { path, succeeded, error in
                        DispatchQueue.main.async {
                            if succeeded {
                                print("Successfully extracted to: \(path)")
                                completion(true)
                            } else {
                                print("Extraction failed: \(error?.localizedDescription ?? "Unknown error")")
                                completion(false)
                            }
                        }
                    }
                )
            } catch {
                print("File operation failed: \(error)")
                completion(false)
            }
        }.resume()
    }
}
```

### Example 3: Selective File Extraction with Delegate

**Objective-C:**
```objective-c
@interface FileExtractor : NSObject <SSZipArchiveDelegate>
@property (nonatomic, strong) NSSet *allowedExtensions;
@end

@implementation FileExtractor

- (instancetype)init {
    self = [super init];
    if (self) {
        _allowedExtensions = [NSSet setWithObjects:@".jpg", @".png", @".pdf", nil];
    }
    return self;
}

- (BOOL)zipArchiveShouldUnzipFileAtIndex:(NSInteger)fileIndex
                              totalFiles:(NSInteger)totalFiles
                             archivePath:(NSString *)archivePath
                                fileInfo:(unz_file_info)fileInfo {
    // Get file name from archive
    NSString *fileName = [self getFileNameAtIndex:fileIndex fromArchive:archivePath];
    NSString *extension = [fileName.pathExtension lowercaseString];

    // Only extract allowed file types
    BOOL shouldExtract = [self.allowedExtensions containsObject:[@"." stringByAppendingString:extension]];

    if (shouldExtract) {
        NSLog(@"Extracting: %@", fileName);
    } else {
        NSLog(@"Skipping: %@", fileName);
    }

    return shouldExtract;
}

- (void)zipArchiveProgressEvent:(unsigned long long)loaded total:(unsigned long long)total {
    float progress = (float)loaded / (float)total;
    NSLog(@"Extraction Progress: %.1f%%", progress * 100);
}

- (void)extractImagesOnlyFrom:(NSString *)zipPath to:(NSString *)destination {
    [SSZipArchive unzipFileAtPath:zipPath
                    toDestination:destination
                         delegate:self];
}

@end
```

### Example 4: Creating Archive with Multiple Sources

**Swift:**
```swift
func createCustomArchive(outputPath: String, password: String?) -> Bool {
    guard let archive = SSZipArchive(path: outputPath) else {
        return false
    }

    archive.open()

    // Add individual files
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    let file1 = documentsPath + "/important.pdf"
    let file2 = documentsPath + "/data.json"

    archive.writeFile(file1, withPassword: password)
    archive.writeFile(file2, withPassword: password)

    // Add data directly
    let configData = """
    {
        "version": "1.0",
        "created": "\(Date())"
    }
    """.data(using: .utf8)!

    archive.write(configData,
                  filename: "config.json",
                  compressionLevel: Z_DEFAULT_COMPRESSION,
                  password: password,
                  aes: true)

    // Add entire folder
    let resourcesPath = Bundle.main.resourcePath! + "/Resources"
    archive.writeFolder(atPath: resourcesPath,
                       withFolderName: "Resources",
                       withPassword: password)

    // Add custom text
    if let textData = "Created by LWZipArchive".data(using: .utf8) {
        archive.write(textData, filename: "README.txt", withPassword: nil)
    }

    archive.close()

    return FileManager.default.fileExists(atPath: outputPath)
}
```

### Example 5: Password Validation Before Extraction

**Objective-C:**
```objective-c
- (void)safelyExtractArchive:(NSString *)zipPath
                  withPassword:(NSString *)password
                 toDestination:(NSString *)destination {
    NSError *error = nil;

    // Check if file is password protected
    BOOL isProtected = [SSZipArchive isFilePasswordProtectedAtPath:zipPath];

    if (isProtected && !password) {
        NSLog(@"Error: Archive is password protected but no password provided");
        return;
    }

    if (isProtected && password) {
        // Verify password before attempting full extraction
        BOOL isValid = [SSZipArchive isPasswordValidForArchiveAtPath:zipPath
                                                            password:password
                                                               error:&error];

        if (!isValid) {
            NSLog(@"Error: Invalid password - %@", error.localizedDescription);
            return;
        }
    }

    // Get uncompressed size to check available space
    NSNumber *payloadSize = [SSZipArchive payloadSizeForArchiveAtPath:zipPath error:&error];
    if (payloadSize) {
        unsigned long long availableSpace = [self getAvailableDiskSpace];
        if (availableSpace < payloadSize.unsignedLongLongValue) {
            NSLog(@"Error: Insufficient disk space. Need %@ bytes, have %llu bytes",
                  payloadSize, availableSpace);
            return;
        }
    }

    // Proceed with extraction
    BOOL success = [SSZipArchive unzipFileAtPath:zipPath
                                   toDestination:destination
                              preserveAttributes:YES
                                       overwrite:YES
                                        password:password
                                           error:&error];

    if (success) {
        NSLog(@"Archive extracted successfully");
    } else {
        NSLog(@"Extraction failed: %@", error.localizedDescription);
    }
}

- (unsigned long long)getAvailableDiskSpace {
    NSDictionary *attributes = [[NSFileManager defaultManager]
                                attributesOfFileSystemForPath:NSHomeDirectory()
                                error:nil];
    return [[attributes objectForKey:NSFileSystemFreeSize] unsignedLongLongValue];
}
```

### Example 6: Batch Processing with Error Recovery

**Swift:**
```swift
class BatchZipper {
    func compressMultipleFolders(folders: [String], outputDirectory: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HHmmss"

        for (index, folderPath) in folders.enumerated() {
            autoreleasepool {
                let folderName = (folderPath as NSString).lastPathComponent
                let timestamp = dateFormatter.string(from: Date())
                let outputPath = (outputDirectory as NSString).appendingPathComponent("\(folderName)_\(timestamp).zip")

                print("[\(index + 1)/\(folders.count)] Compressing: \(folderName)")

                let success = SSZipArchive.createZipFile(
                    atPath: outputPath,
                    withContentsOfDirectory: folderPath,
                    keepParentDirectory: true,
                    compressionLevel: Z_DEFAULT_COMPRESSION,
                    password: nil,
                    aes: false,
                    progressHandler: { entryNumber, total in
                        let progress = Float(entryNumber) / Float(total)
                        if entryNumber % 10 == 0 || entryNumber == total {
                            print("  Progress: \(String(format: "%.1f", progress * 100))%")
                        }
                    }
                )

                if success {
                    // Verify the created archive
                    if FileManager.default.fileExists(atPath: outputPath) {
                        let attributes = try? FileManager.default.attributesOfItem(atPath: outputPath)
                        let fileSize = attributes?[.size] as? UInt64 ?? 0
                        print("  Success! Created: \(outputPath) (\(fileSize) bytes)")
                    }
                } else {
                    print("  Failed to compress: \(folderName)")
                    // Optionally: retry, log to file, or add to failed list
                }
            }
        }
    }
}
```

## API Reference

### Class Methods Overview

#### Compression (Zipping)

- `+ createZipFileAtPath:withFilesAtPaths:` - Create zip from array of file paths
- `+ createZipFileAtPath:withContentsOfDirectory:` - Create zip from directory
- `+ createZipFileAtPath:withContentsOfDirectory:keepParentDirectory:` - Create zip with optional parent directory
- `+ createZipFileAtPath:withFilesAtPaths:withPassword:` - Create password-protected zip from files
- `+ createZipFileAtPath:withContentsOfDirectory:withPassword:` - Create password-protected zip from directory
- `+ createZipFileAtPath:withContentsOfDirectory:keepParentDirectory:withPassword:` - Create password-protected zip with options
- `+ createZipFileAtPath:withContentsOfDirectory:keepParentDirectory:withPassword:andProgressHandler:` - Create zip with progress tracking
- `+ createZipFileAtPath:withContentsOfDirectory:keepParentDirectory:compressionLevel:password:AES:progressHandler:` - Full-featured zip creation with all options

#### Decompression (Unzipping)

- `+ unzipFileAtPath:toDestination:` - Simple unzip
- `+ unzipFileAtPath:toDestination:delegate:` - Unzip with delegate
- `+ unzipFileAtPath:toDestination:overwrite:password:error:` - Unzip with options
- `+ unzipFileAtPath:toDestination:overwrite:password:error:delegate:` - Unzip with options and delegate
- `+ unzipFileAtPath:toDestination:preserveAttributes:overwrite:password:error:delegate:` - Unzip preserving file attributes
- `+ unzipFileAtPath:toDestination:progressHandler:completionHandler:` - Unzip with progress tracking
- `+ unzipFileAtPath:toDestination:overwrite:password:progressHandler:completionHandler:` - Unzip with options and handlers
- `+ unzipFileAtPath:toDestination:preserveAttributes:overwrite:nestedZipLevel:password:error:delegate:progressHandler:completionHandler:` - Full-featured unzip with all options

#### Utility Methods

- `+ isFilePasswordProtectedAtPath:` - Check if archive is password protected
- `+ isPasswordValidForArchiveAtPath:password:error:` - Verify password validity
- `+ payloadSizeForArchiveAtPath:error:` - Get total uncompressed size

### Instance Methods

#### Stream API for Creating Archives

- `- initWithPath:` - Initialize archive for creation
- `- open` - Open archive for writing
- `- writeFile:withPassword:` - Write file to archive
- `- writeFileAtPath:withFileName:withPassword:` - Write file with custom name
- `- writeFileAtPath:withFileName:compressionLevel:password:AES:` - Write file with full options
- `- writeData:filename:withPassword:` - Write data to archive
- `- writeData:filename:compressionLevel:password:AES:` - Write data with full options
- `- writeFolderAtPath:withFolderName:withPassword:` - Write empty folder
- `- close` - Close and finalize archive

### Delegate Protocol (SSZipArchiveDelegate)

- `- zipArchiveWillUnzipArchiveAtPath:zipInfo:` - Called before unzipping begins
- `- zipArchiveDidUnzipArchiveAtPath:zipInfo:unzippedPath:` - Called after unzipping completes
- `- zipArchiveShouldUnzipFileAtIndex:totalFiles:archivePath:fileInfo:` - Called to determine if file should be unzipped (return NO to skip)
- `- zipArchiveWillUnzipFileAtIndex:totalFiles:archivePath:fileInfo:` - Called before unzipping each file
- `- ssZipArchiveDidUnzipFileAtIndex:totalFiles:archivePath:fileInfo:` - Called after unzipping each file
- `- ssZipArchiveDidUnzipFileAtIndex:totalFiles:archivePath:unzippedFilePath:` - Called after unzipping each file with path
- `- ssZipArchiveProgressEvent:total:` - Called during unzip operation with byte progress

### Error Codes

- `SSZipArchiveErrorCodeFailedOpenZipFile` (-1) - Failed to open zip file
- `SSZipArchiveErrorCodeFailedOpenFileInZip` (-2) - Failed to open file in zip
- `SSZipArchiveErrorCodeFileInfoNotLoadable` (-3) - File info not loadable
- `SSZipArchiveErrorCodeFileContentNotReadable` (-4) - File content not readable
- `SSZipArchiveErrorCodeFailedToWriteFile` (-5) - Failed to write file
- `SSZipArchiveErrorCodeInvalidArguments` (-6) - Invalid arguments

### Constants

- Compression levels: Use standard zlib constants (0-9)
  - `Z_NO_COMPRESSION` (0)
  - `Z_BEST_SPEED` (1)
  - `Z_DEFAULT_COMPRESSION` (-1)
  - `Z_BEST_COMPRESSION` (9)

## Encryption & Security

### Encryption Types

LWZipArchive supports two types of password protection:

1. **AES-256 Encryption** (`AES:YES`):
   - Industry-standard strong encryption
   - Provides maximum security for sensitive data
   - Not compatible with some native tools (macOS Archive Utility, Windows Explorer's built-in unzip)
   - Compatible with: 7-Zip, WinZip, The Unarchiver, and most modern zip tools
   - **Recommended for:** Sensitive data, backups containing personal information

2. **Standard ZIP 2.0 Encryption** (`AES:NO`):
   - Traditional ZIP encryption (ZipCrypto)
   - Less secure but universally compatible
   - Works with all zip tools including macOS Finder and Windows Explorer
   - **Recommended for:** General-purpose archives that need broad compatibility

### Security Best Practices

```objective-c
// GOOD: AES encryption for sensitive data
[SSZipArchive createZipFileAtPath:zipPath
          withContentsOfDirectory:documentsPath
              keepParentDirectory:YES
                 compressionLevel:Z_DEFAULT_COMPRESSION
                         password:@"strong_password_123!"
                              AES:YES  // Maximum security
                  progressHandler:nil];

// GOOD: Standard encryption for compatibility
[SSZipArchive createZipFileAtPath:zipPath
          withContentsOfDirectory:documentsPath
              keepParentDirectory:YES
                 compressionLevel:Z_DEFAULT_COMPRESSION
                         password:@"password"
                              AES:NO  // Universal compatibility
                  progressHandler:nil];

// AVOID: Weak passwords
// Use strong passwords with mixed case, numbers, and symbols
```

### Password Management Tips

- Use strong passwords (minimum 12 characters, mixed case, numbers, symbols)
- Store passwords securely using Keychain Services
- Never hardcode passwords in your source code
- Consider using password derivation functions (PBKDF2) for user-provided passwords
- Implement password strength validation in your UI

### Checking Archive Security

```objective-c
// Check if archive is password protected
BOOL isProtected = [SSZipArchive isFilePasswordProtectedAtPath:zipPath];

// Validate password before full extraction
NSError *error = nil;
BOOL isValid = [SSZipArchive isPasswordValidForArchiveAtPath:zipPath
                                                    password:userPassword
                                                       error:&error];
if (!isValid) {
    NSLog(@"Invalid password: %@", error.localizedDescription);
}
```

## Best Practices

### Performance Optimization

1. **Background Threading**
   ```swift
   // Always perform compression/decompression on background thread
   DispatchQueue.global(qos: .userInitiated).async {
       let success = SSZipArchive.createZipFile(atPath: outputPath,
                                                withContentsOfDirectory: sourcePath)
       DispatchQueue.main.async {
           // Update UI
       }
   }
   ```

2. **Choose Appropriate Compression Levels**
   - `Z_NO_COMPRESSION` (0): Already compressed files (images, videos)
   - `Z_BEST_SPEED` (1): Large files where speed is critical
   - `Z_DEFAULT_COMPRESSION` (-1): General purpose (recommended)
   - `Z_BEST_COMPRESSION` (9): Text files, code, where size matters

3. **Memory Management**
   ```swift
   // For batch operations, use autoreleasepool
   for zipFile in zipFiles {
       autoreleasepool {
           SSZipArchive.unzipFile(atPath: zipFile, toDestination: destination)
       }
   }
   ```

### Error Handling

Always handle errors properly:

```objective-c
NSError *error = nil;
BOOL success = [SSZipArchive unzipFileAtPath:zipPath
                                toDestination:destination
                                    overwrite:YES
                                     password:password
                                        error:&error];

if (!success) {
    switch (error.code) {
        case SSZipArchiveErrorCodeFailedOpenZipFile:
            NSLog(@"File not found or corrupted");
            break;
        case SSZipArchiveErrorCodeFailedToWriteFile:
            NSLog(@"Insufficient disk space or permissions");
            break;
        case SSZipArchiveErrorCodeInvalidArguments:
            NSLog(@"Invalid file path or parameters");
            break;
        default:
            NSLog(@"Error: %@", error.localizedDescription);
    }
}
```

### Progress Tracking Best Practices

```swift
// Update UI on main thread, but not too frequently
var lastUpdate: Date = Date()

SSZipArchive.createZipFile(
    atPath: outputPath,
    withContentsOfDirectory: sourcePath,
    keepParentDirectory: true,
    compressionLevel: Z_DEFAULT_COMPRESSION,
    password: nil,
    aes: false,
    progressHandler: { entryNumber, total in
        let now = Date()
        // Throttle updates to every 0.1 seconds
        if now.timeIntervalSince(lastUpdate) > 0.1 {
            lastUpdate = now
            DispatchQueue.main.async {
                let progress = Float(entryNumber) / Float(total)
                // Update progress bar
            }
        }
    }
)
```

### Resource Management

```objective-c
// Clean up temporary files after operations
- (void)cleanupTemporaryFiles {
    NSString *tempDir = NSTemporaryDirectory();
    NSArray *tempFiles = [[NSFileManager defaultManager]
                          contentsOfDirectoryAtPath:tempDir error:nil];

    for (NSString *file in tempFiles) {
        if ([file.pathExtension isEqualToString:@"zip"]) {
            NSString *fullPath = [tempDir stringByAppendingPathComponent:file];
            [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
        }
    }
}
```

### Testing Recommendations

1. Test with various file types and sizes
2. Test password protection with both AES and standard encryption
3. Test error scenarios (insufficient disk space, invalid passwords, corrupted archives)
4. Test with Unicode filenames and special characters
5. Verify extracted files maintain original attributes
6. Test cancellation and interruption scenarios

## Troubleshooting

### Common Issues

**Q: Why can't macOS Finder open my password-protected ZIP?**
A: macOS Finder doesn't support AES-256 encrypted ZIPs. Use `AES:NO` when creating the archive, or use a third-party tool like The Unarchiver to open it.

**Q: The extracted files have incorrect dates/permissions**
A: Use `preserveAttributes:YES` when extracting to maintain original file metadata.

**Q: Compression is slow for large files**
A:
- Run compression on a background thread
- Use `Z_BEST_SPEED` or `Z_NO_COMPRESSION` for already-compressed files (images, videos)
- Consider using the stream API to add files incrementally

**Q: How do I handle Chinese or Unicode filenames?**
A: LWZipArchive automatically handles UTF-8 encoding for filenames. Ensure your source files use UTF-8 encoding.

**Q: Can I cancel an in-progress operation?**
A: Implement the delegate method `zipArchiveShouldUnzipFileAtIndex:` and return `NO` to stop extraction. For compression, currently there's no built-in cancellation mechanism.

**Q: Why is my compressed file larger than the original?**
A: Some files (images, videos, PDFs) are already compressed. Re-compressing them can actually increase size. Use `Z_NO_COMPRESSION` for these file types.

## Architecture

LWZipArchive is built on proven, industry-standard technologies:

| Component | Purpose | License |
|-----------|---------|---------|
| **minizip** | Core ZIP file operations (C library) | Zlib License |
| **zlib** | Compression and decompression algorithms | Zlib License |
| **Security.framework** | AES-256 encryption support | Apple |
| **iconv** | Character encoding conversion for international filenames | LGPL |

### Why LWZipArchive?

- **Reliability**: Based on SSZipArchive, trusted by thousands of production apps
- **Performance**: Optimized C libraries for fast compression/decompression
- **Security**: Industry-standard AES-256 encryption
- **Compatibility**: Works seamlessly across all Apple platforms
- **Maintained**: Active development and community support

## License

LWZipArchive is released under the **MIT License**.

```
Copyright (c) 2010-2015, Sam Soffes
Copyright (c) 2015-present, SSZipArchive Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

### Third-Party Licenses

- **Minizip**: [Zlib License](https://www.zlib.net/zlib_license.html)
- **zlib**: [Zlib License](https://www.zlib.net/zlib_license.html)

## Credits

LWZipArchive is built on the excellent [SSZipArchive](https://github.com/ZipArchive/ZipArchive) project. We are grateful to:

| Contributor | Contribution |
|-------------|--------------|
| **aish** | Created the original [ZipArchive](https://code.google.com/archive/p/ziparchive/) that inspired this project |
| **[@soffes](https://github.com/soffes)** | Created SSZipArchive |
| **[@randomsequence](https://github.com/randomsequence)** | Implemented archive creation support |
| **[@johnezang](https://github.com/johnezang)** | Extensive contributions and support |
| **[@nmoinvaz](https://github.com/nmoinvaz)** | Maintains minizip, the core library |
| **[All Contributors](https://github.com/ZipArchive/ZipArchive/graphs/contributors)** | Continuous improvements and bug fixes |

## Contributing

We welcome contributions! Here's how you can help:

### How to Contribute

1. **Fork the Repository**
   ```bash
   git clone https://github.com/ZipArchive/ZipArchive.git
   cd ZipArchive
   ```

2. **Create a Feature Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Your Changes**
   - Write clean, well-documented code
   - Follow the existing code style
   - Add tests for new features
   - Update documentation as needed

4. **Test Your Changes**
   - Open the Xcode project
   - Run all tests to ensure nothing breaks
   - Test on multiple platforms if possible

5. **Submit a Pull Request**
   - Push your changes to your fork
   - Create a pull request with a clear description
   - Reference any related issues

### Reporting Issues

Found a bug? Have a feature request?

- **Search Existing Issues**: Check if it's already reported
- **Provide Details**: Include OS version, Xcode version, and reproducible steps
- **Sample Code**: Minimal reproducible example helps tremendously

## Support

### Documentation

- **This README**: Comprehensive guide and examples
- **Inline Documentation**: See header files for detailed API documentation
- **Chinese Documentation**: [中文版文档](./README_ZH.md)

### Resources

- **GitHub Repository**: [ZipArchive/ZipArchive](https://github.com/ZipArchive/ZipArchive)
- **Issue Tracker**: [GitHub Issues](https://github.com/ZipArchive/ZipArchive/issues)
- **CocoaPods**: [SSZipArchive Pod](https://cocoapods.org/pods/SSZipArchive)
- **Stack Overflow**: Tag your questions with `ssziparchive`

### Community

- Report bugs through [GitHub Issues](https://github.com/ZipArchive/ZipArchive/issues)
- Discuss features and ask questions in [Discussions](https://github.com/ZipArchive/ZipArchive/discussions)
- Follow updates on the [release page](https://github.com/ZipArchive/ZipArchive/releases)

---

<div align="center">

**Made with ❤️ for the iOS/macOS development community**

[⬆ Back to Top](#lwziparchive)

</div>
