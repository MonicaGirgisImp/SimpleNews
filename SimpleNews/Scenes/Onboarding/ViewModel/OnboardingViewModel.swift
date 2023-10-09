//
//  OnboardingViewModel.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 31/07/2023.
//

import Foundation

class OnboardingViewModel: BaseViewModel {
    
    private (set) var selectedCountry: Countries?
    private (set) var selectedCategories: [Categories] = []
    
    private (set) var currentPage: Int = 0{
        didSet{
            if currentPage == 2 {
                autoUpdateView.send(())
            }
        }
    }
    
    func setCurrentPage(_ page: Int) {
        currentPage = page
    }
    
    func setSelectedCountry(_ country: Countries) {
        selectedCountry = country
    }
    
    func setSelectedCategories(_ categories: [Categories]) {
        selectedCategories = categories
    }
    
    func casheData(completion: (()->())?) {
        guard let selectedCountry = selectedCountry, !selectedCategories.isEmpty else { return }
        UserManager.shared.setData(country: selectedCountry, categories: selectedCategories)
        completion?()
    }
}
