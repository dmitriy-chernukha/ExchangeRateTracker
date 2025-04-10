
protocol CryptoRepositoryProtocol {
    func fetchItems(for symbols: [String], in currency: String) async throws -> [ExchangeItem]
}

final class CryptoRepository: CryptoRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    private let cache: CacheStorage
    private let cacheKey = "cached_crypto_items"


    init(networkService: NetworkServiceProtocol, cache: CacheStorage = CacheService.shared) {
        self.networkService = networkService
        self.cache = cache
    }

    func fetchItems(for symbols: [String], in currency: String = "usd") async throws -> [ExchangeItem] {

        guard symbols.isEmpty == false else {
            return []
        }
        
        let response: CryptoCompareFullPriceResponse = try await networkService.fetch(
            CryptoAPI.fullPrices(symbols: symbols, convert: currency)
        )

        let items: [ExchangeItem] = symbols.compactMap { symbol in
            guard let raw = response.RAW[symbol]?[currency.uppercased()] else { return nil }

            return ExchangeItem(
                code: symbol,
                name: AssetList.name(for: symbol),
                value: raw.PRICE,
                change: raw.CHANGEPCT24HOUR,
                iconName: AssetList.icon(for: symbol),
                type: .crypto
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
