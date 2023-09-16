//
//  BookmarksRepoProtocol.swift
//  SimpleNews
//
//  Created by Monica Imperial on 06/09/2023.
//

import Foundation

protocol BookmarksRepoProtocol: AnyObject {
    func getCashedData(completion: (([Article])->())? )
}
