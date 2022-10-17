import DefaultCodable

public struct TemplateConfig: Codable, Equatable {
	@Default<TemplateDelimiters> public var delimiters: [String]
	@Default<TemplateConstantDelimiters> public var constantDelimiters: [String]
	@Default<TemplateSkipDelimiters> public var skipDelimiters: [String]
	@Default<TemplateIgnore> public var ignore: [String]
	@Default<TemplateRootDirectoryName> public var rootDirectoryName: String?

	public init() {}
}
