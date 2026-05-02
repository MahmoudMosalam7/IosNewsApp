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
    private let saveButton = UIButton()
    // Closures for click handlers
    var onImageTapped: (() -> Void)?
    var onSaveButtonTapped: (() -> Void)?
        
    func setup(
        title : String,
        subtitle: String,
        imageURL: String,
        publishedAt: String
        
    ){
        setupView()
        setupTitle(title : title)
        setupDate(date : publishedAt)
        setupSubTitle(subtitle : subtitle)
        setupImage(imageURL :imageURL)
        setupButtonSave()
        
    }
    func setupView(){
        let titleAndDateStack = UIStackView(arrangedSubviews: [titleLabel, publishedDateLabel])
        titleAndDateStack.axis = .horizontal
        titleAndDateStack.distribution = .equalSpacing
        let bottomStack = UIStackView(arrangedSubviews: [subtitleLabel, saveButton])
        bottomStack.axis = .horizontal
        bottomStack.distribution = .equalSpacing
        let stack = UIStackView(arrangedSubviews: [imageView, titleAndDateStack, bottomStack])
        stack.axis = .vertical
        stack.spacing = 8
        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            saveButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setupTitle(title : String){
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.text = title
    }
    
    func setupDate(date : String){
        publishedDateLabel.text = date
        publishedDateLabel.font = .systemFont(ofSize: 14)
    }
    
    func setupSubTitle(subtitle : String){
        subtitleLabel.text = subtitle
        subtitleLabel.font = .systemFont(ofSize: 14)
    }
    
    func setupImage(imageURL: String,){
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.kf.setImage(with: URL(string: "https://picsum.photos/400/200"))
        imageView.isUserInteractionEnabled = true
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imageView.addGestureRecognizer(imageTapGesture)
    }
    
    func setupButtonSave(){
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.systemBlue, for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        saveButton.setContentHuggingPriority(.required, for: .vertical)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc private func imageTapped() {
        onImageTapped?()
    }
    
    @objc private func saveButtonTapped() {
        onSaveButtonTapped?()
    }
}
