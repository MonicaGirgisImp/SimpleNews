//
//  HeadlineLocalDataProtocol.swift
//  SimpleNews
//
//  Created by Monica Imperial on 15/09/2023.
//

import Foundation


protocol HeadlineLocalDataProtocol: AnyObject {
    func getCashedData(completion: (([Article])->())?)
    func casheArticles(articles: [Article])
    func deleteAllRecords()
}
