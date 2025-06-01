//
//  UIView.swift
//  QuizWhiz
//
//  Created by Sanket Ughade on 01/06/25.
//

import UIKit

extension UIView {
    func applyAsymmetricBorder(color: UIColor = UIColor(hex: "#121212")) {
        self.layer.sublayers?.removeAll(where: { $0.name == "border" })
        
        let color = color.cgColor
        
        let top = CALayer()
        top.name = "border"
        top.backgroundColor = color
        top.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 1)
        
        let left = CALayer()
        left.name = "border"
        left.backgroundColor = color
        left.frame = CGRect(x: 0, y: 0, width: 1, height: self.frame.height)
        
        let right = CALayer()
        right.name = "border"
        right.backgroundColor = color
        right.frame = CGRect(x: self.frame.width - 4, y: 0, width: 4, height: self.frame.height)
        
        let bottom = CALayer()
        bottom.name = "border"
        bottom.backgroundColor = color
        bottom.frame = CGRect(x: 0, y: self.frame.height - 4, width: self.frame.width, height: 4)
        
        [top, left, right, bottom].forEach { self.layer.addSublayer($0) }
    }
}
