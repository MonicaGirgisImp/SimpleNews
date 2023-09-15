//
//  FakeHeadlineOfflineDataRepo.swift
//  SimpleNewsTests
//
//  Created by Monica Imperial on 15/09/2023.
//

import Foundation

@testable import SimpleNews

final class FakeHeadlineOfflineDataRepo: HeadlineLocalDataProtocol {
    
    var articles = [Article(category: "categoory", source: Source(id: "id", name: "name"), author: "authtor", title: "title", articleDescription: "description", url: "url", urlToImage: "url", publishedAt: "published", date: Date(), content: "content", isSaved: false)]
    
    func getCashedData(completion: (([Article]) -> ())?) {
        completion?(articles)
    }
    
    func casheArticles(articles: [Article]) {
        self.articles.append(contentsOf: articles)
    }
}
