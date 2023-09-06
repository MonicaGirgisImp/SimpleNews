//
//  ArticleDetailsViewModel.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 31/07/2023.
//

import Foundation

class ArticleDetailsViewModel {
    
    private (set) var article: Article?
    var delegate: ViewModelDelegates?
    
    init(article: Article?) {
        self.article = article
        delegate?.autoUpdateView()
    }
}
