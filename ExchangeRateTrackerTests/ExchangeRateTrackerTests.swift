import XCTest
@testable import ExchangeRateTracker

final class ExchangeRateTrackerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testExchangeItemEquality() {
        let item1 = ExchangeItem(code: "BTC", name: "Bitcoin", value: 30000, change: 1.5, iconName: "btc", type: .crypto)
        let item2 = ExchangeItem(code: "BTC", name: "Bitcoin", value: 30000, change: 1.5, iconName: "btc", type: .crypto)

        XCTAssertEqual(item1, item2)
    }

    func testExchangeItemSorting() {
        let items = [
            ExchangeItem(code: "ETH", name: "Ethereum", value: 2000, change: nil, iconName: "eth", type: .crypto),
            ExchangeItem(code: "USD", name: "US Dollar", value: 1, change: nil, iconName: "usd", type: .currency),
            ExchangeItem(code: "BTC", name: "Bitcoin", value: 40000, change: nil, iconName: "btc", type: .crypto)
        ]

        let sorted = items.sorted {
            if $0.type == $1.type {
                return $0.name < $1.name
            } else {
                return $0.type.rawValue < $1.type.rawValue
            }
        }

        XCTAssertEqual(sorted.map(\.code), ["USD", "BTC", "ETH"])
    }
}
