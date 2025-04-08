import Foundation

struct CryptoCompareFullPriceResponse: Decodable {
    let RAW: [String: [String: RawPrice]]

    struct RawPrice: Decodable {
        let PRICE: Double
        let CHANGEPCT24HOUR: Double?
    }
}
