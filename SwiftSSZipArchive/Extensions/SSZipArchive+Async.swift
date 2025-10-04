//
//  SSZipArchive+Async.swift
//  SwiftSSZipArchive
//
//  Async/await extensions for SSZipArchive
//  Copyright (c) 2024. All rights reserved.
//

import Foundation

// MARK: - Async/Await Extensions

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SSZipArchive {

    /// Async unzip operation
    /// - Parameters:
    ///   - path: Path to zip file
    ///   - destination: Destination directory
    ///   - password: Optional password
    /// - Returns: true if successful
    /// - Throws: Error if unzip fails
    public static func unzipFileAsync(
        atPath path: String,
        toDestination destination: String,
        password: String? = nil
    ) async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            var error: Error?

            let success = SSZipArchive.unzipFile(
                atPath: path,
                toDestination: destination,
                preserveAttributes: true,
                overwrite: true,
                password: password,
                delegate: nil,
                progressHandler: nil
            ) { _, succeeded, resultError in
                if let resultError = resultError {
                    error = resultError
                }
                if succeeded {
                    continuation.resume(returning: true)
                } else {
                    continuation.resume(throwing: error ?? SSZipArchiveError.failedOpenZipFile)
                }
            }

            if !success {
                continuation.resume(throwing: error ?? SSZipArchiveError.failedOpenZipFile)
            }
        }
    }

    /// Async zip creation
    /// - Parameters:
    ///   - path: Destination zip file path
    ///   - directoryPath: Source directory
    ///   - keepParentDirectory: Whether to keep parent directory
    ///   - password: Optional password
    /// - Returns: true if successful
    public static func createZipFileAsync(
        atPath path: String,
        withContentsOfDirectory directoryPath: String,
        keepParentDirectory: Bool = false,
        password: String? = nil
    ) async -> Bool {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let success = SSZipArchive.createZipFile(
                    atPath: path,
                    withContentsOfDirectory: directoryPath,
                    keepParentDirectory: keepParentDirectory,
                    withPassword: password
                )
                continuation.resume(returning: success)
            }
        }
    }

    /// Async unzip with progress
    /// - Parameters:
    ///   - path: Path to zip file
    ///   - destination: Destination directory
    ///   - password: Optional password
    ///   - progress: Progress callback
    /// - Returns: true if successful
    /// - Throws: Error if unzip fails
    public static func unzipFileAsync(
        atPath path: String,
        toDestination destination: String,
        password: String? = nil,
        progress: @escaping (Double) -> Void
    ) async throws -> Bool {
        return try await withCheckedThrowingContinuation { continuation in
            var error: Error?
            var totalFiles: Int = 0

            let success = SSZipArchive.unzipFile(
                atPath: path,
                toDestination: destination,
                preserveAttributes: true,
                overwrite: true,
                password: password,
                delegate: nil,
                progressHandler: { _, _, entryNumber, total in
                    totalFiles = total
                    let progressValue = Double(entryNumber) / Double(total)
                    DispatchQueue.main.async {
                        progress(progressValue)
                    }
                }
            ) { _, succeeded, resultError in
                if let resultError = resultError {
                    error = resultError
                }
                if succeeded {
                    continuation.resume(returning: true)
                } else {
                    continuation.resume(throwing: error ?? SSZipArchiveError.failedOpenZipFile)
                }
            }

            if !success {
                continuation.resume(throwing: error ?? SSZipArchiveError.failedOpenZipFile)
            }
        }
    }

    /// Async zip creation with progress
    /// - Parameters:
    ///   - path: Destination zip file path
    ///   - directoryPath: Source directory
    ///   - keepParentDirectory: Whether to keep parent directory
    ///   - password: Optional password
    ///   - progress: Progress callback
    /// - Returns: true if successful
    public static func createZipFileAsync(
        atPath path: String,
        withContentsOfDirectory directoryPath: String,
        keepParentDirectory: Bool = false,
        password: String? = nil,
        progress: @escaping (Double) -> Void
    ) async -> Bool {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let success = SSZipArchive.createZipFile(
                    atPath: path,
                    withContentsOfDirectory: directoryPath,
                    keepParentDirectory: keepParentDirectory,
                    compressionLevel: -1,
                    password: password,
                    aes: true
                ) { current, total in
                    let progressValue = Double(current) / Double(total)
                    DispatchQueue.main.async {
                        progress(progressValue)
                    }
                }
                continuation.resume(returning: success)
            }
        }
    }
}
