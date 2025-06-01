//
//  BrandViewSetup.swift
//  QuizWhiz
//
//  Created by Sanket Ughade on 01/06/25.
//

import UIKit

extension ViewController {
    func addBrandView() {
        brandView.translatesAutoresizingMaskIntoConstraints = false
        brandView.layer.backgroundColor = UIColor(hex: "#50a46d").cgColor
        
        view.addSubview(brandView)
        
        NSLayoutConstraint.activate([
            brandView.topAnchor.constraint(equalTo: view.topAnchor),
            brandView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            brandView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            brandView.heightAnchor.constraint(equalTo: brandView.widthAnchor)
        ])
        
        let brandImageView = UIImageView()
        brandImageView.translatesAutoresizingMaskIntoConstraints = false
        brandImageView.image = UIImage(named: "Quiz-Whiz")
        brandImageView.contentMode = .scaleAspectFit
        
        brandView.addSubview(brandImageView)
        
        NSLayoutConstraint.activate([
            brandImageView.centerXAnchor.constraint(equalTo: brandView.centerXAnchor),
            brandImageView.centerYAnchor.constraint(equalTo: brandView.centerYAnchor),
            brandImageView.widthAnchor.constraint(equalTo: brandView.widthAnchor, multiplier: 0.8),
            brandImageView.heightAnchor.constraint(equalTo: brandImageView.widthAnchor)
        ])
    }
}
