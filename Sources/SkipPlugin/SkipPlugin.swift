import Foundation
import GenCommon
import TemplateConfig
import ValueReader
import RegexBuilder

public class SkipPlugin: GeneratorPlugin {
	let keyGroupReference = Reference(Substring.self)
	let codeGroupReference = Reference(Substring.self)

	private let config: TemplateConfig
	private let skipManager: SkipManager

	private lazy var variableMatchers = config.skipDelimiters.compactMap(variableMatcher(from:))

	public init(config: TemplateConfig, reader: ValueReader) {
		self.config = config
		self.skipManager = .init(reader: reader)
	}

	public func fileContents(piped: Data) throws -> Data {
		guard let text = String(data: piped, encoding: .utf8) else { return piped }
		let replaced = try replace(text: text)
		return replaced.data(using: .utf8) ?? piped
	}
}

private extension SkipPlugin {
	func replace(text: String) throws -> String {
		variableMatchers.reduce(text) { accum, matcher in
			accum.replacing(matcher) { match in
				let key = match[keyGroupReference].description
				guard !skipManager.skip(key: key) else { return "" }
				return match[codeGroupReference].description
			}
		}
	}

	func variableMatcher(from delimiter: String) -> Regex<(Substring, Substring, Substring)> {
		.init {
			ZeroOrMore(.horizontalWhitespace)
			delimiter
			Optionally(" ")
			Capture(as: keyGroupReference) {
				OneOrMore(.reluctant) {
					.anyNonNewline
				}
			}
			CharacterClass.newlineSequence
			Capture(as: codeGroupReference) {
				OneOrMore(.reluctant) {
					.any
				}
				CharacterClass.newlineSequence
			}
			ZeroOrMore(.horizontalWhitespace)
			delimiter
			CharacterClass.newlineSequence
		}
	}
}
