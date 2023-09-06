//
//  StartNewsCollectionViewCell.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 08/01/2022.
//

import UIKit

class StartNewsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var doneImage: UIImageView!
    @IBOutlet weak var doneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        doneImage.image = UIImage.gifImageWithName("despicable-me-minions")
    }

}
