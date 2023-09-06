//
//  ViewModelDelegates.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 31/07/2023.
//

import Foundation

protocol ViewModelDelegates {
    func autoUpdateView()
    func failedWithError(_ err: String)
    func loaderIsHidden(_ isHidden: Bool)
    func insertNewRows(_ initialIndex: Int, _ endIndex: Int, _ section: Int)
}

extension ViewModelDelegates {
    func dismissView() {
        print("Dismiss")
    }
}
