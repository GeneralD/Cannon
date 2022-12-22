import DefaultCodable

enum TemplateDelimiters: DefaultValueProvider {
	static let `default` = ["__"]
}

enum TemplateConstantDelimiters: DefaultValueProvider {
	static let `default` = ["$$"]
}

enum TemplateSkipDelimiters: DefaultValueProvider {
	static let `default` = ["//##"]
}

enum TemplateIgnore: DefaultValueProvider {
	static let `default` = ["config.yml", "config.yaml", "config.json", ".DS_Store", ".git"]
}

enum TemplateRootDirectoryName: DefaultValueProvider {
	static let `default`: String? = "$$Root Directory Name$$"
}
