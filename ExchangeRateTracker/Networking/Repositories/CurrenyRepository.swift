
protocol CurrencyRepositoryProtocol {
    func fetchItems(for codes: [String], base: String) async throws -> [ExchangeItem]
    func removeUnselectedFromCache(selected: [String])
}

final class CurrencyRepository {
    private let networkService: NetworkServiceProtocol
    private let cache = CacheService.shared
    private let cacheKey = "cached_currency_items"

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }

    func fetchItems(for codes: [String], base: String = "USD") async throws -> [ExchangeItem] {

        let response: CurrencyRates = try await networkService.fetch(
            CurrencyAPI.liveRates(base: base, symbols: codes)
        )
        
        let items = codes.compactMap { code -> ExchangeItem? in
            let key = "\(code.uppercased())"
            guard let rate = response.rates[key] else { return nil }
            
            return ExchangeItem(
                code: code,
                name: AssetList.name(for: code),
                value: rate,
                change: nil,
                iconName: AssetList.icon(for: code),
                type: .currency
            )
        }
        
        cache.save(items, forKey: cacheKey)
        
        return items
    }
    
    func removeUnselectedFromCache(selected: [String]) {
        let all = cache.load(forKey: cacheKey, as: [ExchangeItem].self) ?? []

        let filtered = all.filter { selected.contains($0.code) }
        cache.save(filtered, forKey: cacheKey)
    }
}
