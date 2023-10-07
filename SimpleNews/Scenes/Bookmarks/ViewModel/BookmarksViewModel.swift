//
//  BookmarksViewModel.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 31/07/2023.
//

import Foundation
import Combine

class BookmarksViewModel {
    
    private let bookmarksRepo: BookmarksRepoProtocol!
    
    var bookmarksData: CurrentValueSubject<[Article], Never> = .init([])
    var delegate: ViewModelDelegates?
    
    init(bookmarksRepo: BookmarksRepoProtocol) {
        self.bookmarksRepo = bookmarksRepo
       handleRepo()
    }
    
    func handleRepo() {
        bookmarksRepo.getCashedData { [weak self] articles in
            guard let self = self else { return }
            bookmarksData.value = articles
            delegate?.autoUpdateView()
        }
    }
    
    func unmarkAllArticles() {
        bookmarksData.value.removeAll()
        let articles = CasheManager.shared.getCashedObjects(ArticleDB.self).filter({ $0.isSaved == true })
        articles.forEach { articleDB in
            if let url = articleDB.url {
                CasheManager.shared.updateCashedObj(ArticleDB.self, with: url) { objc in
                    objc.isSaved = false
                }
            }
            
        }
        delegate?.autoUpdateView()
    }
    
    func unmarkArticle(at index: Int) {
        guard index >= 0, index < bookmarksData.value.count else { return }
        let bookmark = bookmarksData.value[index]
        bookmarksData.value.remove(at: index)
        if let primaryKey = bookmark.url {
            CasheManager.shared.updateCashedObj(ArticleDB.self, with: primaryKey) { obj in
                obj.isSaved = !obj.isSaved
            }
        }
        delegate?.autoUpdateView()
    }
}
