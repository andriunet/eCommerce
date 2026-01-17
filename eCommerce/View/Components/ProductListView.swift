//
//  ProductListView.swift
//  eCommerce
//
//  Created by Andres Marin on 17/01/26.
//

import SwiftUI

struct ProductListView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.products) { product in
                ProductRow(product: product)
                    .onAppear {
                        if product == viewModel.products.last {
                            viewModel.loadMore()
                        }
                    }
            }
            
            // Spinner de paginacion
            if viewModel.state == .loadingMore {
                HStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(1.2)
                    Spacer()
                }
                .listRowSeparator(.hidden)
                .padding(.vertical, 15)
                .id(UUID())
            }
        }
        .listStyle(.plain)
    }
}
