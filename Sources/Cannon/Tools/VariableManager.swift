import Kebab
import SwiftCLI

class VariableManager {
	private let detector = CaseDetector()
	private let converter = CaseConverter()
	private let normalCase: MultiWordIdentifier = .camelCase

	private var storage: [String : String] = [:]

	subscript(_ key: String) -> String {
		let normalizedKey = converter.convert(text: key, to: normalCase)
		guard let normalizedValue = storage.first(where: { $0.key == normalizedKey })?.value else {
			let input = Input.readLine(prompt: "Input a value for variable \(normalizedKey): ")
			storage[normalizedKey] = converter.convert(text: input, to: normalCase)
			return self[key]
		}
		return converter.convert(text: normalizedValue, from: normalCase, to: detector.detectCase(in: key))
	}
}
