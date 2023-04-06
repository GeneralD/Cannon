// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "Sutra",
	platforms: [
		.macOS(.v12),
	],
	products: [
		.executable(name: "sutra", targets: ["Main"]),
	],
	dependencies: [
		.package(url: "https://github.com/gonzalezreal/DefaultCodable", from: "1.2.1"),
		.package(url: "https://github.com/JohnSundell/Files", from: "4.2.0"),
		.package(url: "https://github.com/eneko/Kebab", from: "1.1.0"),
		.package(url: "https://github.com/crossroadlabs/Regex", from: "1.2.0"),
		.package(url: "https://github.com/jakeheis/SwiftCLI", from: "6.0.3"),
		.package(url: "https://github.com/jpsim/Yams", from: "5.0.1"),
	],
	targets: [
		.executableTarget(
			name: "Main",
			dependencies: [
				"CompletionCommand",
				"GenCommand",
			]),
		.target(
			name: "CompletionCommand",
			dependencies: [
				"SwiftCLI",
			]),
		.target(
			name: "GenCommand",
			dependencies: [
				// internal
				"GenCommon",
				"FillVariablesPlugin",
				"IgnorePlugin",
				"SkipPlugin",
				"TemplateConfig",
				"TemplateConfigLoader",
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
				"TemplateConfig",
				"ValueReader",
				// libs
				"Files",
				"Kebab",
				"Regex",
			]),
		.target(
			name: "IgnorePlugin",
			dependencies: [
				// internal
				"GenCommon",
				"TemplateConfig",
				// libs
				"Regex",
			]),
		.target(
			name: "SkipPlugin",
			dependencies: [
				// internal
				"GenCommon",
				"TemplateConfig",
				"ValueReader",
				// libs
				"Regex",
			]),
		.target(name: "TemplateConfig"),
		.target(
			name: "TemplateConfigLoader",
			dependencies: [
				// internal
				"TemplateConfig",
				// libs
				"DefaultCodable",
				"Files",
				"Yams",
			]),
		.target(
			name: "GenCommon",
			dependencies: [
				// libs
				"Files",
			]),
		.target(name: "ValueReader"),
		.testTarget(
			name: "FillVariablesPluginTests",
			dependencies: [
				// internal
				"FillVariablesPlugin",
				"TemplateConfig",
				"ValueReader",
			]),
		.testTarget(
			name: "SkipPluginTests",
			dependencies: [
				// internal
				"SkipPlugin",
				"TemplateConfig",
				"ValueReader",
			]),
	]
)
