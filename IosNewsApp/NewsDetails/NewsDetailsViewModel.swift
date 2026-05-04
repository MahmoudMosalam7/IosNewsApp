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
            ) { (entity: News) in
                entity.newsID = UUID()
                entity.title = article.title
                entity.author = article.author
                entity.newsDescription = article.description
                entity.url = article.url
                entity.urlToImage = article.urlToImage
                entity.publishedAt = article.publishedAt
                entity.content = article.content
                entity.sourceName = article.source.name
                entity.sourceID = article.source.id
            }
            switch result {
            case .success:
                print("Saved successfully")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
//    func fetchArt(){
//        Task{
//            let result: Result<[News], CoreDataError> = await CoreDataManager.shared.fetch(
//                entityName: CoreDataConstants.newsEntity
//            )
//            switch result {
//            case .success(let newsItems):
//                let articles = newsItems.map(\.article)
//                print("Saved \(articles)")
//            case .failure(let error):
//                print("Error: \(error)")
//            }
//        }
//    }
}
