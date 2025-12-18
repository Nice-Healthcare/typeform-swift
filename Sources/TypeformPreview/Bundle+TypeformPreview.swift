import Foundation

public extension Bundle {
    static var typeformPreview: Bundle { Bundle.module }

    func decode<T>(
        _ type: T.Type,
        forResource resource: String,
        withExtension: String = "json",
        using decoder: JSONDecoder = JSONDecoder()
    ) throws -> T where T: Decodable {
        guard let url = url(forResource: resource, withExtension: withExtension) else {
            throw URLError(.badURL)
        }

        let data = try Data(contentsOf: url)

        return try decoder.decode(T.self, from: data)
    }

    func decode<T: Decodable>(
        forResource resource: String,
        withExtension: String = "json",
        using decoder: JSONDecoder = JSONDecoder()
    ) throws -> T {
        guard let url = url(forResource: resource, withExtension: withExtension) else {
            throw URLError(.badURL)
        }

        let data = try Data(contentsOf: url)

        return try decoder.decode(T.self, from: data)
    }
}
