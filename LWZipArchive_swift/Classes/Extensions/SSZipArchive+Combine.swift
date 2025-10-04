//
//  SSZipArchive+Combine.swift
//  SwiftSSZipArchive
//
//  Combine extensions for SSZipArchive
//  Copyright (c) 2024. All rights reserved.
//

import Foundation
import Combine

// MARK: - Combine Extensions

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SSZipArchive {

    /// Zip operation progress
    public struct ZipProgress {
        public let current: Int
        public let total: Int
        public var percentage: Double {
            guard total > 0 else { return 0 }
            return Double(current) / Double(total)
        }
    }

    /// Unzip operation progress
    public struct UnzipProgress {
        public let entry: String
        public let fileInfo: ZipFileInfo
        public let current: Int
        public let total: Int
        public var percentage: Double {
            guard total > 0 else { return 0 }
            return Double(current) / Double(total)
        }
    }

    /// Publisher for unzip operation
    /// - Parameters:
    ///   - path: Path to zip file
    ///   - destination: Destination directory
    ///   - password: Optional password
    /// - Returns: Publisher that emits progress and completion
    public static func unzipFilePublisher(
        atPath path: String,
        toDestination destination: String,
        password: String? = nil
    ) -> AnyPublisher<UnzipProgress, Error> {
        let subject = PassthroughSubject<UnzipProgress, Error>()

        DispatchQueue.global(qos: .userInitiated).async {
            let success = SSZipArchive.unzipFile(
                atPath: path,
                toDestination: destination,
                preserveAttributes: true,
                overwrite: true,
                password: password,
                delegate: nil,
                progressHandler: { entry, fileInfo, current, total in
                    let progress = UnzipProgress(
                        entry: entry,
                        fileInfo: fileInfo,
                        current: current,
                        total: total
                    )
                    subject.send(progress)
                }
            ) { _, succeeded, error in
                if let error = error {
                    subject.send(completion: .failure(error))
                } else if succeeded {
                    subject.send(completion: .finished)
                } else {
                    subject.send(completion: .failure(SSZipArchiveError.failedOpenZipFile))
                }
            }

            if !success {
                subject.send(completion: .failure(SSZipArchiveError.failedOpenZipFile))
            }
        }

        return subject.eraseToAnyPublisher()
    }

    /// Publisher for zip creation
    /// - Parameters:
    ///   - path: Destination zip file path
    ///   - directoryPath: Source directory
    ///   - keepParentDirectory: Whether to keep parent directory
    ///   - password: Optional password
    /// - Returns: Publisher that emits progress and completion
    public static func createZipFilePublisher(
        atPath path: String,
        withContentsOfDirectory directoryPath: String,
        keepParentDirectory: Bool = false,
        password: String? = nil
    ) -> AnyPublisher<ZipProgress, Error> {
        let subject = PassthroughSubject<ZipProgress, Error>()

        DispatchQueue.global(qos: .userInitiated).async {
            let success = SSZipArchive.createZipFile(
                atPath: path,
                withContentsOfDirectory: directoryPath,
                keepParentDirectory: keepParentDirectory,
                compressionLevel: -1,
                password: password,
                aes: true
            ) { current, total in
                let progress = ZipProgress(current: Int(current), total: Int(total))
                subject.send(progress)
            }

            if success {
                subject.send(completion: .finished)
            } else {
                subject.send(completion: .failure(SSZipArchiveError.failedOpenZipFile))
            }
        }

        return subject.eraseToAnyPublisher()
    }

    /// Simple unzip publisher without progress
    /// - Parameters:
    ///   - path: Path to zip file
    ///   - destination: Destination directory
    ///   - password: Optional password
    /// - Returns: Publisher that completes on success or fails with error
    public static func unzipFileSimplePublisher(
        atPath path: String,
        toDestination destination: String,
        password: String? = nil
    ) -> Future<Bool, Error> {
        return Future { promise in
            DispatchQueue.global(qos: .userInitiated).async {
                let success = SSZipArchive.unzipFile(
                    atPath: path,
                    toDestination: destination,
                    preserveAttributes: true,
                    overwrite: true,
                    password: password,
                    delegate: nil,
                    progressHandler: nil
                ) { _, succeeded, error in
                    if let error = error {
                        promise(.failure(error))
                    } else if succeeded {
                        promise(.success(true))
                    } else {
                        promise(.failure(SSZipArchiveError.failedOpenZipFile))
                    }
                }

                if !success {
                    promise(.failure(SSZipArchiveError.failedOpenZipFile))
                }
            }
        }
    }

    /// Simple zip creation publisher
    /// - Parameters:
    ///   - path: Destination zip file path
    ///   - directoryPath: Source directory
    ///   - password: Optional password
    /// - Returns: Publisher that completes on success or fails with error
    public static func createZipFileSimplePublisher(
        atPath path: String,
        withContentsOfDirectory directoryPath: String,
        password: String? = nil
    ) -> Future<Bool, Never> {
        return Future { promise in
            DispatchQueue.global(qos: .userInitiated).async {
                let success = SSZipArchive.createZipFile(
                    atPath: path,
                    withContentsOfDirectory: directoryPath,
                    keepParentDirectory: false,
                    withPassword: password
                )
                promise(.success(success))
            }
        }
    }
}
