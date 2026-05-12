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
        .package(url: "https://github.com/swift-primitives/swift-tagged-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-carrier-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-cardinal-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-property-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-equation-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-comparison-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-hash-primitives.git", branch: "main"),
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
