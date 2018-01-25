// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "swiftredunda",
    products: [
        .library(
            name: "SwiftRedunda",
            targets: ["SwiftRedunda"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "SwiftRedunda",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "swiftredundaTests",
            dependencies: ["SwiftRedunda"]),
    ]
)
