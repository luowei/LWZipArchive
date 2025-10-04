//
//  SwiftUIAppExample.swift
//  SwiftSSZipArchive
//
//  Complete SwiftUI app example
//  Copyright (c) 2024. All rights reserved.
//

import SwiftUI

#if os(iOS)

// MARK: - Main App

@available(iOS 14.0, *)
struct ZipArchiveApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MARK: - Content View

@available(iOS 14.0, *)
struct ContentView: View {
    @StateObject private var viewModel = ZipViewModel()
    @State private var showingFilePicker = false
    @State private var password = ""

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Archive Operations")) {
                    TextField("Password (optional)", text: $password)
                        .textContentType(.password)
                        .autocapitalization(.none)

                    Button {
                        showingFilePicker = true
                    } label: {
                        Label("Select Files", systemImage: "doc.fill")
                    }

                    if !viewModel.selectedFiles.isEmpty {
                        Button {
                            Task {
                                await viewModel.createArchive(
                                    password: password.isEmpty ? nil : password
                                )
                            }
                        } label: {
                            Label("Create ZIP", systemImage: "archivebox.fill")
                        }
                        .disabled(viewModel.isProcessing)
                    }

                    Button {
                        Task {
                            await viewModel.extractArchive(
                                password: password.isEmpty ? nil : password
                            )
                        }
                    } label: {
                        Label("Extract ZIP", systemImage: "arrow.down.doc.fill")
                    }
                    .disabled(viewModel.isProcessing)
                }

                if !viewModel.selectedFiles.isEmpty {
                    Section(header: Text("Selected Files")) {
                        ForEach(viewModel.selectedFiles, id: \.self) { file in
                            HStack {
                                Image(systemName: "doc.fill")
                                    .foregroundColor(.blue)
                                Text(file)
                                    .font(.caption)
                                    .lineLimit(1)
                            }
                        }
                    }
                }

                if viewModel.isProcessing {
                    Section(header: Text("Progress")) {
                        VStack(spacing: 12) {
                            ProgressView(value: viewModel.progress) {
                                HStack {
                                    Text("Processing...")
                                    Spacer()
                                    Text("\(Int(viewModel.progress * 100))%")
                                }
                                .font(.caption)
                            }

                            if let currentFile = viewModel.currentFile {
                                Text(currentFile)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }

                if let message = viewModel.statusMessage {
                    Section(header: Text("Status")) {
                        HStack {
                            Image(systemName: viewModel.hasError ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                                .foregroundColor(viewModel.hasError ? .red : .green)
                            Text(message)
                                .font(.caption)
                        }
                    }
                }
            }
            .navigationTitle("Zip Archive")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - View Model

@available(iOS 14.0, *)
@MainActor
class ZipViewModel: ObservableObject {
    @Published var selectedFiles: [String] = []
    @Published var isProcessing = false
    @Published var progress: Double = 0.0
    @Published var currentFile: String?
    @Published var statusMessage: String?
    @Published var hasError = false

    func createArchive(password: String?) async {
        isProcessing = true
        hasError = false
        statusMessage = nil
        progress = 0.0

        let outputPath = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("zip")
            .path

        let success = await SSZipArchive.createZipFileAsync(
            atPath: outputPath,
            withContentsOfDirectory: selectedFiles.first ?? "",
            keepParentDirectory: false,
            password: password
        ) { [weak self] progressValue in
            Task { @MainActor in
                self?.progress = progressValue
            }
        }

        isProcessing = false

        if success {
            statusMessage = "Archive created successfully"
            hasError = false
            shareFile(at: outputPath)
        } else {
            statusMessage = "Failed to create archive"
            hasError = true
        }
    }

    func extractArchive(password: String?) async {
        isProcessing = true
        hasError = false
        statusMessage = nil
        progress = 0.0

        guard let archivePath = selectedFiles.first else {
            statusMessage = "No archive selected"
            hasError = true
            isProcessing = false
            return
        }

        let outputPath = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .path

        do {
            let success = try await SSZipArchive.unzipFileAsync(
                atPath: archivePath,
                toDestination: outputPath,
                password: password
            ) { [weak self] progressValue in
                Task { @MainActor in
                    self?.progress = progressValue
                }
            }

            if success {
                statusMessage = "Archive extracted successfully"
                hasError = false
            }
        } catch {
            statusMessage = "Failed to extract: \(error.localizedDescription)"
            hasError = true
        }

        isProcessing = false
    }

    func addFile(_ path: String) {
        if !selectedFiles.contains(path) {
            selectedFiles.append(path)
        }
    }

    private func shareFile(at path: String) {
        // Present share sheet with the created zip file
        let url = URL(fileURLWithPath: path)
        let activityVC = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootVC = window.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

// MARK: - Alternative Compact View

@available(iOS 14.0, *)
struct CompactZipView: View {
    @StateObject private var viewModel = ZipViewModel()

    var body: some View {
        VStack(spacing: 20) {
            if viewModel.isProcessing {
                VStack {
                    ProgressView(value: viewModel.progress)
                        .progressViewStyle(CircularProgressViewStyle())

                    Text("\(Int(viewModel.progress * 100))%")
                        .font(.headline)

                    if let currentFile = viewModel.currentFile {
                        Text(currentFile)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            } else {
                VStack(spacing: 16) {
                    Button("Create ZIP") {
                        Task {
                            await viewModel.createArchive(password: nil)
                        }
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Extract ZIP") {
                        Task {
                            await viewModel.extractArchive(password: nil)
                        }
                    }
                    .buttonStyle(.bordered)
                }
            }

            if let message = viewModel.statusMessage {
                Text(message)
                    .foregroundColor(viewModel.hasError ? .red : .green)
                    .font(.caption)
            }
        }
        .padding()
    }
}

// MARK: - Preview

@available(iOS 14.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            CompactZipView()
                .previewDisplayName("Compact View")
        }
    }
}

#endif
