import DefaultCodable

struct TemplateConfig: Codable, Equatable {
	@Default<TemplateDelimiters> var delimiters: [String]
	@Default<TemplateConstantDelimiters> var constantDelimiters: [String]
	@Default<TemplateIgnore> var ignore: [String]
	@Default<TemplateRootDirectoryName> var rootDirectoryName: String?
}
