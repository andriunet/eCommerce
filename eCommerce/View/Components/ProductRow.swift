//
//  ProductRow.swift
//  eCommerce
//
//  Created by Andres Marin on 17/01/26.
//

import SwiftUI

struct ProductRow: View {
    let product: Product
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: product.imageURL) { phase in
                switch phase {
                case .empty: Color.gray.opacity(0.1)
                case .success(let image): image.resizable().scaledToFit()
                case .failure: Image(systemName: "photo").foregroundColor(.gray)
                @unknown default: EmptyView()
                }
            }
            .frame(width: 80, height: 80)
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(product.name ?? "Sin nombre")
                    .font(.body)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                
                Text(product.formattedPrice)
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .fontWeight(.bold)
            }
        }
        .padding(.vertical, 4)
    }
}
