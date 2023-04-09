import Files
import GenCommon
import TemplateConfig

public class IgnorePlugin: GeneratorPlugin {
	private let ignore: [Regex<AnyRegexOutput>]

	public init(config: TemplateConfig) {
		ignore = config.ignore
			.compactMap { try? Regex("^\($0)$") }
	}

	public func shouldIgnore(name: String, kind: LocationKind) -> Bool {
		ignore.contains(where: name.contains)
	}
}
