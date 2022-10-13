import Files
import Foundation
import Regex
import SwiftCLI

extension Location {
	func gen(to outputPlace: Folder, config: TemplateConfig, variables: VariableManager, isRoot: Bool = false) throws {
		// check if the file is in ignore list
		guard !config.ignore
			.compactMap({ "^\($0)$".r })
			.contains(where: { $0.matches(name) }) else { return }

		let locationName = isRoot ? config.rootDirectoryName ?? name : name
		let replaced = try replace(text: locationName, templateConfig: config, variables: variables)

		switch self {
		case let file as File:
			try outputPlace.createFile(named: replaced, contents: file.contents(templateConfig: config, variables: variables))

		case let folder as Folder:
			let generatedFolder = try outputPlace.createSubfolder(named: replaced)
			// generate folders recursively
			try folder.subfolders.includingHidden.forEach { folder in
				try folder.gen(to: generatedFolder, config: config, variables: variables)
			}
			// generate files recursively
			try folder.files.includingHidden.forEach { file in
				try file.gen(to: generatedFolder, config: config, variables: variables)
			}

		default:
			break
		}
	}
}

private extension File {
	func contents(templateConfig: TemplateConfig, variables: VariableManager = .init()) -> Data? {
		guard let contents = try? readAsString(encodedAs: .utf8) else { return try? read() }
		let replaced = try? replace(text: contents, templateConfig: templateConfig, variables: variables)
		return (replaced ?? contents).data(using: .utf8)
	}
}

private func replace(text: String, templateConfig: TemplateConfig, variables: VariableManager = .init()) throws -> String {
	return try templateConfig.escapedAllDelimiters.reduce(text) { accum, delimiter in
		let matcher = try Regex(pattern: "\(delimiter.chars)([a-zA-Z\\d \\-_\\|]+?)\(delimiter.chars)", groupNames: "fill")
		let fun = delimiter.isConstant ? variables.constantValue(for:) : variables.value(for:)
		return matcher.replaceAll(in: accum) { match in match.group(named: "fill").map(fun) ?? "" }
	}
}
