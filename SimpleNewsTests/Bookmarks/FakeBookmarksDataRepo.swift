//
//  FakeBookmarksDataRepo.swift
//  SimpleNewsTests
//
//  Created by Monica Imperial on 16/09/2023.
//

import Foundation

@testable import SimpleNews

final class FakeBookmarksDataRepo: BookmarksRepoProtocol {
    
    var articles = [Article(category: "categoory", source: Source(id: "id", name: "name"), author: "authtor", title: "title", articleDescription: "description", url: "url", urlToImage: "url", publishedAt: "published", date: Date(), content: "content", isSaved: true)]
    
    func getCashedData(completion: (([Article]) -> ())?) {
        completion?(articles)
    }
}
