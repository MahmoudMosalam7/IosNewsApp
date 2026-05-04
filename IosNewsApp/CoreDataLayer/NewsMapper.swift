//
//  NewsMapper.swift
//  IosNewsApp
//
//  Created by Mahmoud Mosalam on 04/05/2026.
//

import Foundation
extension News {
    var article: Article {
        Article(
            source: Source(
                id: sourceID,
                name: sourceName ?? ""
            ),
            newsId: newsID,
            author: author,
            title: title ?? "",
            description: newsDescription,
            url: url ?? "",
            urlToImage: urlToImage,
            publishedAt: publishedAt ?? "",
            content: content
        )
    }
}
