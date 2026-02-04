// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "swift-ordinal-primitives",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "Ordinal Primitives",
            targets: ["Ordinal Primitives"]
        ),
        .library(
            name: "Ordinal Primitives Test Support",
            targets: ["Ordinal Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(path: "../swift-identity-primitives"),
        .package(path: "../swift-cardinal-primitives"),
        .package(path: "../swift-property-primitives"),
        .package(path: "../swift-equation-primitives"),
        .package(path: "../swift-comparison-primitives"),
    ],
    targets: [
        .target(
            name: "Ordinal Primitives Core",
            dependencies: [
                .product(name: "Identity Primitives", package: "swift-identity-primitives"),
                .product(name: "Cardinal Primitives", package: "swift-cardinal-primitives"),
                .product(name: "Property Primitives", package: "swift-property-primitives"),
                .product(name: "Equation Primitives", package: "swift-equation-primitives"),
                .product(name: "Comparison Primitives", package: "swift-comparison-primitives"),
            ]
        ),
        .target(
            name: "Ordinal Primitives",
            dependencies: [
                "Ordinal Primitives Core",
                "Ordinal Primitives Standard Library Integration",
                .product(name: "Identity Primitives", package: "swift-identity-primitives"),
            ]
        ),
        .target(
            name: "Ordinal Primitives Standard Library Integration",
            dependencies: [
                "Ordinal Primitives Core",
            ]
        ),
        .target(
            name: "Ordinal Primitives Test Support",
            dependencies: [
                "Ordinal Primitives",
                .product(name: "Cardinal Primitives Test Support", package: "swift-cardinal-primitives"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Ordinal Primitives Tests",
            dependencies: [
                "Ordinal Primitives",
                "Ordinal Primitives Test Support",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let settings: [SwiftSetting] = [
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableExperimentalFeature("Lifetimes"),
        .strictMemorySafety(),
    ]
    target.swiftSettings = (target.swiftSettings ?? []) + settings
}
