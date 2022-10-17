import SwiftCLI
import ValueReader

class PromptValueReader: ValueReader {
	func read(message: String) -> String {
		Input.readLine(prompt: message)
	}

	func readInt(message: String, default: Int?) -> Int {
		Input.readInt(prompt: message, defaultValue: `default`)
	}

	func readDouble(message: String, default: Double?) -> Double {
		Input.readDouble(prompt: message, defaultValue: `default`)
	}

	func readBool(message: String, default: Bool?) -> Bool {
		Input.readBool(prompt: message, defaultValue: `default`)
	}
}
