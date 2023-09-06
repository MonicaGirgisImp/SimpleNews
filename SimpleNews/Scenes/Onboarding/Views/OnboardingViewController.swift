//
//  OnboardingViewController.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 08/01/2022.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    enum SectionHeaders: CaseIterable{
        case Countries
        case Categories
        case Start
    }
    
    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pageController: UIPageControl!
    
    var viewModel = OnboardingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        viewModel.delegate = self
    }
    
    private func setupUI(){
        nextBtn.makeRoundedCornersWith(radius: 8.0)
        nextBtn.isEnabled(false)
        onboardingCollectionView.register(UINib(nibName: String(describing: CollectionSetCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: CollectionSetCollectionViewCell.self))
        onboardingCollectionView.register(UINib(nibName: String(describing: StartNewsCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: StartNewsCollectionViewCell.self))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        viewModel.setCurrentPage(Int(scrollView.contentOffset.x / width))
        pageController.currentPage = viewModel.currentPage
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        viewModel.casheData { [weak self] in
            guard let self = self else { return }
            performSegue(withIdentifier: "showNews", sender: nil)
        }
    }
}

//MARK:- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SectionHeaders.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch SectionHeaders.allCases[indexPath.row]{
        case .Countries:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionSetCollectionViewCell.self), for: indexPath) as! CollectionSetCollectionViewCell
            cell.setData(section: .Countries)
            cell.countrySelected = { [weak self] country in
                guard let self = self else { return }
                viewModel.setSelectedCountry(country)
                collectionView.scrollToItem(at: IndexPath(row: indexPath.row + 1, section: indexPath.section), at: .left, animated: true)
            }
            return cell
            
        case .Categories:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionSetCollectionViewCell.self), for: indexPath) as! CollectionSetCollectionViewCell
            cell.setData(section: .Categories)
            
            cell.categoriesSelected = { [weak self] categories in
                guard let self = self else { return }
                viewModel.setSelectedCategories(categories)
                collectionView.scrollToItem(at: IndexPath(row: indexPath.row + 1, section: indexPath.section), at: .left, animated: true)
            }
            
            return cell
            
        case .Start:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: StartNewsCollectionViewCell.self), for: indexPath) as! StartNewsCollectionViewCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension OnboardingViewController: ViewModelDelegates {
    func autoUpdateView() {
        if viewModel.currentPage == 2 {
            nextBtn.isEnabled(true)
        }
    }
    
    func failedWithError(_ err: String) {
    }
    
    func loaderIsHidden(_ isHidden: Bool) {
    }
    
    func insertNewRows(_ initialIndex: Int, _ endIndex: Int, _ section: Int) {
    }
}
