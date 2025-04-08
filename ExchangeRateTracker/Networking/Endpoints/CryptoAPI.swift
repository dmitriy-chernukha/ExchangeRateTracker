enum CryptoAPI: APIEndpoint {
    case fullPrices(symbols: [String], convert: String)

    var baseURL: String {
        "https://min-api.cryptocompare.com/data/"
    }

    var path: String {
        "pricemultifull"
    }

    var method: String { "GET" }

    var headers: [String: String] { [:] }

    var queryParameters: [String: String] {
        switch self {
        case .fullPrices(let symbols, let convert):
            return [
                "fsyms": symbols.joined(separator: ","),
                "tsyms": convert.uppercased()
            ]
        }
    }
}
