//
//  CasheManagerTest.swift
//  SimpleNewsTests
//
//  Created by Monica Imperial on 18/09/2023.
//

import XCTest
import Realm
import RealmSwift


@testable import SimpleNews

final class CasheManagerTest: XCTestCase {
    
    var casheManager: CasheManager!
    let successModel = ArticleDB(category: "category", source: Source(id: "1", name: "source"), author: "Author", title: "title", articleDescription: "desc", url: "url", urlToImage: "imageURL", publishedAt: "date", date: Date(), content: "content", isSaved: false)
    var shouldDelete: Bool = true

    override func setUpWithError() throws {
        casheManager = CasheManager.shared
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }

    override func tearDownWithError() throws {
        if shouldDelete {
            casheManager.deleteObjects(ArticleDB.self)
        }
        shouldDelete = true
    }
    
    func testGetCahsheObjectInRealm_ShouldReturnEmpty() {
        let expectedValue: [ArticleDB] = []
        let actualValue = casheManager.getCashedObjects(ArticleDB.self)
        
        XCTAssertEqual(expectedValue, Array(actualValue))
    }

    func testCasheArticleObjectInRealmSuccess() {
        let expectedValue = successModel
        casheManager.casheObject(expectedValue)

        let actualValue = casheManager.getCashedObjects(ArticleDB.self)

        XCTAssertEqual([expectedValue], Array(actualValue))
    }
    
    func testCasheObjectsInRealmSuccess() {
        let expectedValue = [successModel, ArticleDB(category: "category", source: Source(id: "1", name: "source"), author: "Author", title: "title", articleDescription: "desc", url: "url2", urlToImage: "imageURL", publishedAt: "date", date: Date(), content: "content", isSaved: false)]
        casheManager.casheObjects(expectedValue)
        
        let actualValue = casheManager.getCashedObjects(ArticleDB.self)
        
        XCTAssertEqual(expectedValue, Array(actualValue))
    }
    
    func testCasheArticleObjecstInRealm_WithRedundantPrimaryKey_ShouldSaveSecondRecordOnly() {
        let expectedValue = ArticleDB(category: "categoryCopy", source: Source(id: "1", name: "source"), author: "AuthorCopy", title: "titleCopy", articleDescription: "descCopy", url: "url", urlToImage: "imageURLCopy", publishedAt: "dateCopy", date: Date(), content: "contentCopy", isSaved: false)
        casheManager.casheObjects([successModel, expectedValue])

        let actualValue = casheManager.getCashedObjects(ArticleDB.self)

        XCTAssertEqual([expectedValue], Array(actualValue))
    }
    
    func testGetObjectWithValidPrimaryKey_ShouldReturnObject() {
        let testPrimaryKey = "url"
        let expectedValue = successModel
        casheManager.casheObject(expectedValue)
        let actualValue = casheManager.getCashedObject(ArticleDB.self, with: testPrimaryKey)
        
        XCTAssertEqual(expectedValue,actualValue)
    }
    
    func testGetObjectWithInValidPrimaryKey_ShouldReturnObject() {
        shouldDelete = true
        let testPrimaryKey = ""
        let expectedValue: ArticleDB? = nil
        let actualValue = casheManager.getCashedObject(ArticleDB.self, with: testPrimaryKey)
        
        XCTAssertEqual(expectedValue,actualValue)
    }
    
    func testDeleteAllObjectsInRealmShouldSuccess() {
        shouldDelete = false
        let expectedValue: [ArticleDB] = []
        casheManager.deleteObjects(ArticleDB.self)
        let actualValue = casheManager.getCashedObjects(ArticleDB.self)
        
        XCTAssertEqual(expectedValue, Array(actualValue))
    }
}
