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

    override func setUpWithError() throws {
        casheManager = CasheManager.shared
        casheManager.resetRealm()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
    }

    override func tearDownWithError() throws {
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
        let testPrimaryKey = ""
        let expectedValue: ArticleDB? = nil
        let actualValue = casheManager.getCashedObject(ArticleDB.self, with: testPrimaryKey)
        
        XCTAssertEqual(expectedValue,actualValue)
    }
    
    func testUpdateCashedObj_WithValidParameter_ShouldUpdateValue() {
        let testPrimaryKey = "URLURL"
        let expectedValue = false
        let testModel = ArticleDB(category: "categoryCopy", source: Source(id: "1", name: "source"), author: "AuthorCopy", title: "titleCopy", articleDescription: "descCopy", url: testPrimaryKey, urlToImage: "imageURLCopy", publishedAt: "dateCopy", date: Date(), content: "contentCopy", isSaved: expectedValue)
        casheManager.casheObject(testModel)
        
        casheManager.updateCashedObj(ArticleDB.self, with: testPrimaryKey) { model in
            model.isSaved = true
        }
        let actualValue = casheManager.getCashedObject(ArticleDB.self, with: testPrimaryKey)?.isSaved
        
        XCTAssertNotEqual(expectedValue, actualValue)
    }
    
    func testUpdateCashedObj_WithInValidParameter_ShouldNotReturnValue() {
        let testPrimaryKey = ""
        let expectedValue: Bool? = nil
        
        casheManager.updateCashedObj(ArticleDB.self, with: testPrimaryKey) { model in
            model.isSaved = true
        }
        let actualValue = casheManager.getCashedObject(ArticleDB.self, with: testPrimaryKey)?.isSaved
        
        XCTAssertEqual(expectedValue, actualValue)
    }
    
    func testDeleteAllObjectsInRealmShouldSuccess() {
        let expectedValue: [ArticleDB] = []
        casheManager.deleteObjects(ArticleDB.self)
        let actualValue = casheManager.getCashedObjects(ArticleDB.self)
        
        XCTAssertEqual(expectedValue, Array(actualValue))
    }
}
