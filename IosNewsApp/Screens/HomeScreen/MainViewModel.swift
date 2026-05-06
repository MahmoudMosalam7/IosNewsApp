//
//  MainViewModel.swift
//  IosNewsApp
//
//  Created by Mahmoud Mosalam on 02/05/2026.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
    
    @Published var articles: [Article] = []
    @Published var isLoading: Bool = false
    @Published var error: String?
    let countries = ["us", "eg", "gb", "fr", "de", "it"]
    func getNews(country: String = "us") {
        isLoading = true
        error = nil
        Task {
            let endpoint = Endpoint.getNewsByCountries(countryCode: country)
            let result: Result<NewsResponse, NetworkError> = await NetworkManager.shared.get(endpoint)
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let response):
                    self.error = nil
                    self.articles = response.articles
                case .failure(let err):
                    self.error = err.errorDescription
                }
            }
        }
    }
}
