//
//  BookmarksViewModel.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 31/07/2023.
//

import Foundation

class BookmarksViewModel {
    
    private (set) var bookmarks: [Article] = []
    private let bookmarksRepo: BookmarksRepoProtocol!
    
    
    var delegate: ViewModelDelegates?
    
    init(bookmarksRepo: BookmarksRepoProtocol) {
        self.bookmarksRepo = bookmarksRepo
       handleRepo()
    }
    
    func handleRepo() {
        bookmarksRepo.getCashedData { [weak self] articles in
            guard let self = self else { return }
            bookmarks = articles
            delegate?.autoUpdateView()
        }
    }
    
    func unmarkAllArticles() {
        bookmarks.removeAll()
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
        guard index >= 0, index < bookmarks.count else { return }
        let bookmark = bookmarks[index]
        bookmarks.remove(at: index)
        if let primaryKey = bookmark.url {
            CasheManager.shared.updateCashedObj(ArticleDB.self, with: primaryKey) { obj in
                obj.isSaved = !obj.isSaved
            }
        }
        delegate?.autoUpdateView()
    }
}
