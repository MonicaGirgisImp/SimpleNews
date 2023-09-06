//
//  SpinnerView.swift
//  justclean
//
//  Created by Mina mounir on 11/28/19.
//  Copyright © 2019 Justclean. All rights reserved.
//

import UIKit

class SpinnerView: UIView {
    
    @IBOutlet weak var spinnerActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var effectView: UIVisualEffectView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.spinnerActivityIndicator.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
        self.effectView.layer.cornerRadius = 8.0
    }
}

class Spinner{
    
    static func showSpinner() {
        
        DispatchQueue.main.async {
            if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                for  view in window.subviews {
                    if (view.isKind(of: SpinnerView.self)){
                        return
                    }
                }
            }
            let view = Bundle.main.loadNibNamed("SpinnerView", owner: nil, options: nil)![0]  as! SpinnerView
            if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first{
                for  view in window.subviews {
                    if (view.isKind(of: SpinnerView.self)){
                        return
                    }
                }
                view.frame = window.frame
                view.alpha = 0
                window.addSubview(view)
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                    view.alpha = 1
                }, completion: nil)
            }
        }
    }
    
    static func hideSpinner(time: TimeInterval? = nil) {
        
        DispatchQueue.main.async {
            if let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
                for  view in window.subviews {
                    if (view.isKind(of: SpinnerView.self)){
                        UIView.animate(withDuration: time ?? 0.7, delay: 0, options: .curveEaseInOut, animations: {
                            view.alpha = 0
                        }, completion: { (isComplete) in
                            if isComplete {
                                view.removeFromSuperview()
                            }
                        })
                    }
                }
            }
        }
    }
}
