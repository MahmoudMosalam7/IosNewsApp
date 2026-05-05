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
    
    func fetchNews() {
        Task {
            let result: Result<[News], CoreDataError> = await CoreDataManager.shared.fetch(
                entityName: CoreDataConstants.newsEntity
            )
            
            switch result {
            case .success(let news):
                DispatchQueue.main.async {
                    self.articles = news.map { $0.article }
                    print(self.articles)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
