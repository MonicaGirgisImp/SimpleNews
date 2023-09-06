//
//  UIImageView + Extensions.swift
//  SimpleNews
//
//  Created by Monica Girgis Kamel on 31/07/2023.
//

import Foundation
import UIKit

extension UIImageView {
    func getAsync(_ url: String){
        if let imageURL = URL(string: url) {
            self.kf.indicatorType = .activity
          self.kf.setImage(with: imageURL, placeholder: UIImage())
        }else{
            self.image = UIImage(named: "default")
        }
      }
}
