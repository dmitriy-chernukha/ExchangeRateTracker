import XCTest
@testable import ExchangeRateTracker

final class CurrencyRepositoryTests: XCTestCase {
    
    func testSuccessfulFetchStoresAndReturnsItems() async throws {
        let response = CurrencyRates(
            disclaimer: "",
            license: "",
            timestamp: Int(Date().timeIntervalSince1970),
            base: "USD",
            rates: ["EUR": 0.91, "GBP": 0.78]
        )

        let network = MockNetworkService(result: .success(response))
        let cache = InMemoryCache()
        let repo = CurrencyRepository(networkService: network, cache: cache)

        let items = try await repo.fetchItems(for: ["EUR", "GBP"])

        XCTAssertEqual(items.count, 2)
        XCTAssertTrue(items.contains(where: { $0.code == "EUR" }))
        XCTAssertTrue(items.contains(where: { $0.code == "GBP" }))

        let cached = cache.load(forKey: "cached_currency_items", as: [ExchangeItem].self)
        XCTAssertEqual(cached?.count, 2)
    }
}
