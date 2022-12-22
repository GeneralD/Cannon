import Files
import Foundation
import FillVariablesPlugin
import GenCommon
import IgnorePlugin
import SkipPlugin
import SwiftCLI
import TemplateConfig
import TemplateConfigLoader
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

	func loadConfig() -> any TemplateConfig {
		let loader = TemplateConfigLoader()

		guard let file = inputFolder.files.first(where: { $0.nameExcludingExtension == "config" }) else {
			stderr <<< "Config file not found in \(inputFolder.name)"
			stdout <<< "But still ok! We can continue processing..."
			return loader.defaultConfig
		}

		switch loader.loadConfig(from: file) {
		case .success(let config):
			return config
		case .failure(.incompatibleFileExtension):
			stderr <<< "Incompatible file extension: \(file.name)"
			stdout <<< "But still ok! We can continue processing..."
			return loader.defaultConfig
		case .failure(.invalidConfigFile):
			stderr <<< "No valid config file!"
			stdout <<< "But still ok! We can continue processing..."
			return loader.defaultConfig
		}
	}
}
