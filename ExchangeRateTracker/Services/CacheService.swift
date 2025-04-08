import Foundation

final class CacheService {
    static let shared = CacheService()
    private let defaults = UserDefaults.standard

    private init() {}

    func save<T: Codable>(_ object: T, forKey key: String) {
        guard let data = try? JSONEncoder().encode(object) else { return }
        defaults.set(data, forKey: key)
    }

    func load<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
