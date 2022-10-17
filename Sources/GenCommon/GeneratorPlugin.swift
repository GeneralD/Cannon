import Files
import Foundation

public protocol GeneratorPlugin {
	func shouldIgnore(name: String, kind: LocationKind) -> Bool
	func locationName(piped: String, kind: LocationKind, isRoot: Bool) throws -> String
	func fileContents(piped: Data) throws -> Data
}

public extension GeneratorPlugin {
	func shouldIgnore(name: String, kind: LocationKind) -> Bool { false }
	func locationName(piped: String, kind: LocationKind, isRoot: Bool) throws -> String { piped }
	func fileContents(piped: Data) throws -> Data { piped }
}
