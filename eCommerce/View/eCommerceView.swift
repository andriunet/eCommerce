//
//  eCommerceView.swift
//  eCommerce
//
//  Created by Andres Marin on 17/01/26.
//

import SwiftUI
import Combine

struct eCommerceView: View {
    @StateObject private var viewModel = SearchViewModel()
        
        var body: some View {
            NavigationStack {
                VStack {
                    if viewModel.products.isEmpty && viewModel.state == .idle {
                        HistoryView(viewModel: viewModel)
                        
                    } else if viewModel.products.isEmpty && viewModel.state == .loading {
                        ProgressView("Buscando...")
                            .frame(maxHeight: .infinity)
                        
                    } else if viewModel.products.isEmpty && viewModel.state == .loaded {
                        ContentUnavailableView("Sin resultados", systemImage: "magnifyingglass", description: Text("Intenta otra búsqueda."))
                        
                    } else {
                        ProductListView(viewModel: viewModel)
                    }
                }
                .navigationTitle("eCommerce")
                .searchable(text: $viewModel.searchText, prompt: "Buscar productos")
                .onChange(of: viewModel.searchText) { oldValue, newValue in
                    if newValue.isEmpty {
                        viewModel.resetSearch()
                    }
                }
                .onSubmit(of: .search) {
                    viewModel.search(keyword: viewModel.searchText)
                }
                .alert(item: Binding<ErrorWrapper?>(
                    get: { viewModel.errorMessage.map { ErrorWrapper(message: $0) } },
                    set: { _ in viewModel.errorMessage = nil }
                )) { wrapper in
                    Alert(title: Text("Error"), message: Text(wrapper.message), dismissButton: .default(Text("OK")))
                }
            }
        }
    }


#Preview {
    eCommerceView()
}
