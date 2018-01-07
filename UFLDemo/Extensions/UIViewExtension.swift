//
//  UIViewExtension.swift
//  UFLDemo
//
//  Created by Truong Vo on 1/7/18.
//  Copyright © 2018 Truong Vo. All rights reserved.
//

import UIKit

extension UIView {
    
    func dropShadow() {
        let radius: CGFloat = self.frame.height / 2.0
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.frame.width, height: 2.1 * radius))
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)  // Here you control x and y
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 6.0 // blur
        self.layer.masksToBounds = false
        self.layer.shadowPath = shadowPath.cgPath
    }
    
}

