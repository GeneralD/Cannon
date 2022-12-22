import Foundation
import GenCommon
import Regex
import TemplateConfig
import ValueReader

public class SkipPlugin: GeneratorPlugin {
	private let matchKeyGroupName = "code"
	private let matchCodeGroupName = "key"

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
			matcher.replaceAll(in: accum) { match in
				guard let key = match.group(named: matchKeyGroupName),
					  !skipManager.skip(key: key),
					  let code = match.group(named: matchCodeGroupName) else { return "" }
				return code
			}
		}
	}

	func variableMatcher(from delimiter: String) -> Regex? {
		let escapedDelimiter = ["\\", "*", "+", ".", "?", "{", "}", "(", ")", "[", "]", "^", "$", "-", "|", "/"]
			.reduce(delimiter) { $0.replacingOccurrences(of: $1, with: "\\\($1)") }
		let pattern = #"[\t ]*\#(escapedDelimiter) ?(.+?)\r?\n([\S\n\r\t ]+?\r?\n)[\t ]*\#(escapedDelimiter)\r?\n"#
		return try? Regex(pattern: pattern, options: .default, groupNames: matchKeyGroupName, matchCodeGroupName)
	}
}
