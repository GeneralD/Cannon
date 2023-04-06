import Foundation
import TemplateConfig
import XCTest
@testable import IgnorePlugin

final class IgnorePluginTests: XCTestCase {

	struct TestConfig: TemplateConfig {
		let delimiters: [String]
		let constantDelimiters: [String]
		let skipDelimiters: [String]
		let ignore: [String]
		let rootDirectoryName: String?

		init(
			delimiters: [String] = [],
			constantDelimiters: [String] = [],
			skipDelimiters: [String] = [],
			ignore: [String] = [],
			rootDirectoryName: String? = nil) {
				self.delimiters = delimiters
				self.constantDelimiters = constantDelimiters
				self.skipDelimiters = skipDelimiters
				self.ignore = ignore
				self.rootDirectoryName = rootDirectoryName
			}
	}

	func testIgnoreName() throws {
		let config = TestConfig(ignore: ["\\d*"])
		let plugin = IgnorePlugin(config: config)

		XCTAssertTrue(plugin.shouldIgnore(name: "3", kind: .file))
		XCTAssertTrue(plugin.shouldIgnore(name: "0505", kind: .file))
		XCTAssertFalse(plugin.shouldIgnore(name: "Sutra", kind: .file))
		XCTAssertFalse(plugin.shouldIgnore(name: "3.png", kind: .file))
	}
}
