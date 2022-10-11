import SwiftCLI

class VariableManager: ExpressibleByDictionaryLiteral {
	private var storage: [String : String] = [:]

	required init(dictionaryLiteral elements: (String, String)...) {
		storage = elements.reduce(into: [:]) { accum, pair in accum[pair.0] = pair.1 }
	}

	subscript(_ key: String) -> String {
		get {
			guard let value = storage.first(where: { $0.key == key })?.value else {
				let input = Input.readLine(prompt: "Input a value for variable \(key): ")
				storage[key] = input
				return input
			}
			return value
		}

		set {
			storage[key] = newValue
		}
	}
}
