import Foundation
import TemplateConfig
import ValueReader
import XCTest
@testable import FillVariablesPlugin

final class FillVariablesPluginTests: XCTestCase {

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

	private class TestValueReader: ValueReader {
		func read(message: String) -> String {
			if message.contains("fooBar") {
				return "bananaJuice"
			}
			if message.contains("foo") {
				return "banana"
			}
			return "default"
		}

		func readInt(message: String, default: Int?) -> Int {
			0
		}

		func readDouble(message: String, default: Double?) -> Double {
			0
		}

		func readBool(message: String, default: Bool?) -> Bool {
			false
		}
	}

	func testFillVariables() throws {
		let config = TestConfig(delimiters: ["__"])
		let plugin = FillVariablesPlugin(config: config, reader: TestValueReader())

		let contents = """
__FOO__
__foo__
__Foo__
"""
		let replaced = try plugin.fileContents(piped: contents.data(using: .utf8)!)
		let text = String(data: replaced, encoding: .utf8)!
		XCTAssertEqual(text,
"""
BANANA
banana
Banana
"""
		)
	}

	func testFillPhraseVariables() throws {
		let config = TestConfig(delimiters: ["__"])
		let plugin = FillVariablesPlugin(config: config, reader: TestValueReader())

		let contents = """
__FOO_BAR__
__fooBar__
__FooBar__
__foo-bar__
"""
		let replaced = try plugin.fileContents(piped: contents.data(using: .utf8)!)
		let text = String(data: replaced, encoding: .utf8)!
		XCTAssertEqual(text,
"""
BANANA_JUICE
bananaJuice
BananaJuice
banana-juice
"""
		)
	}
}
