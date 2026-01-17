//
//  HistoryView.swift
//  eCommerce
//
//  Created by Andres Marin on 17/01/26.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: SearchViewModel
    
    var body: some View {
        List {
            Section(header: HStack {
                Text("Búsquedas Recientes")
                Spacer()
                if !viewModel.history.isEmpty {
                    Button("Borrar") { viewModel.clearHistory() }.font(.caption)
                }
            }) {
                ForEach(viewModel.history, id: \.self) { term in
                    Button {
                        viewModel.searchText = term
                        viewModel.search(keyword: term)
                    } label: {
                        HStack {
                            Image(systemName: "clock").foregroundColor(.gray)
                            Text(term).foregroundColor(.primary)
                        }
                    }
                }
            }
        }
    }
}
