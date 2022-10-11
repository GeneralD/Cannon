import CoreGraphics
import DefaultCodable
import Foundation

struct TemplateConfig: Codable, Equatable {
	static let empty: Self = .init()

	@Default<Empty> var delimiters: [String]
}
