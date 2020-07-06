// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "tcal",
    platforms: [
        .macOS(.v10_14),
    ],
    products: [
        .executable(name: "tcal", targets: ["tcal"]),
    ],
    dependencies: [
        .package(url: "https://github.com/getGuaka/Colorizer.git", from: "0.0.0"),
        .package(url: "https://github.com/malcommac/SwiftDate.git", from: "5.0.0"),
        .package(url: "https://github.com/nsomar/Guaka.git", from: "0.0.0"),
        .package(url: "https://github.com/scottrhoyt/SwiftyTextTable.git", from: "0.5.0"),
    ],
    targets: [
        .target(
            name: "tcal",
            dependencies: ["Guaka", "SwiftyTextTable", "SwiftDate", "Colorizer"]
        ),
    ]
)
