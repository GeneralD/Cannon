import DefaultCodable
import TemplateConfig

struct TemplateConfigCodable: TemplateConfig, Codable, Equatable, DefaultValueProvider {
	static var `default`: Self { .init() }

	@Default<TemplateDelimiters> var delimiters: [String]
	@Default<TemplateConstantDelimiters> var constantDelimiters: [String]
	@Default<TemplateSkipDelimiters> var skipDelimiters: [String]
	@Default<TemplateIgnore> var ignore: [String]
	@Default<TemplateRootDirectoryName> var rootDirectoryName: String?
}
