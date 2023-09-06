//
//  UIButton + Extensions.swift
//  Project
//
//  Created by Monica Girgis Kamel on 07/12/2021.
//

import Foundation
import UIKit

extension UIButton{
    func isEnabled(_ isActive: Bool){
        isEnabled  = isActive
        alpha = isActive ? 1.0 : 0.5
    }
}
