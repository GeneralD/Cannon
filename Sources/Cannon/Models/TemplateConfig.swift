import CoreGraphics
import DefaultCodable
import Regex

struct TemplateConfig: Codable, Equatable {
	static let empty: Self = .init()

	@Default<Empty> var delimiters: [String]
	@Default<Empty> var ignore: [String]
}

extension TemplateConfig {
	var escapedDelimiters: [String] {
		let reservedChars = ["\\", "*", "+", ".", "?", "{", "}", "(", ")", "[", "]", "^", "$", "-", "|", "/"]
		return delimiters.map { delimiter in
			reservedChars.reduce(delimiter) { $0.replacingOccurrences(of: $1, with: "\\\($1)") }
		}
	}
}
