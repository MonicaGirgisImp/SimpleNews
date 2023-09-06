//
//  BookmarksViewModel.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 31/07/2023.
//

import Foundation

class BookmarksViewModel {
    
    private (set) var bookmarks: [Article] = []
    private let bookmarksRepo = FetchBookmarksData()
    
    
    var delegate: ViewModelDelegates?
    
    init() {
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
        bookmarksRepo.unmarkAllArticles()
        delegate?.autoUpdateView()
    }
    
    func unmarkArticle(at index: Int) {
        let bookmark = bookmarks[index]
        bookmarks.remove(at: index)
        bookmarksRepo.updateCashedObject(primaryKey: bookmark.url)
        delegate?.autoUpdateView()
    }
}
