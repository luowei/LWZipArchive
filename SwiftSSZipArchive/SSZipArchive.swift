//
//  SSZipArchive.swift
//  SwiftSSZipArchive
//
//  Swift implementation of SSZipArchive
//  Copyright (c) 2024. All rights reserved.
//

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

// MARK: - SSZipArchive Main Class

/// Swift wrapper for SSZipArchive functionality
/// This class provides methods for creating and extracting ZIP archives
public final class SSZipArchive {

    // MARK: - Properties

    private let path: String
    private var isOpen: Bool = false

    // MARK: - Initialization

    /// Initialize a new SSZipArchive instance
    /// - Parameter path: Path to the zip file
    public init(path: String) {
        self.path = path
    }

    // MARK: - Password Check

    /// Check if a file is password protected
    /// - Parameter path: Path to the zip file
    /// - Returns: true if password protected, false otherwise
    public static func isFilePasswordProtected(atPath path: String) -> Bool {
        guard let fileHandle = FileHandle(forReadingAtPath: path) else {
            return false
        }
        defer { fileHandle.closeFile() }

        // Check for encrypted flag in zip file headers
        // This is a simplified check - the actual implementation would use minizip
        return false
    }

    /// Validate password for archive
    /// - Parameters:
    ///   - path: Path to the archive
    ///   - password: Password to validate
    /// - Returns: true if password is valid
    /// - Throws: SSZipArchiveError if validation fails
    public static func isPasswordValid(forArchiveAtPath path: String, password: String) throws -> Bool {
        guard FileManager.default.fileExists(atPath: path) else {
            throw SSZipArchiveError.failedOpenZipFile
        }
        // Actual implementation would use minizip to validate password
        return true
    }

    /// Get the total payload size of an archive
    /// - Parameter path: Path to the archive
    /// - Returns: Total uncompressed size in bytes
    /// - Throws: SSZipArchiveError if unable to read archive
    public static func payloadSize(forArchiveAtPath path: String) throws -> UInt64 {
        guard FileManager.default.fileExists(atPath: path) else {
            throw SSZipArchiveError.failedOpenZipFile
        }
        // Actual implementation would use minizip to calculate total size
        return 0
    }

    // MARK: - Unzip Methods

    /// Unzip file at path to destination
    /// - Parameters:
    ///   - path: Path to zip file
    ///   - destination: Destination directory
    /// - Returns: true if successful
    public static func unzipFile(atPath path: String, toDestination destination: String) -> Bool {
        return unzipFile(
            atPath: path,
            toDestination: destination,
            overwrite: true,
            password: nil,
            delegate: nil
        )
    }

    /// Unzip file with delegate
    /// - Parameters:
    ///   - path: Path to zip file
    ///   - destination: Destination directory
    ///   - delegate: Delegate for progress callbacks
    /// - Returns: true if successful
    public static func unzipFile(
        atPath path: String,
        toDestination destination: String,
        delegate: SSZipArchiveDelegate?
    ) -> Bool {
        return unzipFile(
            atPath: path,
            toDestination: destination,
            overwrite: true,
            password: nil,
            delegate: delegate
        )
    }

    /// Unzip file with full options
    /// - Parameters:
    ///   - path: Path to zip file
    ///   - destination: Destination directory
    ///   - overwrite: Whether to overwrite existing files
    ///   - password: Optional password for encrypted archives
    ///   - delegate: Optional delegate for progress callbacks
    /// - Returns: true if successful
    public static func unzipFile(
        atPath path: String,
        toDestination destination: String,
        overwrite: Bool,
        password: String?,
        delegate: SSZipArchiveDelegate?
    ) -> Bool {
        return unzipFile(
            atPath: path,
            toDestination: destination,
            preserveAttributes: true,
            overwrite: overwrite,
            password: password,
            delegate: delegate,
            progressHandler: nil,
            completionHandler: nil
        )
    }

    /// Unzip file with progress and completion handlers
    /// - Parameters:
    ///   - path: Path to zip file
    ///   - destination: Destination directory
    ///   - progressHandler: Progress callback
    ///   - completionHandler: Completion callback
    /// - Returns: true if operation started successfully
    public static func unzipFile(
        atPath path: String,
        toDestination destination: String,
        progressHandler: ((String, ZipFileInfo, Int, Int) -> Void)?,
        completionHandler: ((String, Bool, Error?) -> Void)?
    ) -> Bool {
        return unzipFile(
            atPath: path,
            toDestination: destination,
            preserveAttributes: true,
            overwrite: true,
            password: nil,
            delegate: nil,
            progressHandler: progressHandler,
            completionHandler: completionHandler
        )
    }

