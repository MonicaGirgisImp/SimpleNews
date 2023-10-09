//
//  BaseViewModel.swift
//  SimpleNews
//
//  Created by Monica Imperial on 09/10/2023.
//

import Foundation
import Combine

class BaseViewModel {
    
    var showLoader: PassthroughSubject<Bool,Never> = .init()
    var autoUpdateView: PassthroughSubject<(),Never> = .init()
    var failedWithError: PassthroughSubject<String,Never> = .init()
}
