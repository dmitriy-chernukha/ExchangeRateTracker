
enum AssetType: String, Codable {
    case currency
    case crypto
}

struct ExchangeItem: Identifiable, Codable, Equatable {
    let id: String
    let code: String
    let name: String
    let value: Double
    let change: Double?
    let iconName: String
    let type: AssetType

    init(code: String, name: String, value: Double = 0, change: Double? = nil, iconName: String, type: AssetType) {
        self.id = "\(type.rawValue)_\(code.uppercased())"
        self.code = code.uppercased()
        self.name = name
        self.value = value
        self.change = change
        self.iconName = iconName
        self.type = type
    }
    
}
