import SwiftUI

@main
struct ExchangeRateTrackerApp: App {
    
    
    var body: some Scene {
        
        let viewModel = ExchangeRatesViewModel(
            currencyRepo: CurrencyRepository(networkService: NetworkService()),
            cryptoRepo: CryptoRepository(networkService: NetworkService())
        )
        
        WindowGroup {
            ExchangeRatesView(viewModel: viewModel)
        }
    }
}
