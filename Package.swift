// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "Cannon",
	platforms: [
		.macOS(.v12),
	],
	products: [
		.executable(name: "cannon", targets: ["Cannon"]),
	],
	dependencies: [
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
				"GenCommand",
			]),
		.target(
			name: "GenCommand",
			dependencies: [
				// internal
				"GenCommon",
				"FillVariablesPlugin",
				"IgnorePlugin",
				"SkipPlugin",
				"ValueReader",
				// libs
				"Files",
				"SwiftCLI",
				"Yams",
			]),
		.target(
			name: "FillVariablesPlugin",
			dependencies: [
				// internal
				"GenCommon",
				"ValueReader",
				// libs
				"Files",
				"Kebab",
			]),
		.target(
			name: "IgnorePlugin",
			dependencies: [
				// internal
				"GenCommon",
				// libs
				"Regex",
			]),
		.target(
			name: "SkipPlugin",
			dependencies: [
				// internal
				"GenCommon",
				"ValueReader",
				// libs
				"Regex",
			]),
		.target(
			name: "GenCommon",
			dependencies: [
				// libs
				"DefaultCodable",
				"Files",
			]),
		.target(
			name: "ValueReader"
		),
		.testTarget(
			name: "SkipPluginTests",
			dependencies: [
				// internal
				"GenCommon",
				"SkipPlugin",
				"ValueReader",
				// libs
				"Yams",
			]),
	]
)
