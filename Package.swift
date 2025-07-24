// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Surfaces",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "Surfaces",
            targets: ["Surfaces"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/leviouwendijk/plate.git",
            branch: "master"
        ),
        .package(
            url: "https://github.com/leviouwendijk/Structures.git",
            branch: "master"
        ),
        .package(
            url: "https://github.com/leviouwendijk/Extensions.git",
            branch: "master"
        ),
        .package(
            url: "https://github.com/leviouwendijk/Interfaces.git",
            branch: "master"
        ),

        .package(
            url: "https://github.com/leviouwendijk/Commerce.git",
            branch: "master"
        ),
        // .package(
        //     url: "https://github.com/vapor/postgres-nio.git", 
        //     from: "1.12.0"
        // ),
    ],
    targets: [
        .target(
            name: "Surfaces",
            dependencies: [
                .product(name: "plate", package: "plate"),
                .product(name: "Structures", package: "Structures"),
                .product(name: "Extensions", package: "Extensions"),
                .product(name: "Interfaces", package: "Interfaces"),
                .product(name: "Commerce", package: "Commerce"),
                // .product(name: "PostgresNIO", package: "postgres-nio"),
            ],
            resources: [
                .process("Resources")
            ],
        ),
        .testTarget(
            name: "SurfacesTests",
            dependencies: [
                "Surfaces",
                .product(name: "plate", package: "plate"),
                .product(name: "Structures", package: "Structures"),
                .product(name: "Extensions", package: "Extensions"),
                .product(name: "Interfaces", package: "Interfaces"),
                .product(name: "Commerce", package: "Commerce"),
                // .product(name: "PostgresNIO", package: "postgres-nio"),
            ]
        ),
    ]
)
