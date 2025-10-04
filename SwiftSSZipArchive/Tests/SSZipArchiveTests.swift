//
//  SSZipArchiveTests.swift
//  SwiftSSZipArchive
//
//  Unit tests for SwiftSSZipArchive
//  Copyright (c) 2024. All rights reserved.
//

import XCTest
@testable import SwiftSSZipArchive

class SSZipArchiveTests: XCTestCase {

    var tempDirectory: URL!

    override func setUpWithError() throws {
        tempDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(
            at: tempDirectory,
            withIntermediateDirectories: true
        )
    }

    override func tearDownWithError() throws {
        if FileManager.default.fileExists(atPath: tempDirectory.path) {
            try FileManager.default.removeItem(at: tempDirectory)
        }
    }

    // MARK: - Basic Tests

    func testZipArchiveInit() {
        let zipPath = tempDirectory.appendingPathComponent("test.zip").path
        let archive = SSZipArchive(path: zipPath)
        XCTAssertNotNil(archive)
    }

    func testOpenArchive() {
        let zipPath = tempDirectory.appendingPathComponent("test.zip").path
        let archive = SSZipArchive(path: zipPath)
        let opened = archive.open()
        XCTAssertTrue(opened)
        let closed = archive.close()
        XCTAssertTrue(closed)
    }

    // MARK: - Zip Creation Tests

    func testCreateZipWithFiles() {
        let zipPath = tempDirectory.appendingPathComponent("test.zip").path

        // Create test files
        let file1 = tempDirectory.appendingPathComponent("file1.txt")
        let file2 = tempDirectory.appendingPathComponent("file2.txt")

        try? "Content 1".write(to: file1, atomically: true, encoding: .utf8)
        try? "Content 2".write(to: file2, atomically: true, encoding: .utf8)

        let files = [file1.path, file2.path]
        let success = SSZipArchive.createZipFile(
            atPath: zipPath,
            withFilesAtPaths: files
        )

        XCTAssertTrue(success)
        XCTAssertTrue(FileManager.default.fileExists(atPath: zipPath))
    }

    func testCreateZipFromDirectory() {
        let sourceDir = tempDirectory.appendingPathComponent("source")
        let zipPath = tempDirectory.appendingPathComponent("test.zip").path

        // Create source directory with files
        try? FileManager.default.createDirectory(at: sourceDir, withIntermediateDirectories: true)
        let file1 = sourceDir.appendingPathComponent("file1.txt")
        try? "Content".write(to: file1, atomically: true, encoding: .utf8)

        let success = SSZipArchive.createZipFile(
            atPath: zipPath,
            withContentsOfDirectory: sourceDir.path
        )

        XCTAssertTrue(success)
    }

    // MARK: - Unzip Tests

    func testUnzipFile() {
        let zipPath = tempDirectory.appendingPathComponent("test.zip").path
        let destPath = tempDirectory.appendingPathComponent("unzipped").path

        // Create a zip first
        let sourceDir = tempDirectory.appendingPathComponent("source")
        try? FileManager.default.createDirectory(at: sourceDir, withIntermediateDirectories: true)
        let file1 = sourceDir.appendingPathComponent("file1.txt")
        try? "Content".write(to: file1, atomically: true, encoding: .utf8)

        _ = SSZipArchive.createZipFile(
            atPath: zipPath,
            withContentsOfDirectory: sourceDir.path
        )

        // Now unzip
        let success = SSZipArchive.unzipFile(
            atPath: zipPath,
            toDestination: destPath
        )

        XCTAssertTrue(success)
        XCTAssertTrue(FileManager.default.fileExists(atPath: destPath))
    }

    // MARK: - Error Handling Tests

    func testUnzipNonExistentFile() {
        let zipPath = "/nonexistent/path/test.zip"
        let destPath = tempDirectory.appendingPathComponent("unzipped").path

        let success = SSZipArchive.unzipFile(
            atPath: zipPath,
            toDestination: destPath
        )

        XCTAssertFalse(success)
    }

