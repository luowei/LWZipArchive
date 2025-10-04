//
//  ZipCommon.swift
//  SwiftSSZipArchive
//
//  Swift implementation of SSZipArchive
//  Copyright (c) 2024. All rights reserved.
//

import Foundation

// MARK: - Zip File Info Structures

/// Global information about a ZIP file
public struct ZipGlobalInfo {
    /// Total number of entries in the central directory on this disk
    public let numberOfEntries: UInt64
    /// Number of the disk with central directory, used for spanning ZIP
    public let diskNumberWithCD: UInt32
    /// Size of the global comment of the zipfile
    public let commentSize: UInt16

    public init(numberOfEntries: UInt64, diskNumberWithCD: UInt32, commentSize: UInt16) {
        self.numberOfEntries = numberOfEntries
        self.diskNumberWithCD = diskNumberWithCD
        self.commentSize = commentSize
    }
}

/// Information about a file in the ZIP archive
public struct ZipFileInfo {
    /// Version made by
    public let version: UInt16
    /// Version needed to extract
    public let versionNeeded: UInt16
    /// General purpose bit flag
    public let flag: UInt16
    /// Compression method
    public let compressionMethod: UInt16
    /// Last mod file date in DOS format
    public let dosDate: UInt32
    /// CRC-32
    public let crc: UInt32
    /// Compressed size
    public let compressedSize: UInt64
    /// Uncompressed size
    public let uncompressedSize: UInt64
    /// Filename length
    public let filenameSize: UInt16
    /// Extra field length
    public let extraFieldSize: UInt16
    /// File comment length
    public let commentSize: UInt16
    /// Disk number start
    public let diskNumStart: UInt32
    /// Internal file attributes
    public let internalFA: UInt16
    /// External file attributes
    public let externalFA: UInt32
    /// Disk offset
    public let diskOffset: UInt64

    public init(
        version: UInt16,
        versionNeeded: UInt16,
        flag: UInt16,
        compressionMethod: UInt16,
        dosDate: UInt32,
        crc: UInt32,
        compressedSize: UInt64,
        uncompressedSize: UInt64,
        filenameSize: UInt16,
        extraFieldSize: UInt16,
        commentSize: UInt16,
        diskNumStart: UInt32,
        internalFA: UInt16,
        externalFA: UInt32,
        diskOffset: UInt64
    ) {
        self.version = version
        self.versionNeeded = versionNeeded
        self.flag = flag
        self.compressionMethod = compressionMethod
        self.dosDate = dosDate
        self.crc = crc
        self.compressedSize = compressedSize
        self.uncompressedSize = uncompressedSize
        self.filenameSize = filenameSize
        self.extraFieldSize = extraFieldSize
        self.commentSize = commentSize
        self.diskNumStart = diskNumStart
        self.internalFA = internalFA
        self.externalFA = externalFA
        self.diskOffset = diskOffset
    }
}
