//
//  AsyncAwaitUsage.swift
//  SwiftSSZipArchive
//
//  Examples of async/await usage
//  Copyright (c) 2024. All rights reserved.
//

import Foundation

#if compiler(>=5.5)

// MARK: - Async/Await Usage Examples

/// Examples of async/await usage with SwiftSSZipArchive
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public class AsyncAwaitExamples {

    // MARK: - Async Unzip Examples

    /// Basic async unzip
    public static func basicAsyncUnzip() async {
        let zipPath = "/path/to/archive.zip"
        let destinationPath = "/path/to/destination"

        do {
            let success = try await SSZipArchive.unzipFileAsync(
                atPath: zipPath,
                toDestination: destinationPath
            )

            if success {
                print("Successfully unzipped to: \(destinationPath)")
            }
        } catch {
            print("Failed to unzip: \(error.localizedDescription)")
        }
    }

    /// Async unzip with password
    public static func asyncUnzipWithPassword() async {
        let zipPath = "/path/to/protected.zip"
        let destinationPath = "/path/to/destination"
        let password = "secret123"

        do {
            let success = try await SSZipArchive.unzipFileAsync(
                atPath: zipPath,
                toDestination: destinationPath,
                password: password
            )

            if success {
                print("Successfully unzipped protected archive")
            }
        } catch {
            print("Failed to unzip: \(error.localizedDescription)")
        }
    }

    /// Async unzip with progress tracking
    public static func asyncUnzipWithProgress() async {
        let zipPath = "/path/to/archive.zip"
        let destinationPath = "/path/to/destination"

        do {
            let success = try await SSZipArchive.unzipFileAsync(
                atPath: zipPath,
                toDestination: destinationPath,
                password: nil
            ) { progress in
                print("Unzip progress: \(Int(progress * 100))%")
            }

            if success {
                print("Unzip completed successfully")
            }
        } catch {
            print("Failed to unzip: \(error.localizedDescription)")
        }
    }

    // MARK: - Async Zip Examples

    /// Basic async zip creation
    public static func basicAsyncZip() async {
        let zipPath = "/path/to/output.zip"
        let sourceDirectory = "/path/to/source"

        let success = await SSZipArchive.createZipFileAsync(
            atPath: zipPath,
            withContentsOfDirectory: sourceDirectory
        )

        if success {
            print("Successfully created zip: \(zipPath)")
        } else {
            print("Failed to create zip")
        }
    }

    /// Async zip with password
    public static func asyncZipWithPassword() async {
        let zipPath = "/path/to/protected.zip"
        let sourceDirectory = "/path/to/source"
        let password = "secret123"

        let success = await SSZipArchive.createZipFileAsync(
            atPath: zipPath,
            withContentsOfDirectory: sourceDirectory,
            keepParentDirectory: false,
            password: password
        )

        if success {
            print("Created password-protected archive")
        }
    }

    /// Async zip with progress tracking
    public static func asyncZipWithProgress() async {
        let zipPath = "/path/to/output.zip"
        let sourceDirectory = "/path/to/source"

        let success = await SSZipArchive.createZipFileAsync(
            atPath: zipPath,
            withContentsOfDirectory: sourceDirectory,
            keepParentDirectory: true,
            password: nil
        ) { progress in
            print("Zip progress: \(Int(progress * 100))%")
        }

        if success {
            print("Zip completed successfully")
        }
    }

    // MARK: - Batch Operations

    /// Unzip multiple archives concurrently
    public static func batchAsyncUnzip() async {
        let archives = [
            "/path/to/archive1.zip",
            "/path/to/archive2.zip",
            "/path/to/archive3.zip"
        ]

        await withTaskGroup(of: (String, Bool).self) { group in
            for archive in archives {
                group.addTask {
                    let destination = "/tmp/\((archive as NSString).lastPathComponent)"
                    do {
                        let success = try await SSZipArchive.unzipFileAsync(
                            atPath: archive,
                            toDestination: destination
                        )
                        return (archive, success)
                    } catch {
                        print("Failed to unzip \(archive): \(error)")
                        return (archive, false)
                    }
                }
            }

            for await (archive, success) in group {
                if success {
                    print("Successfully unzipped: \(archive)")
                } else {
                    print("Failed to unzip: \(archive)")
                }
            }
        }
    }

    /// Create multiple archives concurrently
    public static func batchAsyncZip() async {
        let directories = [
            "/path/to/dir1",
            "/path/to/dir2",
            "/path/to/dir3"
        ]

        await withTaskGroup(of: (String, Bool).self) { group in
            for directory in directories {
                group.addTask {
                    let zipPath = "/tmp/\((directory as NSString).lastPathComponent).zip"
                    let success = await SSZipArchive.createZipFileAsync(
                        atPath: zipPath,
                        withContentsOfDirectory: directory
                    )
                    return (directory, success)
                }
            }

            for await (directory, success) in group {
                if success {
                    print("Successfully zipped: \(directory)")
                } else {
                    print("Failed to zip: \(directory)")
                }
            }
        }
    }

    // MARK: - Error Handling

    /// Async operation with detailed error handling
    public static func asyncWithErrorHandling() async {
        let zipPath = "/path/to/archive.zip"
        let destinationPath = "/path/to/destination"

        do {
            let success = try await SSZipArchive.unzipFileAsync(
                atPath: zipPath,
                toDestination: destinationPath
            )

            if success {
                print("Unzip completed successfully")
            }
        } catch SSZipArchiveError.failedOpenZipFile {
            print("Failed to open zip file - check if file exists")
        } catch SSZipArchiveError.failedToWriteFile {
            print("Failed to write file - check destination permissions")
        } catch SSZipArchiveError.invalidArguments {
            print("Invalid arguments provided")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }

    // MARK: - Integration with SwiftUI

    /// Example usage in a SwiftUI view model
    @MainActor
    public class ZipViewModel: ObservableObject {
        @Published var isProcessing = false
        @Published var progress: Double = 0.0
        @Published var errorMessage: String?

        func unzipArchive(at path: String, to destination: String) async {
            isProcessing = true
            errorMessage = nil
            progress = 0.0

            do {
                let success = try await SSZipArchive.unzipFileAsync(
                    atPath: path,
                    toDestination: destination,
                    password: nil
                ) { [weak self] progressValue in
                    Task { @MainActor in
                        self?.progress = progressValue
                    }
                }

                if success {
                    print("Unzip completed")
                }
            } catch {
                errorMessage = error.localizedDescription
            }

            isProcessing = false
        }

        func createZip(at path: String, from directory: String) async {
            isProcessing = true
            errorMessage = nil
            progress = 0.0

            let success = await SSZipArchive.createZipFileAsync(
                atPath: path,
                withContentsOfDirectory: directory,
                keepParentDirectory: false,
                password: nil
            ) { [weak self] progressValue in
                Task { @MainActor in
                    self?.progress = progressValue
                }
            }

            if success {
                print("Zip creation completed")
            } else {
                errorMessage = "Failed to create zip"
            }

            isProcessing = false
        }
    }
}

#endif