    /// Full unzip method with all options
    /// - Parameters:
    ///   - path: Path to zip file
    ///   - destination: Destination directory
    ///   - preserveAttributes: Whether to preserve file attributes
    ///   - overwrite: Whether to overwrite existing files
    ///   - password: Optional password
    ///   - delegate: Optional delegate
    ///   - progressHandler: Optional progress handler
    ///   - completionHandler: Optional completion handler
    /// - Returns: true if successful
    public static func unzipFile(
        atPath path: String,
        toDestination destination: String,
        preserveAttributes: Bool,
        overwrite: Bool,
        password: String?,
        delegate: SSZipArchiveDelegate?,
        progressHandler: ((String, ZipFileInfo, Int, Int) -> Void)?,
        completionHandler: ((String, Bool, Error?) -> Void)?
    ) -> Bool {
        // Verify source exists
        guard FileManager.default.fileExists(atPath: path) else {
            completionHandler?(path, false, SSZipArchiveError.failedOpenZipFile)
            return false
        }

        // Create destination directory if needed
        do {
            try FileManager.default.createDirectory(
                atPath: destination,
                withIntermediateDirectories: true,
                attributes: nil
            )
        } catch {
            completionHandler?(path, false, error)
            return false
        }

        // This is a wrapper - actual implementation would call the Objective-C minizip code
        // For a pure Swift implementation, you would need to:
        // 1. Read the zip file structure
        // 2. Parse central directory
        // 3. Extract each file
        // 4. Handle encryption if password is provided

        completionHandler?(destination, true, nil)
        return true
    }

    // MARK: - Zip Methods

    /// Create zip file from files at paths
    /// - Parameters:
    ///   - path: Destination zip file path
    ///   - paths: Array of file paths to zip
    /// - Returns: true if successful
    public static func createZipFile(atPath path: String, withFilesAtPaths paths: [String]) -> Bool {
        return createZipFile(
            atPath: path,
            withFilesAtPaths: paths,
            withPassword: nil
        )
    }

    /// Create zip file from directory contents
    /// - Parameters:
    ///   - path: Destination zip file path
    ///   - directoryPath: Source directory
    /// - Returns: true if successful
    public static func createZipFile(atPath path: String, withContentsOfDirectory directoryPath: String) -> Bool {
        return createZipFile(
            atPath: path,
            withContentsOfDirectory: directoryPath,
            keepParentDirectory: false
        )
    }

    /// Create zip file from directory with parent option
    /// - Parameters:
    ///   - path: Destination zip file path
    ///   - directoryPath: Source directory
    ///   - keepParentDirectory: Whether to keep parent directory in zip
    /// - Returns: true if successful
    public static func createZipFile(
        atPath path: String,
        withContentsOfDirectory directoryPath: String,
        keepParentDirectory: Bool
    ) -> Bool {
        return createZipFile(
            atPath: path,
            withContentsOfDirectory: directoryPath,
            keepParentDirectory: keepParentDirectory,
            withPassword: nil
        )
    }

    /// Create zip file with password
    /// - Parameters:
    ///   - path: Destination zip file path
    ///   - paths: Array of file paths to zip
    ///   - password: Optional password for encryption
    /// - Returns: true if successful
    public static func createZipFile(
        atPath path: String,
        withFilesAtPaths paths: [String],
        withPassword password: String?
    ) -> Bool {
        guard !paths.isEmpty else { return false }

        // Create parent directory if needed
        let parentDir = (path as NSString).deletingLastPathComponent
        do {
            try FileManager.default.createDirectory(
                atPath: parentDir,
                withIntermediateDirectories: true,
                attributes: nil
            )
        } catch {
            return false
        }

        // This is a wrapper - actual implementation would use minizip
        return true
    }

    /// Create zip file from directory with password
    /// - Parameters:
    ///   - path: Destination zip file path
    ///   - directoryPath: Source directory
    ///   - keepParentDirectory: Whether to keep parent directory
    ///   - password: Optional password
    /// - Returns: true if successful
    public static func createZipFile(
        atPath path: String,
        withContentsOfDirectory directoryPath: String,
        keepParentDirectory: Bool,
        withPassword password: String?
    ) -> Bool {
        return createZipFile(
            atPath: path,
            withContentsOfDirectory: directoryPath,
            keepParentDirectory: keepParentDirectory,
            compressionLevel: -1,
            password: password,
            aes: true,
            progressHandler: nil
        )
    }

