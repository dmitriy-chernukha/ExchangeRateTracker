import Foundation

final class AddAssetViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var selectedCryptoCodes: Set<String> = []
    @Published var selectedCurrencyCodes: Set<String> = []
    
    private let currencyRepo: CurrencyRepository
    private let cryptoRepo: CryptoRepository

    
    var filteredAssetList: [ExchangeItem] = []
    var filteredCryptoAssetList: [ExchangeItem] = []

    init(currencyRepo: CurrencyRepository, cryptoRepo: CryptoRepository) {
        
        self.currencyRepo = currencyRepo
        self.cryptoRepo = cryptoRepo
        
        selectedCryptoCodes = Set(UserAssetStore().load(for: .crypto))
        selectedCurrencyCodes = Set(UserAssetStore().load(for: .currency))
                
        filteredAssetList = AssetList.popularAssets
        filteredCryptoAssetList = AssetList.cryptoAssets
    }

    func toggleSelection(for code: String, by type: AssetType) {
        
        switch type {
        case .crypto:
            if self.selectedCryptoCodes.contains(code) {
                self.selectedCryptoCodes.remove(code)
            } else {
                self.selectedCryptoCodes.insert(code)
            }
        case .currency:
            if self.selectedCurrencyCodes.contains(code) {
                self.selectedCurrencyCodes.remove(code)
            } else {
                self.selectedCurrencyCodes.insert(code)
            }
        }
    }

    func isSelected(_ code: String, by type: AssetType) -> Bool {
        switch type {
            case .crypto:
            return selectedCryptoCodes.contains(code)
        case .currency:
            return selectedCurrencyCodes.contains(code)
        }
    }

    func saveSelection() {
        let store = UserAssetStore()
        store.save(Array(selectedCryptoCodes), for: .crypto)
        store.save(Array(selectedCurrencyCodes), for: .currency)
                
        currencyRepo.removeUnselectedFromCache(selected: Array(selectedCurrencyCodes))
        cryptoRepo.removeUnselectedFromCache(selected: Array(selectedCryptoCodes))
    }
    

    func filteredAssets() -> [ExchangeItem] {
        guard !searchText.isEmpty else { return filteredAssetList }
        return filteredAssetList.filter {
            $0.code.localizedCaseInsensitiveContains(searchText)
            || $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    func filtereCryptodAssets() -> [ExchangeItem] {
        guard !searchText.isEmpty else { return filteredCryptoAssetList }
        return filteredCryptoAssetList.filter {
            $0.code.localizedCaseInsensitiveContains(searchText)
            || $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }

}
