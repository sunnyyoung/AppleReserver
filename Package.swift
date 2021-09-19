// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppleReserver",
    platforms: [
        .macOS(.v10_12)
    ],
    products: [
        .executable(
            name: "applereserver",
            targets: [
                "AppleReserver"
            ]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire", from: "5.4.3"),
        .package(url: "https://github.com/mxcl/PromiseKit", from: "6.15.3"),
        .package(url: "https://github.com/malcommac/Repeat", from: "0.6.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.1")
    ],
    targets: [
        .target(
            name: "AppleReserver",
            dependencies: [
                "Alamofire",
                "PromiseKit",
                "Repeat",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]
        )
    ]
)
