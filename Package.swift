// Package.swift
// MUST be the first line!
// ----------------------
// swift-tools-version: 5.9 
// ----------------------

import PackageDescription

let package = Package(
    name: "LiveTranslationKit", // Use this name, or whatever you put in Package.swift
    platforms: [
        .iOS(.v15), 
        .macOS(.v12) // Or whatever platforms you need
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