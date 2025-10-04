Pod::Spec.new do |s|
  s.name         = 'LWZipArchive_swift'
  s.version      = '2.2.3'
  s.summary      = 'Swift version of LWZipArchive - Modern utility for zipping and unzipping files'
  s.description  = <<-DESC
LWZipArchive_swift is a modern Swift rewrite of the SSZipArchive library.
It provides a comprehensive API for zipping and unzipping files on iOS,
tvOS, watchOS, and macOS with the following features:

- Swift-native API with Result types and modern error handling
- Async/await support for iOS 13.0+
- Combine publisher support for reactive programming
- SwiftUI views for zip operations with progress tracking
- AES and PKWARE encryption support
- Progress reporting and cancellation support
- Thread-safe operations

This Swift version provides a more idiomatic API for Swift and SwiftUI
applications while maintaining compatibility with the underlying C library.
                   DESC

  s.homepage     = 'https://github.com/ZipArchive/ZipArchive'
  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.authors      = { 'Sam Soffes' => 'sam@soff.es', 'Joshua Hudson' => nil, 'Antoine Cœur' => nil }
  s.source       = { :git => 'https://github.com/ZipArchive/ZipArchive.git', :tag => "swift-v#{s.version}" }

  s.ios.deployment_target = '13.0'
  s.tvos.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'
  s.watchos.deployment_target = '6.0'

  s.swift_version = '5.0'

  # Swift source files
  s.source_files = 'LWZipArchive_swift/Classes/**/*.swift'

  # Still need the underlying C implementation
  s.dependency 'LWZipArchive', '~> 2.2'

  s.frameworks = 'Foundation'

  s.pod_target_xcconfig = {
    'SWIFT_VERSION' => '5.0'
  }
end
