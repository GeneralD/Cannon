import ValueReader

class SkipManager {
	private var storage: [String : Bool] = [:]

	private let reader: ValueReader

	init(reader: ValueReader) {
		self.reader = reader
	}

	func skip(key: String) -> Bool {
		guard let value = storage.first(where: { $0.key == key })?.value else {
			let input = reader.readBool(message: "Skip code for key \(key) (y/n): ", default: false)
			storage[key] = input
			return input
		}
		return value
	}
}
