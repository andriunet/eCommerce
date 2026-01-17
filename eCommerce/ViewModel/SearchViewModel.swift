//
//  SearchViewModel.swift
//  eCommerce
//
//  Created by Andres Marin on 17/01/26.
//

import Combine
import Foundation
import SwiftUI
import Combine

protocol APIServiceProtocol {
    func fetch<T: Decodable>(endpoint: APIEndpoint) async throws -> T
}

@MainActor
class SearchViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var searchText: String = ""
    @Published var state: ViewState = .idle
    @Published var errorMessage: String?
    
    // MARK: - Estados de la Vista
    enum ViewState {
        case idle        // Esperando input
        case loading     // Carga inicial
        case loadingMore // Paginacion
        case loaded      // Datos mostrados
        case error       // Fallo
    }
    
    private let apiService: APIServiceProtocol
    private var currentPage = 1
    private var currentKeyword = ""
    private var canLoadMore = true
    
    init(apiService: APIServiceProtocol? = nil) {
        self.apiService = apiService ?? NetworkManager.shared
    }
    
    // MARK: - Historial Persistencia
    var history: [String] {
        get {
            guard let data = UserDefaults.standard.data(forKey: "searchHistory") else { return [] }
            return (try? JSONDecoder().decode([String].self, from: data)) ?? []
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: "searchHistory")
                objectWillChange.send()
            }
        }
    }
       
    func search(keyword: String) {
        guard !keyword.isEmpty else { return }
        
        currentKeyword = keyword
        currentPage = 1
        products = []
        canLoadMore = true
        errorMessage = nil
        state = .loading
        addToHistory(keyword)
        
        Task { await fetchProducts() }
    }
    
    func loadMore() {
        guard state != .loading && state != .loadingMore,
              canLoadMore,
              !currentKeyword.isEmpty else { return }
        
        state = .loadingMore
        Task { await fetchProducts() }
    }
    
    func resetSearch() {
        state = .idle
        products = []
        errorMessage = nil
    }
    
    func clearHistory() {
        history = []
    }
       
    private func fetchProducts() async {
        // Cancelacion si el usuario sale de la pantalla
        guard !Task.isCancelled else { return }
        
        defer {
            if state != .error { state = .loaded }
        }
        
        do {
            let response: SearchResponse = try await apiService.fetch(endpoint: .search(keyword: currentKeyword, page: currentPage))
            
            let rawItems = response.item.props.pageProps.initialData.searchResult.itemStacks.first?.items ?? []
            
            let validItems = rawItems.filter { $0.usItemId != nil && $0.name != nil }
            
            if validItems.isEmpty {
                canLoadMore = false
            } else {
                processNewItems(validItems)
            }
            
        } catch {
            handleError(error)
        }
    }
    
    private func processNewItems(_ newItems: [Product]) {
        var activeIDs = Set(products.map { $0.id })
        var uniqueItems: [Product] = []
        
        for item in newItems {
            if !activeIDs.contains(item.id) {
                uniqueItems.append(item)
                activeIDs.insert(item.id)
            }
        }
        
        self.products.append(contentsOf: uniqueItems)
        
        if uniqueItems.isEmpty {
            canLoadMore = false
        } else {
            currentPage += 1
        }
    }
    
    private func handleError(_ error: Error) {
        print("Error en ViewModel: \(error)")
        state = .error
        
        if let apiError = error as? APIError {
            errorMessage = apiError.localizedDescription
        } else {
            errorMessage = "Ocurrió un problema de conexión. Intenta de nuevo."
        }
    }
    
    private func addToHistory(_ term: String) {
        var tempHistory = history
        tempHistory.removeAll { $0 == term }
        tempHistory.insert(term, at: 0)
        if tempHistory.count > 10 { tempHistory.removeLast() }
        history = tempHistory
    }
}

