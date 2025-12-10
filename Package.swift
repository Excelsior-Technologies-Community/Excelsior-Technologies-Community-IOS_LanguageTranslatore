// LiveTranslationKit/Package.swift

// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LiveTranslationKit",
    
    // Define supported platforms (iOS 15 or later for SwiftUI .task, .async/await)
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    
    products: [
        // This is what users will import (e.g., `import LiveTranslationKit`)
        .library(
            name: "LiveTranslationKit",
            targets: ["LiveTranslationKit"]),
    ],
    
    targets: [
        .target(
            name: "LiveTranslationKit",
            dependencies: [],
            // Set the path to your source files
            path: "Sources/LiveTranslationKit"
        ),
    ]
)
