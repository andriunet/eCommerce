//
//  NetworkManager.swift
//  eCommerce
//
//  Created by Andres Marin on 17/01/26.
//

import Foundation

actor NetworkManager: APIServiceProtocol {
    
    static let shared = NetworkManager()
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30 // Timeout
        config.waitsForConnectivity = true    // Esperar si se pierde la red
        self.session = URLSession(configuration: config)
    }
    
    func fetch<T: Decodable>(endpoint: APIEndpoint) async throws -> T {
        
        guard let request = await endpoint.request else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.unknown(URLError(.badServerResponse))
            }
            
            // Validacion de Codigo de Estado 200-299
            guard (200...299).contains(httpResponse.statusCode) else {
                print("Error HTTP: \(httpResponse.statusCode)")
                throw APIError.serverError(statusCode: httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
            
        } catch let error as DecodingError {
            print("Error de Decodificación: \(error)")
            throw APIError.decodingError
            
        } catch let error as APIError {
            throw error
            
        } catch {
            print("Error de Red: \(error.localizedDescription)")
            throw APIError.unknown(error)
        }
    }
}
