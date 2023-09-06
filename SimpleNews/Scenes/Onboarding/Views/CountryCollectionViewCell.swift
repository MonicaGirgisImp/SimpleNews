//
//  CountryCollectionViewCell.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 08/01/2022.
//

import UIKit

class CountryCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var countryTitleLabel: UILabel!
    @IBOutlet weak var followImage: UIImageView!
    
    var typeSelected: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    private func setupUI(){
        outerView.makeRoundedCornersWith(radius: 12)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(typeChosen))
        outerView.addGestureRecognizer(gesture)
    }
    
    @objc func typeChosen(){
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear) { [weak self] in
            self?.followImage.image = UIImage(systemName: "checkmark")
            self?.outerView.backgroundColor = .white
            self?.countryTitleLabel.textColor = .black
            self?.outerView.makeBorders(borderColor: .blue)
        } completion: { finished in
            if finished{
                self.typeSelected?()
            }
        }
    }
    
    func setCountryTitle(_ title: String){
        countryTitleLabel.text = title
    }
}
