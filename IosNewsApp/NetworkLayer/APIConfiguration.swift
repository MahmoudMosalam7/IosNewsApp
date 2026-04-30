//
//  APIConfiguration.swift
//  IosNewsApp
//
//  Created by Mahmoud Mosalam on 29/04/2026.
//

import Foundation

protocol APIConfiguration {
    var baseUrl : String { get }
    var apiKey : String { get }
    var path : String { get }
    var method : HTTPMethod{ get }
    var header : [String : Any]? { get }
    var queryItems: [URLQueryItem]? { get }
    var url: String { get }
    
}
