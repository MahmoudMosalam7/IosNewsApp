//
//  NewsCardCollectionViewCell.swift
//  IosNewsApp
//
//  Created by Mahmoud Mosalam on 02/05/2026.
//

import UIKit
import Kingfisher

class NewsCardCollectionViewCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let publishedDateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    func setup(
        title : String,
        subtitle: String,
        imageURL: String,
        publishedAt: String
        
    ){
        setupTitle(title : title)
        setupDate(date : publishedAt)
        setupSubTitle(subtitle : subtitle)
        setupImage(imageURL :imageURL)
        
    }
    
    func setupView() {
        let titleStack = UIStackView(arrangedSubviews: [titleLabel, publishedDateLabel])
        titleStack.axis = .vertical
        titleStack.spacing = 2
        let stack = UIStackView(arrangedSubviews: [
            imageView,
            titleStack,
            subtitleLabel
        ])
        stack.axis = .vertical
        stack.spacing = 6
        stack.distribution = .fill
        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.6)
        ])
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
    
    }
    
    func setupTitle(title : String){
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.text = title
        titleLabel.numberOfLines = 2
    }
    
    func setupDate(date : String){
        publishedDateLabel.text = date
        publishedDateLabel.textColor = .gray
        publishedDateLabel.font = .systemFont(ofSize: 14)
    }
    
    func setupSubTitle(subtitle : String){
        subtitleLabel.text = subtitle
        subtitleLabel.numberOfLines = 1
        subtitleLabel.font = .systemFont(ofSize: 14)
    }
    
    func setupImage(imageURL: String?) {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        let placeholder = UIImage(named: "news")
        if let urlString = imageURL,
           let url = URL(string: urlString),
           !urlString.isEmpty {
            imageView.kf.setImage(with: url,placeholder: placeholder,options: [.transition(.fade(0.3))])
        } else {
            imageView.image = placeholder
        }
        
    }
    
    
}
