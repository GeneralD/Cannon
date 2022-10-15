import Files
import Foundation
import Regex

class FillVariablesPlugin: GeneratorPlugin {
	private let config: TemplateConfig
	private let variables: VariableManager

	init(config: TemplateConfig, variables: VariableManager) {
		self.config = config
		self.variables = variables
	}

	func locationName(piped: String, kind: LocationKind, isRoot: Bool) throws -> String {
		let locationName = isRoot ? config.rootDirectoryName ?? piped : piped
		return try replace(text: locationName)
	}

	func fileContents(piped: Data) throws -> Data {
		guard let text = String(data: piped, encoding: .utf8) else { return piped }
		let replaced = try replace(text: text)
		return replaced.data(using: .utf8) ?? piped
	}

	private func replace(text: String) throws -> String {
		return try config.escapedAllDelimiters.reduce(text) { accum, delimiter in
			let matcher = try Regex(pattern: "\(delimiter.chars)([a-zA-Z\\d \\-_\\|]+?)\(delimiter.chars)", groupNames: "fill")
			let fun = delimiter.isConstant ? variables.constantValue(for:) : variables.value(for:)
			return matcher.replaceAll(in: accum) { match in match.group(named: "fill").map(fun) ?? "" }
		}
	}
}
