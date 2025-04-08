import Foundation

final class UserAssetStore {
        
    private let currencyKey = "selected_currency_codes"
    private let cryptoKey = "selected_crypto_codes"
    private let defaults = UserDefaults.standard

    func load(for type: AssetType) -> [String] {
        switch type {
        case .currency:
            return defaults.stringArray(forKey: currencyKey) ?? []
        case .crypto:
            return defaults.stringArray(forKey: cryptoKey) ?? []
        }
    }

    func save(_ codes: [String], for type: AssetType) {
        switch type {
        case .currency:
            defaults.set(codes, forKey: currencyKey)
        case .crypto:
            defaults.set(codes, forKey: cryptoKey)
        }
    }

    func add(_ code: String, for type: AssetType) {
        var current = load(for: type)
        guard !current.contains(code.uppercased()) else { return }
        current.append(code.uppercased())
        save(current, for: type)
    }

    func remove(_ code: String, for type: AssetType) {
        let filtered = load(for: type).filter { $0.uppercased() != code.uppercased() }
        save(filtered, for: type)
    }
}
