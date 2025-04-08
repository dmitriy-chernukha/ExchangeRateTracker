
import SwiftUI

struct AddAssetView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddAssetViewModel(
        currencyRepo: CurrencyRepository(
            networkService: NetworkService()
        ),
        cryptoRepo: CryptoRepository(
            networkService: NetworkService()
        ))
    
    var body: some View {
        List {
            Section(header: Text("Popular Currencies")) {
                ForEach(viewModel.filteredAssets()) { item in
                    AddAssetRow(item: item)
                        .environmentObject(viewModel)
                }
            }

            Section(header: Text("Cryptocurrencies")) {
                ForEach(viewModel.filtereCryptodAssets()) { item in
                    AddAssetRow(item: item)
                        .environmentObject(viewModel)
                }
            }
        }
        .listStyle(.insetGrouped)
        .searchable(text: $viewModel.searchText)
        .navigationTitle("Add Asset")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    viewModel.saveSelection()
                    dismiss()
                }
            }
        }
    }
}

struct AddAssetRow: View {
    let item: ExchangeItem

    @EnvironmentObject var viewModel: AddAssetViewModel
    
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

            if viewModel.isSelected(item.code, by: item.type) {
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 20, height: 20)
                    .background(Circle().fill(Color.black))
            } else {
                Circle()
                    .strokeBorder(Color.gray, lineWidth: 1)
                    .frame(width: 20, height: 20)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.toggleSelection(for: item.code, by: item.type)
        }
    }
}
