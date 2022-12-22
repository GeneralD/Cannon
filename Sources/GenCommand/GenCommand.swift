import Files
import Foundation
import FillVariablesPlugin
import GenCommon
import IgnorePlugin
import SkipPlugin
import SwiftCLI
import Yams

public class GenCommand: Command {

	// MARK: - Arguments

	@Param(completion: .filename)
	var inputFolder: Folder

	@Key("-o", "--output-dir", description: "Output destination (default is ~/Documents/Cannon/)", completion: .filename)
	var outputFolder: Folder!

	// MARK: - Command Implementations

	public let name: String
	public let shortDescription = "Copy a template and fill variables"

	public init(name: String) {
		self.name = name
	}

	public func execute() throws {
		try configureArguments()

		let config = loadConfig()
		let reader = PromptValueReader()

		try inputFolder.gen(to: outputFolder, isRoot: true, plugins: [
			IgnorePlugin(config: config),
			SkipPlugin(config: config, reader: reader),
			FillVariablesPlugin(config: config, reader: reader),
		])
	}
}

private extension GenCommand {

	// MARK: - Configure Default Values

	func configureArguments() throws {
		try configureOutputFolder()
	}

	func configureOutputFolder() throws {
		guard outputFolder == nil else { return }
		let location = Input.readLine(prompt: "Output location: ")
		do {
			$outputFolder.update(to: try Folder(path: location))
		} catch {
			stderr <<< "\(location) is not a directory"
			throw error
		}
	}

	// MARK: - Load Config File

	func loadConfig() -> TemplateConfig {
		guard let file = inputFolder.files.first(where: { $0.nameExcludingExtension == "config" }) else {
			stderr <<< "Config file not found in \(inputFolder.name)"
			stdout <<< "But still ok! We can continue processing..."
			return .init()
		}

		do {
			switch file.extension {
			case "yml", "yaml":
				return try YAMLDecoder().decode(TemplateConfig.self, from: file.read())
			case "json":
				return try JSONDecoder().decode(TemplateConfig.self, from: file.read())
			default:
				stderr <<< "Incompatible file extension: \(file.name)"
				stdout <<< "But still ok! We can continue processing..."
				return .init()
			}
		} catch {
			stderr <<< "No valid config file!"
			stdout <<< "But still ok! We can continue processing..."
			return .init()
		}
	}
}
