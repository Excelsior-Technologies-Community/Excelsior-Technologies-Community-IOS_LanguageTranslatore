// swift-tools-version: 6.1 

import PackageDescription

let package = Package(
    name: "LiveTranslationKit", 
    platforms: [
        .iOS(.v15), 
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "LiveTranslationKit",
            targets: ["LiveTranslationKit"]),
    ],
    targets: [
        .target(
            name: "LiveTranslationKit",
            dependencies: [],
            path: "Sources/LiveTranslationKit"
        ),
    ]
)