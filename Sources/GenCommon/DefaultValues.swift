import DefaultCodable

public enum TemplateDelimiters: DefaultValueProvider {
	public static let `default` = ["__"]
}

public enum TemplateConstantDelimiters: DefaultValueProvider {
	public static let `default` = ["$$"]
}

public enum TemplateSkipDelimiters: DefaultValueProvider {
	public static let `default` = ["//##"]
}

public enum TemplateIgnore: DefaultValueProvider {
	public static let `default` = ["config.yml", "config.yaml", "config.json", ".DS_Store", ".git"]
}

public enum TemplateRootDirectoryName: DefaultValueProvider {
	public static let `default`: String? = "$$Root Directory Name$$"
}
