//
//  CombineUsage.swift
//  SwiftSSZipArchive
//
//  Examples of Combine usage
//  Copyright (c) 2024. All rights reserved.
//

import Foundation
import Combine

// MARK: - Combine Usage Examples

/// Examples of Combine usage with SwiftSSZipArchive
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public class CombineExamples {

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Unzip with Combine

    /// Basic unzip using Combine
    public func basicCombineUnzip() {
        let zipPath = "/path/to/archive.zip"
        let destinationPath = "/path/to/destination"

        SSZipArchive.unzipFilePublisher(
            atPath: zipPath,
            toDestination: destinationPath
        )
        .sink { completion in
            switch completion {
            case .finished:
                print("Unzip completed successfully")
            case .failure(let error):
                print("Unzip failed: \(error.localizedDescription)")
            }
        } receiveValue: { progress in
            print("Unzipping: \(progress.entry) - \(Int(progress.percentage * 100))%")
        }
        .store(in: &cancellables)
    }

    /// Unzip with password using Combine
    public func combineUnzipWithPassword() {
        let zipPath = "/path/to/protected.zip"
        let destinationPath = "/path/to/destination"
        let password = "secret123"

        SSZipArchive.unzipFilePublisher(
            atPath: zipPath,
            toDestination: destinationPath,
            password: password
        )
        .sink { completion in
            if case .failure(let error) = completion {
                print("Failed: \(error.localizedDescription)")
            }
        } receiveValue: { progress in
            print("Progress: \(Int(progress.percentage * 100))%")
        }
        .store(in: &cancellables)
    }

    /// Simple unzip without progress tracking
    public func simpleCombineUnzip() {
        let zipPath = "/path/to/archive.zip"
        let destinationPath = "/path/to/destination"

        SSZipArchive.unzipFileSimplePublisher(
            atPath: zipPath,
            toDestination: destinationPath
        )
        .sink { completion in
            if case .failure(let error) = completion {
                print("Failed: \(error.localizedDescription)")
            }
        } receiveValue: { success in
            if success {
                print("Unzip completed successfully")
            }
        }
        .store(in: &cancellables)
    }

    // MARK: - Zip with Combine

    /// Basic zip creation using Combine
    public func basicCombineZip() {
        let zipPath = "/path/to/output.zip"
        let sourceDirectory = "/path/to/source"

        SSZipArchive.createZipFilePublisher(
            atPath: zipPath,
            withContentsOfDirectory: sourceDirectory
        )
        .sink { completion in
            if case .failure(let error) = completion {
                print("Zip failed: \(error.localizedDescription)")
            }
        } receiveValue: { progress in
            print("Zipping: \(progress.current)/\(progress.total) - \(Int(progress.percentage * 100))%")
        }
        .store(in: &cancellables)
    }

    /// Zip with password using Combine
    public func combineZipWithPassword() {
        let zipPath = "/path/to/protected.zip"
        let sourceDirectory = "/path/to/source"
        let password = "secret123"

        SSZipArchive.createZipFilePublisher(
            atPath: zipPath,
            withContentsOfDirectory: sourceDirectory,
            keepParentDirectory: false,
            password: password
        )
        .sink { completion in
            switch completion {
            case .finished:
                print("Zip creation completed")
            case .failure(let error):
                print("Failed: \(error.localizedDescription)")
            }
        } receiveValue: { progress in
            print("Progress: \(Int(progress.percentage * 100))%")
        }
        .store(in: &cancellables)
    }

    /// Simple zip without progress tracking
    public func simpleCombineZip() {
        let zipPath = "/path/to/output.zip"
        let sourceDirectory = "/path/to/source"

        SSZipArchive.createZipFileSimplePublisher(
            atPath: zipPath,
            withContentsOfDirectory: sourceDirectory
        )
        .sink { success in
            if success {
                print("Zip created successfully")
            } else {
                print("Failed to create zip")
            }
        }
        .store(in: &cancellables)
    }

    // MARK: - Advanced Combine Operations

    /// Chain unzip and zip operations
    public func chainedOperations() {
        let sourceZip = "/path/to/source.zip"
        let tempDirectory = "/tmp/extracted"
        let outputZip = "/path/to/output.zip"

        // First unzip, then create a new zip
        SSZipArchive.unzipFileSimplePublisher(
            atPath: sourceZip,
            toDestination: tempDirectory
        )
        .flatMap { _ in
            SSZipArchive.createZipFileSimplePublisher(
                atPath: outputZip,
                withContentsOfDirectory: tempDirectory
            )
        }
        .sink { completion in
            if case .failure(let error) = completion {
                print("Operation failed: \(error.localizedDescription)")
            }
        } receiveValue: { success in
            if success {
                print("Successfully re-packaged archive")
            }
        }
        .store(in: &cancellables)
    }

    /// Process multiple archives in sequence
    public func sequentialProcessing() {
        let archives = [
            "/path/to/archive1.zip",
            "/path/to/archive2.zip",
            "/path/to/archive3.zip"
        ]

        Publishers.Sequence(sequence: archives)
            .flatMap { zipPath in
                let destination = "/tmp/\((zipPath as NSString).lastPathComponent)"
                return SSZipArchive.unzipFileSimplePublisher(
                    atPath: zipPath,
                    toDestination: destination
                )
                .map { (zipPath, $0) }
            }
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Failed: \(error.localizedDescription)")
                }
            } receiveValue: { (zipPath, success) in
                if success {
                    print("Successfully processed: \(zipPath)")
                }
            }
            .store(in: &cancellables)
    }

    /// Collect progress updates
    public func collectProgressUpdates() {
        let zipPath = "/path/to/archive.zip"
        let destinationPath = "/path/to/destination"

        SSZipArchive.unzipFilePublisher(
            atPath: zipPath,
            toDestination: destinationPath
        )
        .collect()
        .sink { completion in
            if case .failure(let error) = completion {
                print("Failed: \(error.localizedDescription)")
            }
        } receiveValue: { progressUpdates in
            print("Total progress updates received: \(progressUpdates.count)")
            if let lastProgress = progressUpdates.last {
                print("Final progress: \(Int(lastProgress.percentage * 100))%")
            }
        }
        .store(in: &cancellables)
    }

    // MARK: - SwiftUI Integration

    /// View model using Combine for SwiftUI
    @available(iOS 13.0, macOS 10.15, *)
    public class ZipCombineViewModel: ObservableObject {
        @Published var isProcessing = false
        @Published var progress: Double = 0.0
        @Published var currentFile: String = ""
        @Published var errorMessage: String?

        private var cancellables = Set<AnyCancellable>()

        func unzipArchive(at path: String, to destination: String, password: String? = nil) {
            isProcessing = true
            errorMessage = nil
            progress = 0.0

            SSZipArchive.unzipFilePublisher(
                atPath: path,
                toDestination: destination,
                password: password
            )
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isProcessing = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] progressUpdate in
                self?.progress = progressUpdate.percentage
                self?.currentFile = progressUpdate.entry
            }
            .store(in: &cancellables)
        }

        func createZip(at path: String, from directory: String, password: String? = nil) {
            isProcessing = true
            errorMessage = nil
            progress = 0.0

            SSZipArchive.createZipFilePublisher(
                atPath: path,
                withContentsOfDirectory: directory,
                keepParentDirectory: false,
                password: password
            )
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isProcessing = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] progressUpdate in
                self?.progress = progressUpdate.percentage
                self?.currentFile = "\(progressUpdate.current)/\(progressUpdate.total)"
            }
            .store(in: &cancellables)
        }

        func cancelAllOperations() {
            cancellables.removeAll()
            isProcessing = false
            progress = 0.0
        }
    }

    // MARK: - Retry Logic

    /// Unzip with automatic retry
    public func unzipWithRetry() {
        let zipPath = "/path/to/archive.zip"
        let destinationPath = "/path/to/destination"

        SSZipArchive.unzipFileSimplePublisher(
            atPath: zipPath,
            toDestination: destinationPath
        )
        .retry(3)
        .sink { completion in
            if case .failure(let error) = completion {
                print("Failed after retries: \(error.localizedDescription)")
            }
        } receiveValue: { success in
            if success {
                print("Unzip succeeded (possibly after retry)")
            }
        }
        .store(in: &cancellables)
    }

    /// Zip with timeout
    public func zipWithTimeout() {
        let zipPath = "/path/to/output.zip"
        let sourceDirectory = "/path/to/source"

        SSZipArchive.createZipFileSimplePublisher(
            atPath: zipPath,
            withContentsOfDirectory: sourceDirectory
        )
        .timeout(.seconds(30), scheduler: DispatchQueue.main)
        .sink { completion in
            switch completion {
            case .finished:
                print("Zip completed within timeout")
            case .failure(let error):
                print("Zip failed or timed out: \(error)")
            }
        } receiveValue: { success in
            if success {
                print("Zip created successfully")
            }
        }
        .store(in: &cancellables)
    }
}
