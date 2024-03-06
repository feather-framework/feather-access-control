// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "feather-access-control",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .tvOS(.v17),
        .watchOS(.v10),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "FeatherACL", targets: ["FeatherACL"]),
    ],
    dependencies: [

    ],
    targets: [
        .target(name: "FeatherACL"),
        .testTarget(
            name: "FeatherACLTests",
            dependencies: [
                .target(name: "FeatherACL")
            ]
        ),
    ]
)
