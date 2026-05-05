//
//  EmptyCollectionViewCell.swift
//  IosNewsApp
//
//  Created by Mahmoud Mosalam on 05/05/2026.
//

import UIKit

class EmptyCollectionViewCell: UICollectionViewCell {
    
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(message: String) {
        label.text = message
    }
    
    private func setup(){
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
