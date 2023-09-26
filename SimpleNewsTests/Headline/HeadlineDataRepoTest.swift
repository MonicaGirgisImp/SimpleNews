//
//  FetchHeadlineDataRepoTest.swift
//  SimpleNewsTests
//
//  Created by Monica Imperial on 26/09/2023.
//

import XCTest

@testable import SimpleNews

final class HeadlineDataRepoTest: XCTestCase {
    
    var headlinesRepo: HeadlineDataRepo!
    var fakeCasheManager: FakeCasheManager<ArticleDB>!
    var fakeAPIRoute: FakeAPIRoute!
    
    let testArticleModel = Article(category: "category", source: Source(id: "id", name: "name"), author: "authtor", title: "title", articleDescription: "description", url: "url", urlToImage: "url", publishedAt: "published", date: Date(), content: "content", isSaved: false)

    override func setUpWithError() throws {
        fakeCasheManager = FakeCasheManager<ArticleDB>()
        fakeAPIRoute = FakeAPIRoute()
        headlinesRepo = HeadlineDataRepo(APIDataSource: fakeAPIRoute, casheDataSource: fakeCasheManager)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchData_WithValidParameters_ShouldReturnData() {
        var actualResult: APIResponse<[Article]> = APIResponse(articles: [])
        fakeAPIRoute.testCaseState = .success
        headlinesRepo.fetchData(country: "country", category: "category") { response in
            switch response {
            case .success(let data):
                actualResult = data
            case .failure(_): break
            }
        }
        
        XCTAssertEqual(actualResult, APIResponse(totalResults: 1, articles: [testArticleModel], status: "success"))
    }
    
    func testFetchData_WithInValidParameters_ShouldReturnData() {
        var actualResult: APIResponse<[Article]> = APIResponse(articles: [])
        fakeAPIRoute.testCaseState = .fail
        fakeCasheManager.casheObject(ArticleDB(category: "category", source: Source(id: "id", name: "name"), author: "authtor", title: "title", articleDescription: "description", url: "url", urlToImage: "url", publishedAt: "published", date: Date(), content: "content", isSaved: false))
        headlinesRepo.fetchData(country: "country", category: "category") { response in
            switch response {
            case .success(let data):
                actualResult = data
            case .failure(_): break
            }
        }
        XCTAssertEqual(actualResult, APIResponse(totalResults: 1, articles: [testArticleModel], status: "success"))
    }
    
    func testFetchArticles_WithValidParameters_ShouldReturnData() {
        var actualResult: APIResponse<[Article]> = APIResponse(articles: [])
        fakeAPIRoute.testCaseState = .success
        headlinesRepo.fetchArticles(page: 1, pageSize: 20, country: "country", category: "category"){ response in
            switch response {
            case .success(let data):
                actualResult = data
            case .failure(_): break
            }
        }
        
        XCTAssertEqual(actualResult, APIResponse(totalResults: 1, articles: [testArticleModel], status: "success"))
    }
    
    func testFetchArticles_WithInValidParameters_ShouldReturnFailure() {
        var actualResult: APIError?
        fakeAPIRoute.testCaseState = .fail
        headlinesRepo.fetchArticles(page: 1, pageSize: 20, country: "country", category: "category"){ response in
            switch response {
            case .success(_): break
            case .failure(let error):
                actualResult = error
            }
        }
        
        XCTAssertEqual(actualResult, .responseUnsuccessful)
    }
    
    func testGetCashedData_WithNoCashing_ShouldReturnEmpty() {
        let actualResult = headlinesRepo.getCashedData()
        XCTAssertEqual(actualResult, [])
    }
    
    func testCasheArticles_WithValidParamters_ShouldReturnData() {
        headlinesRepo.casheArticles(articles: [testArticleModel])
        let actualResult = headlinesRepo.getCashedData()
        XCTAssertEqual(actualResult, [testArticleModel])
    }
    
    func testCasheArticles_WithInValidParamters_ShouldReturnEmpty() {
        headlinesRepo.casheArticles(articles: [])
        let actualResult = headlinesRepo.getCashedData()
        XCTAssertEqual(actualResult, [])
    }
    
    func testGetCashedData_WithCashedData_ShouldReturnData() {
        headlinesRepo.casheArticles(articles: [testArticleModel])
        let actualResult = headlinesRepo.getCashedData()
        XCTAssertEqual(actualResult, [testArticleModel])
    }
    
    func testDeleteAllRecords_ShouldReturnEmpty() {
        headlinesRepo.deleteAllRecords()
        let actualResult = headlinesRepo.getCashedData()
        XCTAssertEqual(actualResult, [])
    }
}
