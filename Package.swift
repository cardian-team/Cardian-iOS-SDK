// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Cardian",
    platforms: [
            .macOS(.v10_12),
            .iOS(.v12),
            .tvOS(.v12),
            .watchOS(.v6)
        ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Cardian",
            targets: ["Cardian"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.2.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Cardian",
            dependencies: ["Alamofire"],
            path: "Cardian/",
            exclude: ["Tests", "Cardian", ".gitignore", ".swiftpm"],
            sources: ["Sources"],
            resources: [.copy("Resources")]
        ),
        .testTarget(
            name: "CardianTests",
            dependencies: ["Cardian"], path: "Cardian/"),
    ]
)