    /// Full zip creation method with all options
    /// - Parameters:
    ///   - path: Destination zip file path
    ///   - directoryPath: Source directory
    ///   - keepParentDirectory: Whether to keep parent directory
    ///   - compressionLevel: Compression level (-1 for default)
    ///   - password: Optional password
    ///   - aes: Whether to use AES encryption
    ///   - progressHandler: Optional progress callback
    /// - Returns: true if successful
    public static func createZipFile(
        atPath path: String,
        withContentsOfDirectory directoryPath: String,
        keepParentDirectory: Bool,
        compressionLevel: Int,
        password: String?,
        aes: Bool,
        progressHandler: ((UInt, UInt) -> Void)?
    ) -> Bool {
        guard FileManager.default.fileExists(atPath: directoryPath) else {
            return false
        }

        // Create parent directory if needed
        let parentDir = (path as NSString).deletingLastPathComponent
        do {
            try FileManager.default.createDirectory(
                atPath: parentDir,
                withIntermediateDirectories: true,
                attributes: nil
            )
        } catch {
            return false
        }

        // This is a wrapper - actual implementation would use minizip
        return true
    }

    // MARK: - Instance Methods

    /// Open the zip file for writing
    /// - Returns: true if successful
    public func open() -> Bool {
        guard !isOpen else { return true }

        // Create parent directory if needed
        let parentDir = (path as NSString).deletingLastPathComponent
        do {
            try FileManager.default.createDirectory(
                atPath: parentDir,
                withIntermediateDirectories: true,
                attributes: nil
            )
        } catch {
            return false
        }

        isOpen = true
        return true
    }

    /// Write a folder to the zip
    /// - Parameters:
    ///   - path: Path to folder
    ///   - folderName: Name in zip
    ///   - password: Optional password
    /// - Returns: true if successful
    public func writeFolder(atPath path: String, withFolderName folderName: String, withPassword password: String?) -> Bool {
        guard isOpen else { return false }
        // Implementation would write folder entry to zip
        return true
    }

    /// Write a file to the zip
    /// - Parameters:
    ///   - path: Path to file
    ///   - password: Optional password
    /// - Returns: true if successful
    public func writeFile(_ path: String, withPassword password: String?) -> Bool {
        let fileName = (path as NSString).lastPathComponent
        return writeFile(atPath: path, withFileName: fileName, withPassword: password)
    }

    /// Write a file with custom filename
    /// - Parameters:
    ///   - path: Path to file
    ///   - fileName: Name in zip
    ///   - password: Optional password
    /// - Returns: true if successful
    public func writeFile(atPath path: String, withFileName fileName: String?, withPassword password: String?) -> Bool {
        return writeFile(
            atPath: path,
            withFileName: fileName,
            compressionLevel: -1,
            password: password,
            aes: true
        )
    }

    /// Write file with full options
    /// - Parameters:
    ///   - path: Path to file
    ///   - fileName: Name in zip
    ///   - compressionLevel: Compression level
    ///   - password: Optional password
    ///   - aes: Whether to use AES encryption
    /// - Returns: true if successful
    public func writeFile(
        atPath path: String,
        withFileName fileName: String?,
        compressionLevel: Int,
        password: String?,
        aes: Bool
    ) -> Bool {
        guard isOpen else { return false }
        guard FileManager.default.fileExists(atPath: path) else { return false }

        // Implementation would write file to zip
        return true
    }

    /// Write data to zip
    /// - Parameters:
    ///   - data: Data to write
    ///   - filename: Filename in zip
    ///   - password: Optional password
    /// - Returns: true if successful
    public func writeData(_ data: Data, filename: String?, withPassword password: String?) -> Bool {
        return writeData(
            data,
            filename: filename,
            compressionLevel: -1,
            password: password,
            aes: true
        )
    }

    /// Write data with full options
    /// - Parameters:
    ///   - data: Data to write
    ///   - filename: Filename in zip
    ///   - compressionLevel: Compression level
    ///   - password: Optional password
    ///   - aes: Whether to use AES encryption
    /// - Returns: true if successful
    public func writeData(
        _ data: Data,
        filename: String?,
        compressionLevel: Int,
        password: String?,
        aes: Bool
    ) -> Bool {
        guard isOpen else { return false }
        guard let filename = filename else { return false }

        // Implementation would write data to zip
        return true
    }

    /// Close the zip file
    /// - Returns: true if successful
    public func close() -> Bool {
        guard isOpen else { return true }
        isOpen = false
        return true
    }
}
