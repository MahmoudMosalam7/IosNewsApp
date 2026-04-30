//
//  Endpoint.swift
//  IosNewsApp
//
//  Created by Mahmoud Mosalam on 29/04/2026.
//

import Foundation
enum Endpoint : APIConfiguration {
    case getNewsByCountries(countryCode: String)
    
    var path: String {
        switch self {
        case .getNewsByCountries:
            return "/top-headlines"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getNewsByCountries:
            return .get
        }
    }
    
    var header: [String : Any]?{
        switch self {
        case .getNewsByCountries:
            return nil
            
        }
    }
    var queryItems: [URLQueryItem]? {
            switch self {
            case .getNewsByCountries(let countryCode):
                return [
                           URLQueryItem(name: "country", value: countryCode),
                           URLQueryItem(name: "apiKey", value: apiKey)
                       ]
            }
    }
    var url: String {
            return baseUrl + path
    }
    
    var baseUrl: String{
        "https://newsapi.org/v2"
    }
    
    var apiKey: String{
        "f7d8ddb5423f4e2b81aeb862c2e5c2f2"
    }
    
    
}
