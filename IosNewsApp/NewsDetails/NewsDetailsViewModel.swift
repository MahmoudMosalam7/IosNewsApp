//
//  NewsDetailsViewModel.swift
//  IosNewsApp
//
//  Created by Mahmoud Mosalam on 04/05/2026.
//

import Foundation
import Combine
import CoreData

class NewsDetailsViewModel: ObservableObject {
    
    func saveArticle(article: Article) {
        Task {
            let result = await CoreDataManager.shared.save(
                entityName: CoreDataConstants.newsEntity
            ) { (entity: NSManagedObject) in
                entity.setValue(UUID(), forKey: CoreDataConstants.newsID)
                entity.setValue(article.title, forKey: CoreDataConstants.title)
                entity.setValue(article.author, forKey: CoreDataConstants.author)
                entity.setValue(article.description, forKey: CoreDataConstants.desc)
                entity.setValue(article.url, forKey: CoreDataConstants.url)
                entity.setValue(article.urlToImage, forKey: CoreDataConstants.urlToImage)
                entity.setValue(article.publishedAt, forKey: CoreDataConstants.publishedAt)
                entity.setValue(article.content, forKey: CoreDataConstants.content)
                entity.setValue(article.source.name, forKey: CoreDataConstants.sourceName)
                entity.setValue(article.source.id, forKey: CoreDataConstants.sourceId)
            }
            
            switch result {
            case .success:
                print("Saved successfully")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
