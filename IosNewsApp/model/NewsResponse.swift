//
//  NewsResponse.swift
//  IosNewsApp
//
//  Created by Mahmoud Mosalam on 02/05/2026.
//

import Foundation
struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}
