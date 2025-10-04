//
//  ZipArchiveError.swift
//  SwiftSSZipArchive
//
//  Swift implementation of SSZipArchive
//  Copyright (c) 2024. All rights reserved.
//

import Foundation

// MARK: - Error Handling

/// Domain for SSZipArchive errors
public let SSZipArchiveErrorDomain = "SSZipArchiveErrorDomain"

/// Error codes for SSZipArchive operations
public enum SSZipArchiveError: Int, Error, LocalizedError {
    case failedOpenZipFile = -1
    case failedOpenFileInZip = -2
    case fileInfoNotLoadable = -3
    case fileContentNotReadable = -4
    case failedToWriteFile = -5
    case invalidArguments = -6

    public var errorDescription: String? {
        switch self {
        case .failedOpenZipFile:
            return "Failed to open zip file"
        case .failedOpenFileInZip:
            return "Failed to open file in zip"
        case .fileInfoNotLoadable:
            return "File info not loadable"
        case .fileContentNotReadable:
            return "File content not readable"
        case .failedToWriteFile:
            return "Failed to write file"
        case .invalidArguments:
            return "Invalid arguments"
        }
    }
}
