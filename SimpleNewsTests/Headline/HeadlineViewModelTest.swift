//
//  HeadlineViewModelTest.swift
//  SimpleNewsTests
//
//  Created by Monica Girgis Kamel on 01/08/2023.
//

import XCTest

@testable import SimpleNews

final class HeadlineViewModelTest: XCTestCase {

    var fakeHeadlineRepo: FakeHeadlineRepo!
    var headlineViewModel: HeadlinesViewModel!
    
    override func setUpWithError() throws {
        fakeHeadlineRepo = FakeHeadlineRepo()
        headlineViewModel = HeadlinesViewModel(headlineRepo: fakeHeadlineRepo)
    }

    override func tearDownWithError() throws {
        fakeHeadlineRepo = nil
        headlineViewModel = nil
    }
    
    func testFetchData_ShouldReturnSuccess() {
        fakeHeadlineRepo.testCaseState = .success
        var response = APIResponse(articles: [Article()])
        headlineViewModel.fetchData()
        XCTAssertEqual(headlineViewModel.articlesData, APIResponse(totalResults: 1, articles: [Article(category: "categoory", source: Source(id: "id", name: "name"), author: "authtor", title: "title", articleDescription: "description", url: "url", urlToImage: "url", publishedAt: "published", date: Date(), content: "content", isSaved: false)], status: "success"))
    }
    
    func testFetchData_ShouldReturnFailure() {
        fakeHeadlineRepo.testCaseState = .fail
        headlineViewModel.fetchData()
        XCTAssertEqual(headlineViewModel.articlesData.articles, [])
    }
    
//    func testSaveDateString_WithValidParam_ReturnDate() {
//        let testString = "2023-09-14T07:33:18Z"
//        let actualResult = headlineViewModel.saveDateStringToDate(dateString: testString)
//
//        XCTAssertNotNil(actualResult)
//        }
//
//    func testSaveDateString_WithInValidParam_ReturnNil() {
//        let testString = ""
//        let actualResult = headlineViewModel.saveDateStringToDate(dateString: testString)
//
//        XCTAssertNil(actualResult)
//    }
    
    func testSearch_WithValidParameters_ShouldReturnSuccess() {
        fakeHeadlineRepo.testCaseState = .success
        var response = APIResponse(articles: [Article()])
        headlineViewModel.searchArticles(with: "A") {  result in
            switch result {
            case .success(let data):
                response = data
            case .failure(_): break
            }
        }
        XCTAssertEqual(response, APIResponse(totalResults: 1, articles: [Article(category: "categoory", source: Source(id: "id", name: "name"), author: "authtor", title: "title", articleDescription: "description", url: "url", urlToImage: "url", publishedAt: "published", date: Date(), content: "content", isSaved: false)], status: "success"))
    }
    
    func testSearch_WithInValidParameters_ShouldReturnFailure() {
        fakeHeadlineRepo.testCaseState = .fail
        headlineViewModel.searchArticles(with: "A") 
        XCTAssertEqual(headlineViewModel.articlesData.articles, [])
    }
    
    func testAddArticleToBookmarks_WithValidParameters_ShouldAlterValue() {
        let testIndex = 0
        fakeHeadlineRepo.testCaseState = .success
        let testValue = false

        let expectation = XCTestExpectation(description: "Data Loaded")
        headlineViewModel.fetchData()
        headlineViewModel.addArticleToBookmarks(at: testIndex)
        
        XCTAssertNotEqual(testValue, headlineViewModel.articlesData.articles[testIndex].isSaved)
    }
}
