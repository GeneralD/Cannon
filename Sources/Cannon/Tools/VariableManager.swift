import Kebab
import SwiftCLI

class VariableManager {
	private let detector = CaseDetector()
	private let converter = CaseConverter()
	private let normalCase: MultiWordIdentifier = .camelCase

	private var storage: [String : String] = [:]
	private var constantStorage: [String : String] = [:]

	func value(for key: String) -> String {
		let normalizedKey = converter.convert(text: key, to: normalCase)
		guard let storedValue = storage.first(where: { $0.key == normalizedKey })?.value else {
			let input = Input.readLine(prompt: "Input a value for variable \(normalizedKey): ")
			storage[normalizedKey] = converter.convert(text: input, to: normalCase)
			return value(for: key)
		}
		return converter.convert(text: storedValue, from: normalCase, to: detector.detectCase(in: key))
	}

	func constantValue(for key: String) -> String {
		guard let storedValue = constantStorage.first(where: { $0.key == key })?.value else {
			constantStorage[key] = Input.readLine(prompt: "Input a value for \(key): ")
			return constantValue(for: key)
		}
		return storedValue
	}
}
