//
//  HorizontalCountriesButtonCollectionViewCell.swift
//  IosNewsApp
//
//  Created by Mahmoud Mosalam on 02/05/2026.
//

import UIKit

class HorizontalCountriesButtonCollectionViewCell: UICollectionViewCell {
    private let label = UILabel()
    
    func Setup(country : String){
        contentView.backgroundColor = .systemGray5
        contentView.layer.cornerRadius = 10
        label.textAlignment = .center
        label.text = country
        contentView.addSubview(label)
        label.frame = contentView.bounds
    }
}
