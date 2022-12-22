import Foundation
import GenCommon
import TemplateConfig
import ValueReader
import XCTest
import Yams
@testable import SkipPlugin

final class SkipPluginTests: XCTestCase {

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

	func testSkipCode() throws {
		let config = TestConfig(skipDelimiters: ["////"])
		let plugin = SkipPlugin(config: config, reader: TestValueReader())

		let contents = """
BEFORE
//// test01
Sapien rutrum faucibus maecenas tempus in fringilla iaculis tempor potenti sagittis nullam nunc,
litora auctor fames torquent eleifend pharetra vulputate tortor curabitur sodales.
////
AFTER
"""
		let replaced = try plugin.fileContents(piped: contents.data(using: .utf8)!)
		let text = String(data: replaced, encoding: .utf8)!
		XCTAssertEqual(text,
"""
BEFORE
AFTER
"""
		)
	}

	func testDontSkipCode() throws {
		let config = TestConfig(skipDelimiters: ["////"])
		let plugin = SkipPlugin(config: config, reader: TestValueReader())

		let contents = """
BEFORE
//// test02
Sapien rutrum faucibus maecenas tempus in fringilla iaculis tempor potenti sagittis nullam nunc,
litora auctor fames torquent eleifend pharetra vulputate tortor curabitur sodales.
////
AFTER
"""
		let replaced = try plugin.fileContents(piped: contents.data(using: .utf8)!)
		let text = String(data: replaced, encoding: .utf8)!
		XCTAssertEqual(text,
"""
BEFORE
Sapien rutrum faucibus maecenas tempus in fringilla iaculis tempor potenti sagittis nullam nunc,
litora auctor fames torquent eleifend pharetra vulputate tortor curabitur sodales.
AFTER
"""
		)
	}

	func testIndentedDelimiterIsSupported() throws {
		let config = TestConfig(skipDelimiters: ["//##"])
		let plugin = SkipPlugin(config: config, reader: TestValueReader())

		let contents = """
{
  //## test03
  Sapien rutrum faucibus maecenas tempus in fringilla iaculis tempor potenti sagittis nullam nunc,
  litora auctor fames torquent eleifend pharetra vulputate tortor curabitur sodales.
  //##
}
"""
		let replaced = try plugin.fileContents(piped: contents.data(using: .utf8)!)
		let text = String(data: replaced, encoding: .utf8)!
		XCTAssertEqual(text,
"""
{
}
"""
		)
	}

	func testCodeIndentIsKept() throws {
		let config = TestConfig(skipDelimiters: ["//##"])
		let plugin = SkipPlugin(config: config, reader: TestValueReader())

		let contents = """
{
  //## test04
  Sapien rutrum faucibus maecenas tempus in fringilla iaculis tempor potenti sagittis nullam nunc,
  litora auctor fames torquent eleifend pharetra vulputate tortor curabitur sodales.
  //##
}
"""
		let replaced = try plugin.fileContents(piped: contents.data(using: .utf8)!)
		let text = String(data: replaced, encoding: .utf8)!
		XCTAssertEqual(text,
"""
{
  Sapien rutrum faucibus maecenas tempus in fringilla iaculis tempor potenti sagittis nullam nunc,
  litora auctor fames torquent eleifend pharetra vulputate tortor curabitur sodales.
}
"""
		)
	}
}

private class TestValueReader: ValueReader {
	func read(message: String) -> String {
		""
	}

	func readInt(message: String, default: Int?) -> Int {
		0
	}

	func readDouble(message: String, default: Double?) -> Double {
		0
	}

	func readBool(message: String, default: Bool?) -> Bool {
		if message.contains("test01") {
			return true
		}
		if message.contains("test02") {
			return false
		}
		if message.contains("test03") {
			return true
		}
		if message.contains("test04") {
			return false
		}
		XCTAssertTrue(false)
		return false
	}
}
