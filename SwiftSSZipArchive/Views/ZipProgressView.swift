//
//  ZipProgressView.swift
//  SwiftSSZipArchive
//
//  SwiftUI views for SSZipArchive
//  Copyright (c) 2024. All rights reserved.
//

import SwiftUI

#if os(iOS) || os(tvOS) || os(watchOS)

// MARK: - Zip Progress View

/// SwiftUI view for displaying zip/unzip progress
@available(iOS 14.0, tvOS 14.0, watchOS 7.0, *)
public struct ZipProgressView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: ZipProgressViewModel

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 20) {
            Text(viewModel.title)
                .font(.headline)

            ProgressView(value: viewModel.progress, total: 1.0) {
                Text("\(Int(viewModel.progress * 100))%")
                    .font(.caption)
            }
            .progressViewStyle(LinearProgressViewStyle())

            if let currentFile = viewModel.currentFile {
                Text(currentFile)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }
}

// MARK: - View Model

/// View model for zip progress
@available(iOS 14.0, tvOS 14.0, watchOS 7.0, *)
public class ZipProgressViewModel: ObservableObject {

    @Published public var title: String
    @Published public var progress: Double = 0.0
    @Published public var currentFile: String?
    @Published public var errorMessage: String?

    public init(title: String) {
        self.title = title
    }

    public func updateProgress(_ value: Double, currentFile: String? = nil) {
        DispatchQueue.main.async {
            self.progress = value
            self.currentFile = currentFile
        }
    }

    public func setError(_ message: String) {
        DispatchQueue.main.async {
            self.errorMessage = message
        }
    }

    public func reset() {
        DispatchQueue.main.async {
            self.progress = 0.0
            self.currentFile = nil
            self.errorMessage = nil
        }
    }
}

// MARK: - Preview

@available(iOS 14.0, tvOS 14.0, watchOS 7.0, *)
struct ZipProgressView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ZipProgressViewModel(title: "Extracting Archive")
        viewModel.progress = 0.65
        viewModel.currentFile = "documents/report.pdf"

        return ZipProgressView(viewModel: viewModel)
            .previewLayout(.sizeThatFits)
    }
}

#endif
