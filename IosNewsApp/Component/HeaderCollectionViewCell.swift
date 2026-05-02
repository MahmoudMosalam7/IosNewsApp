//
//  HeaderCollectionViewCell.swift
//  IosNewsApp
//
//  Created by Mahmoud Mosalam on 02/05/2026.
//

import UIKit

class HeaderCollectionViewCell: UICollectionViewCell {
    private let label = UILabel()
    
    func setup(
        title: String
    ){
        label.font = .boldSystemFont(ofSize: 24)
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
