
enum CurrencyAPI: APIEndpoint {
    case liveRates(base: String, symbols: [String])

    var baseURL: String {
        "https://openexchangerates.org/api/"
    }

    var path: String {
        return "latest.json"
    }

    var method: String { "GET" }

    var headers: [String: String] { [:] }

    var queryParameters: [String: String] {
        switch self {
        case .liveRates(let base, let symbols):
            return [
                "app_id": "cf4d63815614474d805d31f981708580",
                "base": base.uppercased(),
                "symbols": symbols.map { $0.uppercased() }.joined(separator: ",")
            ]
        }
    }
}

