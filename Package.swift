// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GXOpenSSL",
	platforms: [
		.macOS(.v10_11), .iOS(.v9), .tvOS(.v11), .watchOS(.v4)
	],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "GXOpenSSL",
            targets: ["openssl"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
		.binaryTarget(
			name: "openssl",
			url: "https://github.com/genexuslabs/openssl-apple/releases/download/1.2.101/openssl.xcframework.zip",
			checksum: "93a98dd9bcb07c9513fbc2ac8401619a7ccfa1adc5a991bbc5699e7f2fb3d955"
		)
    ]
)
