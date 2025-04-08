import Foundation

final class InMemoryCache: CacheStorage {
    private var storage: [String: Data] = [:]

    func save<T: Codable>(_ object: T, forKey key: String) {
        storage[key] = try? JSONEncoder().encode(object)
    }

    func load<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        guard let data = storage[key] else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
