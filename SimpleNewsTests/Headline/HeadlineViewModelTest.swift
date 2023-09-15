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
    var fakeHeadlineOfflineDataRepo: FakeHeadlineOfflineDataRepo!
    var headlineViewModel: HeadlinesViewModel!
    
    override func setUpWithError() throws {
        fakeHeadlineRepo = FakeHeadlineRepo()
        fakeHeadlineOfflineDataRepo = FakeHeadlineOfflineDataRepo()
        headlineViewModel = HeadlinesViewModel(headlineRepo: fakeHeadlineRepo, headlineOfflineRepo: fakeHeadlineOfflineDataRepo)
    }

    override func tearDownWithError() throws {
        fakeHeadlineRepo = nil
        headlineViewModel = nil
    }
    
    func testHandleRepo_ShouldReturnSuccess() {
        fakeHeadlineRepo.testCaseState = .success
        var response = APIResponse(articles: [Article()])
        headlineViewModel.handleRepo { result in
            switch result {
            case .success(let data):
                response = data
            case .failure(_): break
            }
        }
        XCTAssertEqual(response, APIResponse(totalResults: 1, articles: [Article(category: "categoory", source: Source(id: "id", name: "name"), author: "authtor", title: "title", articleDescription: "description", url: "url", urlToImage: "url", publishedAt: "published", date: Date(), content: "content", isSaved: false)], status: "success"))
    }
    
    func testHandleRepo_ShouldReturnFailure() {
        fakeHeadlineRepo.testCaseState = .fail
        var response: APIError?
        headlineViewModel.handleRepo { result in
            switch result {
            case .success(_): break
            case .failure(let error):
                response = error
            }
        }
        XCTAssertEqual(response, APIError.responseUnsuccessful)
    }
    
    func testFetchData_ShouldReturnSuccess() {
        fakeHeadlineRepo.testCaseState = .success
        var response = APIResponse(articles: [Article()])
        headlineViewModel.fetchData { result in
            switch result {
            case .success(let data):
                response = data
            case .failure(_): break
            }        }
        XCTAssertEqual(response, APIResponse(totalResults: 1, articles: [Article(category: "categoory", source: Source(id: "id", name: "name"), author: "authtor", title: "title", articleDescription: "description", url: "url", urlToImage: "url", publishedAt: "published", date: Date(), content: "content", isSaved: false)], status: "success"))
    }
    
    func testFetchData_ShouldReturnFailure() {
        fakeHeadlineRepo.testCaseState = .fail
        var response: APIError?
        headlineViewModel.fetchData { result in
            switch result {
            case .success(_): break
            case .failure(let error):
                response = error
            }
        }
        XCTAssertEqual(response, APIError.responseUnsuccessful)
    }
    
    func testSaveDateString_WithValidParam_ReturnDate() {
        let testString = "2023-09-14T07:33:18Z"
        var actualResult = headlineViewModel.saveDateStringToDate(dateString: testString)
        
        XCTAssertNotNil(actualResult)
        }
    
    func testSaveDateString_WithInValidParam_ReturnNil() {
        let testString = ""
        var actualResult = headlineViewModel.saveDateStringToDate(dateString: testString)
        
        XCTAssertNil(actualResult)
    }
    
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
        var response: APIError?
        headlineViewModel.searchArticles(with: "A") { result in
            switch result {
            case .success(_): break
            case .failure(let error):
                response = error
            }
        }
        XCTAssertEqual(response, APIError.responseUnsuccessful)
    }
    
    func addArticleToBookmarks_WithValidParameters_ShouldReturnSuccess() {
        
    }

}
