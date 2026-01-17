//
//  Product.swift
//  eCommerce
//
//  Created by Andres Marin on 17/01/26.
//

import Foundation

struct Product: Codable, Identifiable, Hashable {
    let usItemId: String?
    let name: String?
    let image: String?
    let priceInfo: PriceInfo?
    
    var id: String { usItemId ?? UUID().uuidString }
    
    // Formateo de precio limpio
    var formattedPrice: String {
        guard let price = priceInfo?.linePrice else { return "Precio no disponible" }
        return price.hasPrefix("$") ? price : "$\(price)"
    }
    
    var imageURL: URL? {
        guard let image = image else { return nil }
        return URL(string: image)
    }
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    enum CodingKeys: String, CodingKey {
        case usItemId, name, image, priceInfo
    }
    
    struct PriceInfo: Codable {
        let linePrice: String?
    }
}
