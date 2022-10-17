import Files
import Foundation
import GenCommon
import Regex
import SwiftCLI

extension Location {
	func gen(to outputPlace: Folder, isRoot: Bool = false, plugins: [GeneratorPlugin]) throws {
		let ignore = plugins.contains { plugin in
			plugin.shouldIgnore(name: name, kind: Self.kind)
		}
		guard !ignore else { return }

		let replaced = try plugins.reduce(name) { accum, plugin in
			try plugin.locationName(piped: accum, kind: Self.kind, isRoot: isRoot)
		}

		switch self {
		case let file as File:
			try outputPlace.createFile(named: replaced, contents: try plugins.reduce(file.read()) { accum, plugin in
				try plugin.fileContents(piped: accum)
			})

		case let folder as Folder:
			let generatedFolder = try outputPlace.createSubfolder(named: replaced)
			// generate folders recursively
			try folder.subfolders.includingHidden.forEach { folder in
				try folder.gen(to: generatedFolder, isRoot: false, plugins: plugins)
			}
			// generate files recursively
			try folder.files.includingHidden.forEach { file in
				try file.gen(to: generatedFolder, isRoot: false, plugins: plugins)
			}

		default:
			break
		}
	}
}
