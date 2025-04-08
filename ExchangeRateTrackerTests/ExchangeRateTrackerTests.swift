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


}
