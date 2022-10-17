import Files
import GenCommon
import Regex

public class IgnorePlugin: GeneratorPlugin {
	private let ignore: [Regex]

	public init(config: TemplateConfig) {
		ignore = config.ignore
			.map { "^\($0)$" }
			.compactMap(\.r)
	}

	public func shouldIgnore(name: String, kind: LocationKind) -> Bool {
		ignore.contains { $0.matches(name) }
	}
}
