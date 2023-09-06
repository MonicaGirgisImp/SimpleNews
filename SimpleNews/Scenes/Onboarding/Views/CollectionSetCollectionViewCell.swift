//
//  CollectionSetCollectionViewCell.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 08/01/2022.
//

import UIKit

class CollectionSetCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var setCollectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    var sectionName: OnboardingViewController.SectionHeaders = .Countries
    var countrySelected: ((Countries)->())?
    var categoriesSelected: (([Categories])->())?
    private var cats: [Categories] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI(){
        setCollectionView.register(UINib(nibName: String(describing: CountryCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: CountryCollectionViewCell.self))
        //layout.estimatedItemSize = CGSize(width: 1, height: 1)
    }
    
    func setData(section: OnboardingViewController.SectionHeaders){
        sectionName = section
    }
}


//MARK:- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension CollectionSetCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sectionName{
        case .Countries:
            return Countries.allCases.count
        default:
            return Categories.allCases.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CountryCollectionViewCell.self), for: indexPath) as! CountryCollectionViewCell
        switch sectionName{
        case .Countries:
            cell.setCountryTitle(Countries.allCases[indexPath.row].rawValue)
            cell.typeSelected = { [weak self] in
                self?.countrySelected?(Countries.allCases[indexPath.row])
            }
        default:
            cell.setCountryTitle(Categories.allCases[indexPath.row].rawValue)
            cell.typeSelected = { [weak self] in
                guard let self = self else { return}
                self.cats.append(Categories.allCases[indexPath.row])
                if self.cats.count == 3{
                    self.categoriesSelected?(self.cats)
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2) - 2, height: 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}
