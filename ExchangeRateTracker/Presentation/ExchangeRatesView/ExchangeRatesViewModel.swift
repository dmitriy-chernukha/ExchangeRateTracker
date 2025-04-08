import Foundation
import Combine

struct AlertMessage: Identifiable {
    var id: String { message }
    let message: String
}

final class ExchangeRatesViewModel: ObservableObject {
    @Published var items: [ExchangeItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: AlertMessage? = nil
    
    private let currencyRepo: CurrencyRepository
    private let cryptoRepo: CryptoRepository

    private var currencyCodes: [String] = []
    private var cryptoCodes: [String] = []
    
    private var refreshTask: Task<Void, Never>?

    init(currencyRepo: CurrencyRepository , cryptoRepo: CryptoRepository) {
        self.currencyRepo = currencyRepo
        self.cryptoRepo = cryptoRepo
        
        loadFromCache()
    }
    
    func startAutoRefresh(interval: TimeInterval = 3) {
        refreshTask?.cancel()
        refreshTask = Task {
            while !Task.isCancelled {
                await load()
                try? await Task.sleep(nanoseconds: UInt64(interval * 1_000_000_000))
            }
        }
    }

    func stopAutoRefresh() {
        refreshTask?.cancel()
        refreshTask = nil
    }
    
    func loadFromCache() {
        
        cryptoCodes = UserAssetStore().load(for: .crypto)
        currencyCodes = UserAssetStore().load(for: .currency)

        let currencyItems = CacheService.shared.load(forKey: "cached_currency_items", as: [ExchangeItem].self) ?? []
        let cryptoItems = CacheService.shared.load(forKey: "cached_crypto_items", as: [ExchangeItem].self) ?? []
        let combined = currencyItems + cryptoItems
        self.items = combined.sorted {
            if $0.type == $1.type {
                return $0.name < $1.name
            } else {
                return $0.type.rawValue < $1.type.rawValue
            }
        }
    }
    
    func load() async {
                
        await MainActor.run {
            isLoading = true
        }
        do {
            guard cryptoCodes.isEmpty == false, currencyCodes.isEmpty == false else {
                return
            }

            async let fiat = currencyRepo.fetchItems(for: currencyCodes)
            async let crypto = cryptoRepo.fetchItems(for: cryptoCodes)
            let (fiatItems, cryptoItems) = try await (fiat, crypto)

            await MainActor.run {
                
                let combined = fiatItems + cryptoItems
                self.items = combined.sorted {
                    if $0.type == $1.type {
                        return $0.name < $1.name
                    } else {
                        return $0.type.rawValue < $1.type.rawValue
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
            
            await MainActor.run {
                self.errorMessage = AlertMessage(message: "Unable to fetch data. Showing last known values. Please try again later.")
            }
        }
        
        await MainActor.run {
            isLoading = false
        }

    }
    
    func remove(item: ExchangeItem) {
        items.removeAll { $0.id == item.id }
        UserAssetStore().remove(item.code, for: item.type)
        cryptoCodes = UserAssetStore().load(for: .crypto)
        currencyCodes = UserAssetStore().load(for: .currency)
    }
}
