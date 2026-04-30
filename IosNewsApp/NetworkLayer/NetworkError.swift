//
//  NetworkError.swift
//  IosNewsApp
//
//  Created by Mahmoud Mosalam on 29/04/2026.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    case decodingError(Error)
    case serverError(statusCode: Int)
    case noInternetConnection
    case requestError
    case timeOut
    case parsingError
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL format"
        case .invalidResponse:
            return "Invalid response from server"
        case .invalidData:
            return "No data received"
        case .decodingError(let error):
            return "Failed to decode: \(error.localizedDescription)"
        case .serverError(let code):
            return requestCodeError(code:code)
        case .noInternetConnection:
            return "No internet connection"
        case .requestError:
            return "Request error"
        case .timeOut:
            return "Request timeout"
        case .parsingError:
            return "Parsing error"
        case .unknown(let error):
            return error.localizedDescription
        }
    }
    
    private func requestCodeError(code : Int) -> String {
        switch code {
        case 401 :
            return "UnAuthorized error"
        case 404 :
            return "Not found"
        case 500...599 :
            return "Server error"
        default:
            return "Unknown error"
        }
    }
}
