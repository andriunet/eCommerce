//
//  SearchResponse.swift
//  eCommerce
//
//  Created by Andres Marin on 17/01/26.
//

import Foundation

struct SearchResponse: Codable {
    let item: ItemData
    
    struct ItemData: Codable { let props: Props }
    struct Props: Codable { let pageProps: PageProps }
    struct PageProps: Codable { let initialData: InitialData }
    struct InitialData: Codable { let searchResult: SearchResult }
    struct SearchResult: Codable { let itemStacks: [ItemStack] }
    struct ItemStack: Codable { let items: [Product] }
}
