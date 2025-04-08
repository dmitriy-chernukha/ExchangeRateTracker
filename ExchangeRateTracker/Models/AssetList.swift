import Foundation

struct AssetList {
    static let popularAssets: [ExchangeItem] = [
        .init(code: "USD", name: "US Dollar", iconName: "dollarsign.circle", type: .currency),
        .init(code: "EUR", name: "Euro", iconName: "eurosign.circle", type: .currency),
        .init(code: "GBP", name: "British Pound", iconName: "sterlingsign.circle", type: .currency),
        .init(code: "JPY", name: "Japanese Yen", iconName: "yensign.circle", type: .currency)
    ]
    
    static let cryptoAssets: [ExchangeItem] = [
        .init(code: "BTC", name: "Bitcoin", iconName: "bitcoinsign.circle", type: .crypto),
        .init(code: "ETH", name: "Ethereum", iconName: "e.circle", type: .crypto),
        .init(code: "USDT", name: "Tether", iconName: "t.circle", type: .crypto),
        .init(code: "BNB", name: "Binance Coin", iconName: "b.circle", type: .crypto),
        .init(code: "XRP", name: "Ripple", iconName: "x.circle", type: .crypto)
    ]
}

extension AssetList {
    static func name(for code: String) -> String {
        let allAssets = popularAssets + cryptoAssets
        return allAssets.first { $0.code.uppercased() == code.uppercased() }?.name ?? code.uppercased()
    }
}

extension AssetList {
    static func icon(for code: String) -> String {
        let allAssets = popularAssets + cryptoAssets
        return allAssets.first { $0.code.uppercased() == code.uppercased() }?.iconName ?? "circle"
    }
}
