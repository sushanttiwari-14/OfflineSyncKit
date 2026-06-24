// swift-tools-version: 6.3
import PackageDescription

let package = Package(
    name: "OfflineSyncKit",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "OfflineSyncKit",
            targets: ["OfflineSyncKit"]
        ),
    ],
    targets: [
        .target(
            name: "OfflineSyncKit",
            swiftSettings: [
                .swiftLanguageMode(.v5)
            ]
        ),
        .testTarget(
            name: "OfflineSyncKitTests",
            dependencies: ["OfflineSyncKit"],
            swiftSettings: [
                .swiftLanguageMode(.v5)
            ]
        ),
    ]
)
