//
//  ZipArchiveDelegate.swift
//  SwiftSSZipArchive
//
//  Swift implementation of SSZipArchive
//  Copyright (c) 2024. All rights reserved.
//

import Foundation

// MARK: - Delegate Protocol

/// Delegate protocol for SSZipArchive operations
public protocol SSZipArchiveDelegate: AnyObject {
    /// Called when the archive will be unzipped
    /// - Parameters:
    ///   - path: Path to the archive
    ///   - zipInfo: Global information about the zip file
    func zipArchiveWillUnzipArchive(atPath path: String, zipInfo: ZipGlobalInfo)

    /// Called when the archive has been unzipped
    /// - Parameters:
    ///   - path: Path to the archive
    ///   - zipInfo: Global information about the zip file
    ///   - unzippedPath: Path where files were unzipped
    func zipArchiveDidUnzipArchive(atPath path: String, zipInfo: ZipGlobalInfo, unzippedPath: String)

    /// Determines whether a file should be unzipped
    /// - Parameters:
    ///   - fileIndex: Index of the file
    ///   - totalFiles: Total number of files
    ///   - archivePath: Path to the archive
    ///   - fileInfo: Information about the file
    /// - Returns: true if the file should be unzipped, false otherwise
    func zipArchiveShouldUnzipFile(
        atIndex fileIndex: Int,
        totalFiles: Int,
        archivePath: String,
        fileInfo: ZipFileInfo
    ) -> Bool

    /// Called when a file will be unzipped
    /// - Parameters:
    ///   - fileIndex: Index of the file
    ///   - totalFiles: Total number of files
    ///   - archivePath: Path to the archive
    ///   - fileInfo: Information about the file
    func zipArchiveWillUnzipFile(
        atIndex fileIndex: Int,
        totalFiles: Int,
        archivePath: String,
        fileInfo: ZipFileInfo
    )

    /// Called when a file has been unzipped
    /// - Parameters:
    ///   - fileIndex: Index of the file
    ///   - totalFiles: Total number of files
    ///   - archivePath: Path to the archive
    ///   - fileInfo: Information about the file
    func zipArchiveDidUnzipFile(
        atIndex fileIndex: Int,
        totalFiles: Int,
        archivePath: String,
        fileInfo: ZipFileInfo
    )

    /// Called when a file has been unzipped with file path
    /// - Parameters:
    ///   - fileIndex: Index of the file
    ///   - totalFiles: Total number of files
    ///   - archivePath: Path to the archive
    ///   - unzippedFilePath: Path to the unzipped file
    func zipArchiveDidUnzipFile(
        atIndex fileIndex: Int,
        totalFiles: Int,
        archivePath: String,
        unzippedFilePath: String
    )

    /// Progress event during zip/unzip operations
    /// - Parameters:
    ///   - loaded: Bytes loaded so far
    ///   - total: Total bytes
    func zipArchiveProgressEvent(loaded: UInt64, total: UInt64)
}

// MARK: - Default Implementations

public extension SSZipArchiveDelegate {
    func zipArchiveWillUnzipArchive(atPath path: String, zipInfo: ZipGlobalInfo) {}
    func zipArchiveDidUnzipArchive(atPath path: String, zipInfo: ZipGlobalInfo, unzippedPath: String) {}
    func zipArchiveShouldUnzipFile(atIndex fileIndex: Int, totalFiles: Int, archivePath: String, fileInfo: ZipFileInfo) -> Bool { true }
    func zipArchiveWillUnzipFile(atIndex fileIndex: Int, totalFiles: Int, archivePath: String, fileInfo: ZipFileInfo) {}
    func zipArchiveDidUnzipFile(atIndex fileIndex: Int, totalFiles: Int, archivePath: String, fileInfo: ZipFileInfo) {}
    func zipArchiveDidUnzipFile(atIndex fileIndex: Int, totalFiles: Int, archivePath: String, unzippedFilePath: String) {}
    func zipArchiveProgressEvent(loaded: UInt64, total: UInt64) {}
}
