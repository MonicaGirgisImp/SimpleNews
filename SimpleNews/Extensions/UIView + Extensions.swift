//
//  UIView + Extensions.swift
//  FFLASHH
//
//  Created by Moca on 5/26/21.
//

import UIKit

extension UIView {
    
    func makeRoundedCorners(){
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.height / 2
    }
    
    func makeRoundedCornersUsingWidth() {
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2
    }
    
    func makeRoundedCornersWith(radius: CGFloat){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
    
    func addBottomView(alpha: CGFloat? = nil, color: UIColor){
        let view = UIView()
        view.alpha = alpha ?? 1.0
        view.backgroundColor = color
        view.frame = CGRect(x: 0, y: self.frame.height - 2, width: self.frame.width, height: 1)
        layer.masksToBounds = true
        self.addSubview(view)
    }
    
    func makeShadows(){
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.masksToBounds = false
    }
    
    func makeShadowsWith(color: CGColor, opacity: Float, shadowRadius: CGFloat){
        self.layer.shadowColor = color
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = CGSize.zero
        self.layer.masksToBounds = false
    }
    
    func removeShadow() {
        self.layer.shadowOffset = CGSize(width: 0 , height: 0)
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 0.0
        self.layer.shadowRadius = 0.0
        self.layer.shadowOpacity = 0.0
    }
    
    func makeBorders(borderColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)){
        self.layer.borderWidth = 2
        self.layer.borderColor = borderColor.cgColor
    }
    
    func removeBorders() {
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
    func setBorderColor(color: UIColor,width: CGFloat){
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    func rotate(rotate: Bool){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                if rotate{
                    self.transform = CGAffineTransform(rotationAngle: .pi)
                }
                else{
                    self.transform = CGAffineTransform.identity
                }
            }
        }
    }
}
