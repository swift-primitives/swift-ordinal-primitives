// swift-tools-version: 6.3.1
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
            name: "Ordinal Primitives Core",
            targets: ["Ordinal Primitives Core"]
        ),
        .library(
            name: "Ordinal Primitives Standard Library Integration",
            targets: ["Ordinal Primitives Standard Library Integration"]
        ),
        .library(
            name: "Ordinal Primitives Test Support",
            targets: ["Ordinal Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(path: "../swift-tagged-primitives"),
        .package(path: "../swift-carrier-primitives"),
        .package(path: "../swift-cardinal-primitives"),
        .package(path: "../swift-property-primitives"),
        .package(path: "../swift-equation-primitives"),
        .package(path: "../swift-comparison-primitives"),
        .package(path: "../swift-hash-primitives"),
    ],
    targets: [

        // MARK: - Core
        .target(
            name: "Ordinal Primitives Core",
            dependencies: [
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
                .product(name: "Carrier Primitives", package: "swift-carrier-primitives"),
                .product(name: "Cardinal Primitives", package: "swift-cardinal-primitives"),
                .product(name: "Property Primitives", package: "swift-property-primitives"),
                .product(name: "Equation Primitives", package: "swift-equation-primitives"),
                .product(name: "Comparison Primitives", package: "swift-comparison-primitives"),
                .product(name: "Hash Primitives", package: "swift-hash-primitives"),
            ]
        ),

        // MARK: - Umbrella
        .target(
            name: "Ordinal Primitives",
            dependencies: [
                "Ordinal Primitives Core",
                "Ordinal Primitives Standard Library Integration",
            ]
        ),

        // MARK: - StdLib Integration
        .target(
            name: "Ordinal Primitives Standard Library Integration",
            dependencies: [
                "Ordinal Primitives Core",
                .product(name: "Carrier Primitives", package: "swift-carrier-primitives"),
            ]
        ),

        // MARK: - Test Support
        .target(
            name: "Ordinal Primitives Test Support",
            dependencies: [
                "Ordinal Primitives",
                .product(name: "Cardinal Primitives Test Support", package: "swift-cardinal-primitives"),
            ],
            path: "Tests/Support"
        ),

        // MARK: - Tests
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
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
