import Files
import Regex

class IgnorePlugin: GeneratorPlugin {
	private let ignore: [Regex]

	init(config: TemplateConfig) {
		ignore = config.ignore
			.map { "^\($0)$" }
			.compactMap(\.r)
	}

	func shouldIgnore(name: String, kind: LocationKind) -> Bool {
		ignore.contains { $0.matches(name) }
	}
}
