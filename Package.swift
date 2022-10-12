// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "Cannon",
	platforms: [
		.macOS(.v12),
	],
	products: [
		.executable(name: "cannon", targets: ["Cannon"])
	],
	dependencies: [
		.package(url: "https://github.com/generald/CollectionKit", branch: "master"),
		.package(url: "https://github.com/gonzalezreal/DefaultCodable", from: "1.2.1"),
		.package(url: "https://github.com/JohnSundell/Files", from: "4.2.0"),
		.package(url: "https://github.com/eneko/Kebab.git", from: "1.1.0"),
		.package(url: "https://github.com/crossroadlabs/Regex", from: "1.2.0"),
		.package(url: "https://github.com/jakeheis/SwiftCLI", from: "6.0.3"),
		.package(url: "https://github.com/jpsim/Yams", from: "5.0.1"),
	],
	targets: [
		.executableTarget(
			name: "Cannon",
			dependencies: [
				"CollectionKit",
				"DefaultCodable",
				"Files",
				"Kebab",
				"Regex",
				"SwiftCLI",
				"Yams"]),
		.testTarget(
			name: "CannonTests",
			dependencies: ["Cannon"]),
	]
)
