// swift-tools-version: 6.3.3
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
        // MARK: - Namespace
        .library(
            name: "Ordinal Primitive",
            targets: ["Ordinal Primitive"]
        ),

        // MARK: - Sub-namespace targets
        .library(
            name: "Ordinal Error Primitives",
            targets: ["Ordinal Error Primitives"]
        ),
        .library(
            name: "Ordinal Protocol Primitives",
            targets: ["Ordinal Protocol Primitives"]
        ),
        .library(
            name: "Ordinal Advance Primitives",
            targets: ["Ordinal Advance Primitives"]
        ),
        .library(
            name: "Ordinal Retreat Primitives",
            targets: ["Ordinal Retreat Primitives"]
        ),
        .library(
            name: "Ordinal Successor Primitives",
            targets: ["Ordinal Successor Primitives"]
        ),
        .library(
            name: "Ordinal Predecessor Primitives",
            targets: ["Ordinal Predecessor Primitives"]
        ),
        .library(
            name: "Ordinal Distance Primitives",
            targets: ["Ordinal Distance Primitives"]
        ),
        .library(
            name: "Ordinal Cardinal Primitives",
            targets: ["Ordinal Cardinal Primitives"]
        ),
        .library(
            name: "Ordinal Carrier Primitives",
            targets: ["Ordinal Carrier Primitives"]
        ),
        .library(
            name: "Ordinal Equation Primitives",
            targets: ["Ordinal Equation Primitives"]
        ),
        .library(
            name: "Ordinal Hash Primitives",
            targets: ["Ordinal Hash Primitives"]
        ),
        .library(
            name: "Ordinal Comparison Primitives",
            targets: ["Ordinal Comparison Primitives"]
        ),
        .library(
            name: "Ordinal Tagged Primitives",
            targets: ["Ordinal Tagged Primitives"]
        ),

        // MARK: - StdLib Integration
        .library(
            name: "Ordinal Primitives Standard Library Integration",
            targets: ["Ordinal Primitives Standard Library Integration"]
        ),

        // MARK: - Umbrella
        .library(
            name: "Ordinal Primitives",
            targets: ["Ordinal Primitives"]
        ),

        // MARK: - Test Support
        .library(
            name: "Ordinal Primitives Test Support",
            targets: ["Ordinal Primitives Test Support"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-primitives/swift-tagged-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-carrier-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-cardinal-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-property-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-equation-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-comparison-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-hash-primitives.git", branch: "main"),
    ],
    targets: [

        // MARK: - Namespace
        .target(
            name: "Ordinal Primitive",
            dependencies: []
        ),

        // MARK: - Sub-namespace targets (per [MOD-031])
        .target(
            name: "Ordinal Error Primitives",
            dependencies: [
                "Ordinal Primitive",
            ]
        ),
        .target(
            name: "Ordinal Protocol Primitives",
            dependencies: [
                "Ordinal Primitive",
                .product(name: "Cardinal Primitives", package: "swift-cardinal-primitives"),
                .product(name: "Carrier Primitives", package: "swift-carrier-primitives"),
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
            ]
        ),
        .target(
            name: "Ordinal Advance Primitives",
            dependencies: [
                "Ordinal Primitive",
                "Ordinal Error Primitives",
                "Ordinal Protocol Primitives",
                .product(name: "Cardinal Primitives", package: "swift-cardinal-primitives"),
                .product(name: "Carrier Primitives", package: "swift-carrier-primitives"),
                .product(name: "Property Primitives", package: "swift-property-primitives"),
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
            ]
        ),
        .target(
            name: "Ordinal Retreat Primitives",
            dependencies: [
                "Ordinal Primitive",
                "Ordinal Error Primitives",
                "Ordinal Protocol Primitives",
                .product(name: "Cardinal Primitives", package: "swift-cardinal-primitives"),
                .product(name: "Property Primitives", package: "swift-property-primitives"),
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
            ]
        ),
        .target(
            name: "Ordinal Successor Primitives",
            dependencies: [
                "Ordinal Primitive",
                "Ordinal Error Primitives",
                "Ordinal Protocol Primitives",
                .product(name: "Property Primitives", package: "swift-property-primitives"),
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
            ]
        ),
        .target(
            name: "Ordinal Predecessor Primitives",
            dependencies: [
                "Ordinal Primitive",
                "Ordinal Error Primitives",
                "Ordinal Protocol Primitives",
                .product(name: "Property Primitives", package: "swift-property-primitives"),
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
            ]
        ),
        .target(
            name: "Ordinal Distance Primitives",
            dependencies: [
                "Ordinal Primitive",
                "Ordinal Error Primitives",
                "Ordinal Protocol Primitives",
                .product(name: "Cardinal Primitives", package: "swift-cardinal-primitives"),
                .product(name: "Carrier Primitives", package: "swift-carrier-primitives"),
                .product(name: "Property Primitives", package: "swift-property-primitives"),
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
            ]
        ),
        .target(
            name: "Ordinal Cardinal Primitives",
            dependencies: [
                "Ordinal Primitive",
                "Ordinal Protocol Primitives",
                .product(name: "Cardinal Primitives", package: "swift-cardinal-primitives"),
                .product(name: "Carrier Primitives", package: "swift-carrier-primitives"),
            ]
        ),
        .target(
            name: "Ordinal Carrier Primitives",
            dependencies: [
                "Ordinal Primitive",
                .product(name: "Carrier Primitives", package: "swift-carrier-primitives"),
            ]
        ),
        .target(
            name: "Ordinal Equation Primitives",
            dependencies: [
                "Ordinal Primitive",
                .product(name: "Equation Primitives", package: "swift-equation-primitives"),
            ]
        ),
        .target(
            name: "Ordinal Hash Primitives",
            dependencies: [
                "Ordinal Primitive",
                .product(name: "Hash Primitives", package: "swift-hash-primitives"),
            ]
        ),
        .target(
            name: "Ordinal Comparison Primitives",
            dependencies: [
                "Ordinal Primitive",
                .product(name: "Comparison Primitives", package: "swift-comparison-primitives"),
            ]
        ),
        .target(
            name: "Ordinal Tagged Primitives",
            dependencies: [
                "Ordinal Primitive",
                "Ordinal Cardinal Primitives",
                .product(name: "Cardinal Primitives", package: "swift-cardinal-primitives"),
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
            ]
        ),

        // MARK: - StdLib Integration
        .target(
            name: "Ordinal Primitives Standard Library Integration",
            dependencies: [
                "Ordinal Primitive",
                "Ordinal Error Primitives",
                "Ordinal Protocol Primitives",
                "Ordinal Cardinal Primitives",
                "Ordinal Distance Primitives",
                "Ordinal Tagged Primitives",
                .product(name: "Cardinal Primitives", package: "swift-cardinal-primitives"),
                .product(name: "Cardinal Primitives Standard Library Integration", package: "swift-cardinal-primitives"),
                .product(name: "Carrier Primitives", package: "swift-carrier-primitives"),
                .product(name: "Property Primitives", package: "swift-property-primitives"),
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
                .product(name: "Tagged Primitives Standard Library Integration", package: "swift-tagged-primitives"),
            ]
        ),

        // MARK: - Umbrella
        .target(
            name: "Ordinal Primitives",
            dependencies: [
                "Ordinal Primitive",
                "Ordinal Error Primitives",
                "Ordinal Protocol Primitives",
                "Ordinal Advance Primitives",
                "Ordinal Retreat Primitives",
                "Ordinal Successor Primitives",
                "Ordinal Predecessor Primitives",
                "Ordinal Distance Primitives",
                "Ordinal Cardinal Primitives",
                "Ordinal Carrier Primitives",
                "Ordinal Equation Primitives",
                "Ordinal Hash Primitives",
                "Ordinal Comparison Primitives",
                "Ordinal Tagged Primitives",
                "Ordinal Primitives Standard Library Integration",
                .product(name: "Cardinal Primitives", package: "swift-cardinal-primitives"),
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
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
                "Ordinal Primitives Standard Library Integration",
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

    // Platforms whose Swift SDK can compile the `Synchronization` module.
    // Android is excluded because the swift-android-sdk artifact bundle's
    // `SwiftOverlayShims/LibcOverlayShims.h` includes `<semaphore.h>`, which
    // Bionic libc does not ship as a standalone header (upstream gap in the
    // community Android Swift SDK). Embedded targets lack Synchronization
    // entirely. Source files that import Synchronization should guard with
    // `#if SYNCHRONIZATION_AVAILABLE`.
    let package: [SwiftSetting] = [
        .define(
            "SYNCHRONIZATION_AVAILABLE",
            .when(platforms: [.macOS, .iOS, .tvOS, .watchOS, .visionOS, .linux, .windows])
        )
    ]

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
