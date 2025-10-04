//
//  ZipArchiveView.swift
//  SwiftSSZipArchive
//
//  SwiftUI views for SSZipArchive
//  Copyright (c) 2024. All rights reserved.
//

import SwiftUI

#if os(iOS)

// MARK: - Zip Archive View

/// SwiftUI view for creating and extracting zip archives
@available(iOS 14.0, *)
public struct ZipArchiveView: View {

    // MARK: - Properties

    @StateObject private var viewModel = ZipArchiveViewModel()
    @State private var showingFilePicker = false
    @State private var password = ""

    // MARK: - Body

    public var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Archive Operations")) {
                    TextField("Password (optional)", text: $password)
                        .textContentType(.password)
                        .autocapitalization(.none)

                    Button("Select Files to Zip") {
                        showingFilePicker = true
                    }

                    if !viewModel.selectedFiles.isEmpty {
                        Button("Create Archive") {
                            viewModel.createArchive(password: password.isEmpty ? nil : password)
                        }
                        .disabled(viewModel.isProcessing)
                    }

                    Button("Extract Archive") {
                        viewModel.extractArchive(password: password.isEmpty ? nil : password)
                    }
                    .disabled(viewModel.isProcessing)
                }

                if !viewModel.selectedFiles.isEmpty {
                    Section(header: Text("Selected Files")) {
                        ForEach(viewModel.selectedFiles, id: \.self) { file in
                            Text(file)
                                .font(.caption)
                        }
                    }
                }

                if viewModel.isProcessing {
                    Section {
                        ZipProgressView(viewModel: viewModel.progressViewModel)
                    }
                }

                if let message = viewModel.statusMessage {
                    Section {
                        Text(message)
                            .foregroundColor(viewModel.hasError ? .red : .green)
                    }
                }
            }
            .navigationTitle("Zip Archive")
        }
    }

    // MARK: - Initialization

    public init() {}
}

// MARK: - View Model

/// View model for zip archive view
@available(iOS 14.0, *)
public class ZipArchiveViewModel: ObservableObject {

    @Published public var selectedFiles: [String] = []
    @Published public var isProcessing = false
    @Published public var statusMessage: String?
    @Published public var hasError = false
    @Published public var progressViewModel = ZipProgressViewModel(title: "Processing...")

    public init() {}

    public func createArchive(password: String?) {
        isProcessing = true
        hasError = false
        statusMessage = nil

        let outputPath = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("zip")
            .path

        let success = SSZipArchive.createZipFile(
            atPath: outputPath,
            withFilesAtPaths: selectedFiles,
            withPassword: password
        )

        DispatchQueue.main.async {
            self.isProcessing = false
            if success {
                self.statusMessage = "Archive created: \(outputPath)"
                self.hasError = false
            } else {
                self.statusMessage = "Failed to create archive"
                self.hasError = true
            }
        }
    }

    public func extractArchive(password: String?) {
        // This would be called with a selected archive path
        // For demo purposes, using a placeholder
        isProcessing = true
        hasError = false
        statusMessage = nil

        let outputPath = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .path

        // Placeholder - would need actual archive path
        let archivePath = ""

        let success = SSZipArchive.unzipFile(
            atPath: archivePath,
            toDestination: outputPath,
            overwrite: true,
            password: password,
            delegate: nil
        )

        DispatchQueue.main.async {
            self.isProcessing = false
            if success {
                self.statusMessage = "Archive extracted to: \(outputPath)"
                self.hasError = false
            } else {
                self.statusMessage = "Failed to extract archive"
                self.hasError = true
            }
        }
    }

    public func addFile(_ path: String) {
        if !selectedFiles.contains(path) {
            selectedFiles.append(path)
        }
    }

    public func removeFile(_ path: String) {
        selectedFiles.removeAll { $0 == path }
    }
}

// MARK: - Preview

@available(iOS 14.0, *)
struct ZipArchiveView_Previews: PreviewProvider {
    static var previews: some View {
        ZipArchiveView()
    }
}

#endif
