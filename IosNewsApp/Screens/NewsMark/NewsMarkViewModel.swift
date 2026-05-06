//
//  NewsMarkViewModel.swift
//  IosNewsApp
//
//  Created by Mahmoud Mosalam on 04/05/2026.
//

import Foundation
import Combine
import CoreData

class NewsMarkViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    func fetchNews() {
        isLoading = true
        error = nil
        Task {
            let result: Result<[News], CoreDataError> = await CoreDataManager.shared.fetch(
                entityName: CoreDataConstants.newsEntity
            )
            self.isLoading = false
            switch result {
            case .success(let news):
                DispatchQueue.main.async {
                    self.error = nil
                    self.articles = news.map { $0.article }
                    
                }
                
            case .failure(let error):
                self.error = error.errorDescription
            }
        }
    }
}
