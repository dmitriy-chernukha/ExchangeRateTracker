import XCTest
@testable import ExchangeRateTracker

final class CryptoRepositoryTests: XCTestCase {

    func testSuccessfulCryptoFetch() async throws {
        let response = CryptoCompareFullPriceResponse(
            RAW: [
                "BTC": ["USD": CryptoCompareFullPriceResponse.RawPrice(PRICE: 40000, CHANGEPCT24HOUR: 200)],
                "ETH": ["USD": CryptoCompareFullPriceResponse.RawPrice(PRICE: 2000, CHANGEPCT24HOUR: -50)]
            ]
        )

        let network = MockNetworkService(result: .success(response))
        let cache = InMemoryCache()
        let repo = CryptoRepository(networkService: network, cache: cache)

        let items = try await repo.fetchItems(for: ["BTC", "ETH"])

        XCTAssertEqual(items.count, 2)
        XCTAssertTrue(items.contains { $0.code == "BTC" && $0.value == 40000 })
        XCTAssertTrue(items.contains { $0.code == "ETH" && $0.change == -50 })
    }
}
