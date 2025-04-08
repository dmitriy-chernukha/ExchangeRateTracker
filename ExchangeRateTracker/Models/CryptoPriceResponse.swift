import Foundation

struct CryptoPriceResponse: Decodable {
    let bpi: [String: CryptoPrice]

    struct CryptoPrice: Decodable {
        let code: String
        let rate: String
        let description: String
        let rate_float: Double
    }
}
