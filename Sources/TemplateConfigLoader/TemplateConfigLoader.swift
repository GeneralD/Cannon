import TemplateConfig
import Files
import Foundation
import Yams

public struct TemplateConfigLoader {
	public init() {}

	public func loadConfig(from file: File) -> Result<any TemplateConfig, TemplateConfigLoaderError> {
		do {
			switch file.extension {
			case "yml", "yaml":
				return .success(try YAMLDecoder().decode(TemplateConfigCodable.self, from: file.read()))
			case "json":
				return .success(try JSONDecoder().decode(TemplateConfigCodable.self, from: file.read()))
			default:
				return .failure(.incompatibleFileExtension)
			}
		} catch {
			return .failure(.invalidConfigFile)
		}
	}

	public var defaultConfig: some TemplateConfig {
		TemplateConfigCodable.default
	}
}

public enum TemplateConfigLoaderError: Error {
	case incompatibleFileExtension
	case invalidConfigFile
}
