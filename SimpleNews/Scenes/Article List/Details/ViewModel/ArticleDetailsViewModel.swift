//
//  ArticleDetailsViewModel.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 31/07/2023.
//

import Foundation

class ArticleDetailsViewModel: BaseViewModel {
    
    private (set) var article: Article?
    
    init(article: Article?) {
        super.init()
        
        self.article = article
        autoUpdateView.send(())
    }
}
