import CoreGraphics
import DefaultCodable
import Regex

struct TemplateConfig: Codable, Equatable {
	static let empty: Self = .init(rootDirectoryName: nil)

	@Default<TemplateDelimiters> var delimiters: [String]
	@Default<TemplateConstantDelimiters> var constantDelimiters: [String]
	@Default<TemplateIgnore> var ignore: [String]
	let rootDirectoryName: String?
}

extension TemplateConfig {
	struct Delimiter {
		let chars: String
		let isConstant: Bool
	}

	var escapedAllDelimiters: [Delimiter] {
		delimiters
			.map(regexEscaped)
			.map { .init(chars: $0, isConstant: false) }
		+ constantDelimiters
			.map(regexEscaped)
			.map { .init(chars: $0, isConstant: true) }
	}

	private func regexEscaped(_ string: String) -> String {
		["\\", "*", "+", ".", "?", "{", "}", "(", ")", "[", "]", "^", "$", "-", "|", "/"]
			.reduce(string) { $0.replacingOccurrences(of: $1, with: "\\\($1)") }
	}
}
