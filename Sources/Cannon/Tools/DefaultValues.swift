import DefaultCodable

enum TemplateDelimiters: DefaultValueProvider {
	static let `default` = ["__"]
}

enum TemplateConstantDelimiters: DefaultValueProvider {
	static let `default` = ["$$"]
}

enum TemplateIgnore: DefaultValueProvider {
	static let `default` = [".DS_Store", ".git"]
}
