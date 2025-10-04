//
//  BasicUsage.swift
//  SwiftSSZipArchive
//
//  Examples of basic usage
//  Copyright (c) 2024. All rights reserved.
//

import Foundation

// MARK: - Basic Usage Examples

/// Examples of how to use SwiftSSZipArchive
public class SwiftSSZipArchiveExamples {

    // MARK: - Unzipping Examples

    /// Basic unzip example
    public static func basicUnzip() {
        let zipPath = "/path/to/archive.zip"
        let destinationPath = "/path/to/destination"

        let success = SSZipArchive.unzipFile(
            atPath: zipPath,
            toDestination: destinationPath
        )

        if success {
            print("Successfully unzipped to: \(destinationPath)")
        } else {
            print("Failed to unzip")
        }
    }

    /// Unzip with password
    public static func unzipWithPassword() {
        let zipPath = "/path/to/protected.zip"
        let destinationPath = "/path/to/destination"
        let password = "secret123"

        let success = SSZipArchive.unzipFile(
            atPath: zipPath,
            toDestination: destinationPath,
            overwrite: true,
            password: password,
            delegate: nil
        )

        if success {
            print("Successfully unzipped protected archive")
        }
    }

    /// Unzip with delegate for progress tracking
    public static func unzipWithDelegate() {
        let zipPath = "/path/to/archive.zip"
        let destinationPath = "/path/to/destination"

        let delegate = ZipDelegate()
        let success = SSZipArchive.unzipFile(
            atPath: zipPath,
            toDestination: destinationPath,
            delegate: delegate
        )

        if success {
            print("Unzipped with progress tracking")
        }
    }

    /// Unzip with progress and completion handlers
    public static func unzipWithHandlers() {
        let zipPath = "/path/to/archive.zip"
        let destinationPath = "/path/to/destination"

        SSZipArchive.unzipFile(
            atPath: zipPath,
            toDestination: destinationPath,
            progressHandler: { entry, fileInfo, current, total in
                let progress = Double(current) / Double(total) * 100
                print("Unzipping: \(entry) - \(Int(progress))%")
            },
            completionHandler: { path, succeeded, error in
                if succeeded {
                    print("Successfully unzipped to: \(path)")
                } else if let error = error {
                    print("Failed with error: \(error.localizedDescription)")
                }
            }
        )
    }

    // MARK: - Zipping Examples

    /// Basic zip creation
    public static func basicZip() {
        let zipPath = "/path/to/output.zip"
        let sourceDirectory = "/path/to/source"

        let success = SSZipArchive.createZipFile(
            atPath: zipPath,
            withContentsOfDirectory: sourceDirectory
        )

        if success {
            print("Successfully created zip: \(zipPath)")
        }
    }

    /// Zip with password protection
    public static func zipWithPassword() {
        let zipPath = "/path/to/protected.zip"
        let sourceDirectory = "/path/to/source"
        let password = "secret123"

        let success = SSZipArchive.createZipFile(
            atPath: zipPath,
            withContentsOfDirectory: sourceDirectory,
            keepParentDirectory: false,
            withPassword: password
        )

        if success {
            print("Created password-protected archive")
        }
    }

    /// Zip specific files
    public static func zipSpecificFiles() {
        let zipPath = "/path/to/output.zip"
        let files = [
            "/path/to/file1.txt",
            "/path/to/file2.pdf",
            "/path/to/file3.jpg"
        ]

        let success = SSZipArchive.createZipFile(
            atPath: zipPath,
            withFilesAtPaths: files
        )

        if success {
            print("Created archive with specific files")
        }
    }

    /// Zip with compression level and AES encryption
    public static func zipWithAdvancedOptions() {
        let zipPath = "/path/to/output.zip"
        let sourceDirectory = "/path/to/source"
        let password = "secret123"

        let success = SSZipArchive.createZipFile(
            atPath: zipPath,
            withContentsOfDirectory: sourceDirectory,
            keepParentDirectory: true,
            compressionLevel: 9, // Maximum compression
            password: password,
            aes: true, // Use AES encryption
            progressHandler: { current, total in
                let progress = Double(current) / Double(total) * 100
                print("Zipping progress: \(Int(progress))%")
            }
        )

        if success {
            print("Created archive with advanced options")
        }
    }

    // MARK: - Instance-based Zip Creation

    /// Create zip using instance methods
    public static func instanceBasedZip() {
        let zipPath = "/path/to/output.zip"
        let archive = SSZipArchive(path: zipPath)

        guard archive.open() else {
            print("Failed to open zip for writing")
            return
        }

        // Write a folder
        _ = archive.writeFolder(
            atPath: "/path/to/folder",
            withFolderName: "MyFolder",
            withPassword: nil
        )

        // Write a file
        _ = archive.writeFile(
            "/path/to/file.txt",
            withPassword: nil
        )

        // Write data
        let data = "Hello, World!".data(using: .utf8)!
        _ = archive.writeData(
            data,
            filename: "hello.txt",
            withPassword: nil
        )

        // Close the archive
        guard archive.close() else {
            print("Failed to close zip")
            return
        }

        print("Successfully created zip using instance methods")
    }

    // MARK: - Utility Methods

    /// Check if file is password protected
    public static func checkPassword() {
        let zipPath = "/path/to/archive.zip"

        if SSZipArchive.isFilePasswordProtected(atPath: zipPath) {
            print("Archive is password protected")

            do {
                let isValid = try SSZipArchive.isPasswordValid(
                    forArchiveAtPath: zipPath,
                    password: "secret123"
                )
                if isValid {
                    print("Password is valid")
                }
            } catch {
                print("Error validating password: \(error)")
            }
        } else {
            print("Archive is not password protected")
        }
    }

    /// Get archive payload size
    public static func getPayloadSize() {
        let zipPath = "/path/to/archive.zip"

        do {
            let size = try SSZipArchive.payloadSize(forArchiveAtPath: zipPath)
            let sizeInMB = Double(size) / 1_048_576
            print("Archive payload size: \(String(format: "%.2f", sizeInMB)) MB")
        } catch {
            print("Error getting payload size: \(error)")
        }
    }
}

// MARK: - Example Delegate

class ZipDelegate: SSZipArchiveDelegate {
    func zipArchiveWillUnzipArchive(atPath path: String, zipInfo: ZipGlobalInfo) {
        print("Will unzip archive with \(zipInfo.numberOfEntries) entries")
    }

    func zipArchiveDidUnzipArchive(atPath path: String, zipInfo: ZipGlobalInfo, unzippedPath: String) {
        print("Did unzip archive to: \(unzippedPath)")
    }

    func zipArchiveWillUnzipFile(atIndex fileIndex: Int, totalFiles: Int, archivePath: String, fileInfo: ZipFileInfo) {
        print("Unzipping file \(fileIndex + 1) of \(totalFiles)")
    }

    func zipArchiveProgressEvent(loaded: UInt64, total: UInt64) {
        let progress = Double(loaded) / Double(total) * 100
        print("Progress: \(Int(progress))%")
    }
}
