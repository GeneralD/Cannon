import AppKit
import Files
import SwiftCLI
import Yams

class GenCommand: Command {

	// MARK: - Arguments

	@Param(completion: .filename)
	var inputFolder: Folder

	@Key("-o", "--output-dir", description: "Output destination (default is ~/Documents/Cannon/)", completion: .filename)
	var outputFolder: Folder!

	// MARK: - Command Implementations

	let name = "gen"

	func execute() throws {
		try configureArguments()

		let config = loadConfig()
		try inputFolder.gen(to: outputFolder, config: config, variables: .init(), isRoot: true)
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
			return .empty
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
				return .empty
			}
		} catch {
			stderr <<< "No valid config file!"
			stdout <<< "But still ok! We can continue processing..."
			return .empty
		}
	}
}
