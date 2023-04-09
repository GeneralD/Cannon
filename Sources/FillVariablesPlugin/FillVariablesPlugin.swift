import Files
import Foundation
import GenCommon
import TemplateConfig
import ValueReader
import RegexBuilder

public class FillVariablesPlugin: GeneratorPlugin {
	private let fillGroupReference = Reference(Substring.self)

	private let config: TemplateConfig
	private let variables: VariableManager

	private lazy var variableMatchers = config.delimiters.compactMap(variableMatcher(from:))
	private lazy var constantVariableMatchers: [Regex] = config.constantDelimiters.compactMap(variableMatcher(from:))
	private lazy var replacers = variableMatchers.map { ($0, variables.value(for:)) } + constantVariableMatchers.map { ($0, variables.constantValue(for:)) }

	public init(config: TemplateConfig, reader: ValueReader) {
		self.config = config
		self.variables = .init(reader: reader)
	}

	public func locationName(piped: String, kind: LocationKind, isRoot: Bool) throws -> String {
		let locationName = isRoot ? config.rootDirectoryName ?? piped : piped
		return try replace(text: locationName)
	}

	public func fileContents(piped: Data) throws -> Data {
		guard let text = String(data: piped, encoding: .utf8) else { return piped }
		let replaced = try replace(text: text)
		return replaced.data(using: .utf8) ?? piped
	}
}

private extension FillVariablesPlugin {
	func replace(text: String) throws -> String {
		replacers.reduce(text) { accum, tuple in
			let (matcher, valueFor) = tuple
			return accum.replacing(matcher) { match in
				valueFor(match[fillGroupReference].description)
			}
		}
	}

	func variableMatcher(from delimiter: String) -> Regex<(Substring, Substring)> {
		Regex {
			delimiter
			Capture(as: fillGroupReference) {
				OneOrMore(.reluctant) {
					CharacterClass(.word, .anyOf(" |-"))
				}
			}
			delimiter
		}
	}
}
