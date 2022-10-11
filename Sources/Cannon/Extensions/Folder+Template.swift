import Files
import Regex
import SwiftCLI

extension Folder {
	func gen(to outputPlace: Folder, config: TemplateConfig) throws {
		let replaced = try config.delimiters.map { delimiter in
			// escape chars in delimter
			["\\", "*", "+", ".", "?", "{", "}", "(", ")", "[", "]", "^", "$", "-", "|", "/"].reduce(delimiter) { accum, c in
				accum.replacingOccurrences(of: c, with: "\\\(c)")
			}
		}.reduce(name) { accum, delimiter in
			// replace delimiter with value
			let matcher = try Regex(pattern: "\(delimiter)(.+?)\(delimiter)", groupNames: "fill")
			return matcher.replaceAll(in: accum) { match in
				guard let varName = match.group(named: "fill") else { return "" }
				// TODO: create something nice variable manager
				return ["foo": "bar"].first { $0.key == varName }?.value ?? Input.readLine(prompt: "Input a value for variable \(varName): ")
			}
		}
		let generatedFolder = try outputPlace.createSubfolder(named: replaced)
		// recursively
		try subfolders.forEach { folder in
			try folder.gen(to: generatedFolder, config: config)
		}
	}
}
