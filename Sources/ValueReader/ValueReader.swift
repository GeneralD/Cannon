public protocol ValueReader {
	func read(message: String) -> String
	func readInt(message: String, default: Int?) -> Int
	func readDouble(message: String, default: Double?) -> Double
	func readBool(message: String, default: Bool?) -> Bool
}
