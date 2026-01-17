//
//  APIError.swift
//  eCommerce
//
//  Created by Andres Marin on 17/01/26.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case serverError(statusCode: Int)
    case decodingError
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "La URL no es válida."
        case .serverError(let code): return "El servidor respondió con error: \(code)"
        case .decodingError: return "No se pudieron procesar los datos recibidos."
        case .unknown(let error): return error.localizedDescription
        }
    }
}

enum APIEndpoint {
    case search(keyword: String, page: Int)
    
    // Construccion de la ruta
    var path: String {
        switch self {
        case .search: return "/walmart-search-by-keyword"
        }
    }
    
    // Parametros de la consulta
    var queryItems: [URLQueryItem] {
        switch self {
        case .search(let keyword, let page):
            return [
                URLQueryItem(name: "keyword", value: keyword),
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "sortBy", value: "best_match")
            ]
        }
    }
    
    var request: URLRequest? {
        guard var components = URLComponents(string: AppConfig.baseURL + path) else { return nil }
        components.queryItems = queryItems
        
        guard let url = components.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        request.setValue(AppConfig.apiKey, forHTTPHeaderField: "x-rapidapi-key")
        request.setValue(AppConfig.apiHost, forHTTPHeaderField: "x-rapidapi-host")
        request.timeoutInterval = 10
        
        return request
    }
}
