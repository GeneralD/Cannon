import Files
import Foundation
import Regex
import SwiftCLI

extension Location {
	func gen(to outputPlace: Folder, config: TemplateConfig, variables: VariableManager = [:]) throws {
		let replaced = try config.escapedDelimiters.reduce(name) { accum, delimiter in
			// replace delimiter with value
			let matcher = try Regex(pattern: "\(delimiter)(.+?)\(delimiter)", groupNames: "fill")
			return matcher.replaceAll(in: accum) { match in
				guard let varName = match.group(named: "fill") else { return "" }
				return variables[varName]
			}
		}
		switch self {
		case let file as File:
			try outputPlace.createFile(named: replaced, contents: file.contents(templateConfig: config, variables: variables))
		case let folder as Folder:
			let generatedFolder = try outputPlace.createSubfolder(named: replaced)
			// generate folders recursively
			try folder.subfolders.forEach { folder in
				try folder.gen(to: generatedFolder, config: config, variables: variables)
			}
			// generate files
			try folder.files.forEach { file in
				try file.gen(to: generatedFolder, config: config, variables: variables)
			}

		default:
			break
		}
	}
}

extension File {
	func contents(templateConfig: TemplateConfig, variables: VariableManager = [:]) -> Data? {
		guard let contents = try? readAsString(encodedAs: .utf8) else { return try? read() }
		let replaced = try? templateConfig.escapedDelimiters.reduce(contents) { accum, delimiter in
			let matcher = try Regex(pattern: "\(delimiter)(.+?)\(delimiter)", groupNames: "fill")
			return matcher.replaceAll(in: accum) { match in
				guard let varName = match.group(named: "fill") else { return "" }
				return variables[varName]
			}
		}
		return (replaced ?? contents).data(using: .utf8)
	}
}
