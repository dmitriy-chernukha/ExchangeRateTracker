import SwiftUI

struct ExchangeRatesView: View {
    
//    @StateObject private var viewModel = ExchangeRatesViewModel(
//        currencyRepo: CurrencyRepository(networkService: NetworkService(), cache: CacheService()),
//        cryptoRepo: CryptoRepository(networkService: NetworkService(), cache: CacheService()),
//        cache: CacheService()
//    )
    @ObservedObject var viewModel: ExchangeRatesViewModel
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.items.isEmpty && !viewModel.isLoading {
                    Text("No data available, please add an assets")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.items) { item in
                            ExchangeRateRow(item: item)
                                .transition(.move(edge: .leading))
                                .swipeActions {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            viewModel.remove(item: item)
                                        }
                                    } label: {
                                        Label("Remove", systemImage: "trash")
                                    }
                                    .tint(.red)
                                }
                        }
                    }
                }
            }
            .navigationTitle("Exchange Rates")
            .refreshable {
                await viewModel.load()
            }
            .task {
                await viewModel.load()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddAssetView()) {
                        addButtonView()
                    }
                }
            }
            .onAppear {
                viewModel.loadFromCache()
                viewModel.startAutoRefresh()
            }
            .onDisappear {
                viewModel.stopAutoRefresh()
            }
            .alert(item: $viewModel.errorMessage) { alert in
                Alert(
                    title: Text("Error"),
                    message: Text(alert.message),
                    dismissButton: .default(Text("OK"))
                )
            }
            .animation(.spring(), value: viewModel.items)
        }
        .tint(.primary)

    }
    
    private func addButtonView() -> some View {
        Image(systemName: "plus")
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.primary)
            .frame(width: 32, height: 32)
            .background(Circle().fill(Color.gray.opacity(0.2)))
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
    }

}

struct ExchangeRateRow: View {
    let item: ExchangeItem

    var body: some View {
        HStack {
            Image(systemName: item.iconName)
                .frame(width: 36, height: 36)
                .background(Color.gray.opacity(0.1))
                .clipShape(Circle())

            VStack(alignment: .leading) {
                Text(item.code)
                    .font(.headline)
                Text(item.name)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing) {
                
                switch item.type {
                case.crypto:
                    Text(String(format: "%.2f", item.value))
                        .font(.headline)
                case .currency:
                    Text(String(format: "%.4f", item.value))
                        .font(.headline)
                }

                if let change = item.change {
                    Text(String(format: "%+.2f%%", change))
                        .font(.caption2)
                        .foregroundColor(change >= 0 ? .green : .red)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
