//
//  NetworkManager.swift
//  IosNewsApp
//
//  Created by Mahmoud Mosalam on 29/04/2026.
//

import Foundation

class NetworkManager {
    // MARK: Lazy Variables
    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.waitsForConnectivity = true
        return URLSession(configuration: config)
    }()
    
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()

    static let shared = NetworkManager()
    
    private init() {}
    func get<T: Codable>(
        _ endpoint: APIConfiguration
    ) async -> Result<T, NetworkError> {
        
        guard var components = URLComponents(string: endpoint.url) else {
            return .failure(.invalidURL)
        }
        
        components.queryItems = endpoint.queryItems
        
        guard let url = components.url else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        endpoint.header?.forEach { key, value in
            request.setValue("\(value)", forHTTPHeaderField: key)
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            return await handleResponse(data: data, response: response)
        } catch {
            return .failure(.unknown(error))
        }
    }
    
    func post<T: Codable>(_ endpoint: APIConfiguration) async -> Result<T, NetworkError> {
        
        guard var components = URLComponents(string: endpoint.url) else {
            return .failure(.invalidURL)
        }
        
        components.queryItems = endpoint.queryItems
        
        guard let url = components.url else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        endpoint.header?.forEach { key, value in
            request.setValue("\(value)", forHTTPHeaderField: key)
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            return await handleResponse(data: data, response: response)
        } catch {
            return .failure(.unknown(error))
        }
    }
    func put<T: Codable>(
        _ endpoint: APIConfiguration,
        body: T
    )async -> Result<T, NetworkError>  {
        
        guard var components = URLComponents(string: endpoint.url) else {
            return .failure(.invalidURL)
        }
        
        components.queryItems = endpoint.queryItems
        
        guard let url = components.url else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        endpoint.header?.forEach { key, value in
            request.setValue("\(value)", forHTTPHeaderField: key)
        }
        do {
            request.httpBody = try encoder.encode(body)
            let (data, response) = try await session.data(for: request)
            return await handleResponse(data: data, response: response)
                    
        } catch {
                return .failure(.unknown(error))
        }
    }
    
    func delete<T: Decodable>(_ endpoint: APIConfiguration) async -> Result<T, NetworkError> {
           guard var components = URLComponents(string: endpoint.url) else {
               return .failure(.invalidURL)
           }
           components.queryItems = endpoint.queryItems
           guard let url = components.url else {
               return .failure(.invalidURL)
           }
           var request = URLRequest(url: url)
           request.httpMethod = "DELETE"
           endpoint.header?.forEach { key, value in
               request.setValue("\(value)", forHTTPHeaderField: key)
           }
           do {
               let (data, response) = try await session.data(for: request)
               return await handleResponse(data: data, response: response)
           } catch {
               return .failure(.unknown(error))
           }
       }
    
    private func handleResponse<T: Decodable>(
        data: Data,
        response: URLResponse
    ) async -> Result<T, NetworkError> {
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.invalidResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            return .failure(.serverError(statusCode: httpResponse.statusCode))
        }
        
        do {
            let decoded = try decoder.decode(T.self, from: data)
            return .success(decoded)
        } catch let decodingError as DecodingError {
            return .failure(.decodingError(decodingError))
        } catch {
            return .failure(.unknown(error))
        }
    }
}