    func testPasswordProtectedCheck() {
        let zipPath = tempDirectory.appendingPathComponent("test.zip").path

        // Create a non-password protected zip
        let sourceDir = tempDirectory.appendingPathComponent("source")
        try? FileManager.default.createDirectory(at: sourceDir, withIntermediateDirectories: true)
        let file1 = sourceDir.appendingPathComponent("file1.txt")
        try? "Content".write(to: file1, atomically: true, encoding: .utf8)

        _ = SSZipArchive.createZipFile(
            atPath: zipPath,
            withContentsOfDirectory: sourceDir.path
        )

        let isProtected = SSZipArchive.isFilePasswordProtected(atPath: zipPath)
        XCTAssertFalse(isProtected)
    }

    // MARK: - Delegate Tests

    func testUnzipWithDelegate() {
        let zipPath = tempDirectory.appendingPathComponent("test.zip").path
        let destPath = tempDirectory.appendingPathComponent("unzipped").path

        // Create a zip
        let sourceDir = tempDirectory.appendingPathComponent("source")
        try? FileManager.default.createDirectory(at: sourceDir, withIntermediateDirectories: true)
        let file1 = sourceDir.appendingPathComponent("file1.txt")
        try? "Content".write(to: file1, atomically: true, encoding: .utf8)

        _ = SSZipArchive.createZipFile(
            atPath: zipPath,
            withContentsOfDirectory: sourceDir.path
        )

        let delegate = TestDelegate()
        let success = SSZipArchive.unzipFile(
            atPath: zipPath,
            toDestination: destPath,
            delegate: delegate
        )

        XCTAssertTrue(success)
    }

    // MARK: - Instance Method Tests

    func testInstanceBasedZipCreation() {
        let zipPath = tempDirectory.appendingPathComponent("test.zip").path
        let archive = SSZipArchive(path: zipPath)

        XCTAssertTrue(archive.open())

        // Create test data
        let data = "Test content".data(using: .utf8)!
        let dataWritten = archive.writeData(
            data,
            filename: "test.txt",
            withPassword: nil
        )

        XCTAssertTrue(dataWritten)
        XCTAssertTrue(archive.close())
    }

    // MARK: - Async Tests

    @available(iOS 13.0, macOS 10.15, *)
    func testAsyncUnzip() async throws {
        let zipPath = tempDirectory.appendingPathComponent("test.zip").path
        let destPath = tempDirectory.appendingPathComponent("unzipped").path

        // Create a zip first
        let sourceDir = tempDirectory.appendingPathComponent("source")
        try FileManager.default.createDirectory(at: sourceDir, withIntermediateDirectories: true)
        let file1 = sourceDir.appendingPathComponent("file1.txt")
        try "Content".write(to: file1, atomically: true, encoding: .utf8)

        _ = SSZipArchive.createZipFile(
            atPath: zipPath,
            withContentsOfDirectory: sourceDir.path
        )

        // Test async unzip
        let success = try await SSZipArchive.unzipFileAsync(
            atPath: zipPath,
            toDestination: destPath
        )

        XCTAssertTrue(success)
    }

    @available(iOS 13.0, macOS 10.15, *)
    func testAsyncZipCreation() async {
        let zipPath = tempDirectory.appendingPathComponent("test.zip").path
        let sourceDir = tempDirectory.appendingPathComponent("source")

        try? FileManager.default.createDirectory(at: sourceDir, withIntermediateDirectories: true)
        let file1 = sourceDir.appendingPathComponent("file1.txt")
        try? "Content".write(to: file1, atomically: true, encoding: .utf8)

        let success = await SSZipArchive.createZipFileAsync(
            atPath: zipPath,
            withContentsOfDirectory: sourceDir.path
        )

        XCTAssertTrue(success)
    }
}

// MARK: - Test Delegate

class TestDelegate: SSZipArchiveDelegate {
    var willUnzipCalled = false
    var didUnzipCalled = false

    func zipArchiveWillUnzipArchive(atPath path: String, zipInfo: ZipGlobalInfo) {
        willUnzipCalled = true
    }

    func zipArchiveDidUnzipArchive(atPath path: String, zipInfo: ZipGlobalInfo, unzippedPath: String) {
        didUnzipCalled = true
    }
}
