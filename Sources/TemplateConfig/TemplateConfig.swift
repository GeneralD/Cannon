public protocol TemplateConfig {
	var delimiters: [String] { get }
	var constantDelimiters: [String] { get }
	var skipDelimiters: [String] { get }
	var ignore: [String] { get }
	var rootDirectoryName: String? { get }
}
