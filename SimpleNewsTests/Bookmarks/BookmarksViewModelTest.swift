//
//  BookmarksViewModelTest.swift
//  SimpleNewsTests
//
//  Created by Monica Imperial on 16/09/2023.
//

import XCTest

@testable import SimpleNews

final class BookmarksViewModelTest: XCTestCase {

    var fakeBookmarksDataRepo: FakeBookmarksDataRepo!
    var bookmarkViewModel: BookmarksViewModel!
    
    override func setUpWithError() throws {
        fakeBookmarksDataRepo = FakeBookmarksDataRepo()
        bookmarkViewModel = BookmarksViewModel(bookmarksRepo: fakeBookmarksDataRepo)
    }

    override func tearDownWithError() throws {
        fakeBookmarksDataRepo = nil
        bookmarkViewModel = nil
    }

    func testHandleRepo() {
        bookmarkViewModel.handleRepo()
        XCTAssertEqual(fakeBookmarksDataRepo.articles, bookmarkViewModel.bookmarks)
    }
    
    func testUnMarkAllArticles() {
        bookmarkViewModel.handleRepo()
        bookmarkViewModel.unmarkAllArticles()
        XCTAssertEqual(bookmarkViewModel.bookmarks, [])
    }
    
    func testUnMarkArticle() {
        let testIndex = 0
        bookmarkViewModel.handleRepo()
        bookmarkViewModel.unmarkArticle(at: testIndex)
        XCTAssertEqual(bookmarkViewModel.bookmarks, [])
    }
}
