import Foundation
import Combine
import CoreData

class NewsDetailsViewModel: ObservableObject {

    @Published var isBookmarked: Bool = false

    private var article: Article?

    func configure(article: Article) {
        self.article = article
        checkIfSaved()
    }

    func toggleBookmark() {
        guard let article = article else { return }

        if isBookmarked {
            deleteArticle(article: article)
        } else {
            saveArticle(article: article)
        }
    }

    func saveArticle(article: Article) {
        Task { [weak self] in
            guard let self else { return }
            let result = await CoreDataManager.shared.save(
                entityName: CoreDataConstants.newsEntity
            ) { (entity: News) in
                self.assignData(article: article ,entity: entity )
            }
            switch result {
            case .success:
                print("success to save")
                DispatchQueue.main.async {
                    self.isBookmarked = true
                }
            case .failure:
                DispatchQueue.main.async {
                    self.isBookmarked = false
                }
            }
        }
    }
    
    func assignData(article: Article ,entity: News ){
        entity.newsID = article.newsId ?? UUID()
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

    func deleteArticle(article: Article) {
        Task { [weak self] in
            guard let self else { return }
            let fetchResult = await fetchSavedNews(article: article)
            switch fetchResult {
            case .success(let news):
                let result = await CoreDataManager.shared.delete(object: news)
                switch result {
                case .success:
                    print("success to delete")
                    DispatchQueue.main.async {
                        self.isBookmarked = false
                    }
                case .failure:
                    DispatchQueue.main.async {
                        self.isBookmarked = true
                    }
                }
            case .failure:
                // if not found → keep state unchanged (true)
                break
            }
        }
    }

    private func checkIfSaved() {
        guard let article = article else { return }
        Task { [weak self] in
            guard let self else { return }
            let result = await fetchSavedNews(article: article)
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.isBookmarked = true
                case .failure:
                    self.isBookmarked = false
                }
            }
        }
    }

    private func fetchSavedNews(article: Article) async -> Result<News, CoreDataError> {
        let result: Result<[News], CoreDataError> = await CoreDataManager.shared.fetch(
            entityName: CoreDataConstants.newsEntity
        )

        switch result {
        case .success(let items):
            if let news = items.first(where: { $0.url == article.url }) {
                return .success(news)
            } else {
                return .failure(.entityNotFound)
            }

        case .failure(let error):
            return .failure(error)
        }
    }
}
