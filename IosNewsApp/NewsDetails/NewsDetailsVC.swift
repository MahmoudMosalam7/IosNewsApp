//
//  NewsDetailsVC.swift
//  IosNewsApp
//
//  Created by Mahmoud Mosalam on 02/05/2026.
//

import UIKit

class NewsDetailsVC: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let authorLabel = UILabel()
    private let publishedLabel = UILabel()
    private let descriptionHeaderLabel = UILabel()
    private let contentLabel = UILabel()
    private let contentHeaderLabel = UILabel()
    private let nameLabel = UILabel()
    private let bookmarkButton = UIButton()
    private let metaStackView = UIStackView()
    private let padding: CGFloat = 16
    private let spacing: CGFloat = 12
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAllViews()
        populateTitleAndMeta()
        populateDescriptionAndContent()
    }
    
    private func setupAllViews() {
        setupScrollView()
        setupContentView()
        setupImageView()
        setupTitleLabel()
        setupNameLabel()
        setupAuthorLabel()
        configureMetaStackView()
        addArrangedSubviews()
        setupPublishedLabel()
        setupDescriptionHeaderLabel()
        setupDescriptionLabel()
        setupContentHeaderLabel()
        setupContentLabel()
        setupBookmarkButton()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
   
    private func setupContentView() {
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupImageView() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .label
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
    }
    
    private func setupNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        nameLabel.textColor = .label
    }
    
    private func setupAuthorLabel() {
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.font = .systemFont(ofSize: 13, weight: .regular)
        authorLabel.textColor = .secondaryLabel
    }
    
    private func setupPublishedLabel() {
        contentView.addSubview(publishedLabel)
        publishedLabel.translatesAutoresizingMaskIntoConstraints = false
        publishedLabel.font = .systemFont(ofSize: 13, weight: .regular)
        publishedLabel.textColor = .secondaryLabel
        NSLayoutConstraint.activate([
            publishedLabel.topAnchor.constraint(equalTo: metaStackView.bottomAnchor, constant: spacing),
            publishedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            publishedLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding)
        ])
    }
    
    private func setupDescriptionHeaderLabel() {
        contentView.addSubview(descriptionHeaderLabel)
        descriptionHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionHeaderLabel.text = "Description"
        descriptionHeaderLabel.font = .boldSystemFont(ofSize: 18)
        descriptionHeaderLabel.textColor = .label
        NSLayoutConstraint.activate([
            descriptionHeaderLabel.topAnchor.constraint(
                equalTo: publishedLabel.bottomAnchor,
                constant: padding + spacing
            ),
            descriptionHeaderLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: padding
            ),
            descriptionHeaderLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -padding
            )
        ])
    }
    
    private func setupDescriptionLabel() {
        contentView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .label
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(
                equalTo: descriptionHeaderLabel.bottomAnchor,
                constant: spacing
            ),
            descriptionLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: padding
            ),
            descriptionLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -padding
            )
        ])
    }
    
    private func setupContentHeaderLabel() {
        contentView.addSubview(contentHeaderLabel)
        contentHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        contentHeaderLabel.text = "Content"
        contentHeaderLabel.font = .boldSystemFont(ofSize: 18)
        contentHeaderLabel.textColor = .label
        NSLayoutConstraint.activate([
            contentHeaderLabel.topAnchor.constraint(
                equalTo: descriptionLabel.bottomAnchor,
                constant: padding + spacing
            ),
            contentHeaderLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: padding
            ),
            contentHeaderLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -padding
            )
        ])
    }
    
    private func setupContentLabel() {
        contentView.addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentLabel.numberOfLines = 0
        contentLabel.font = .systemFont(ofSize: 16)
        contentLabel.textColor = .label
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(
                equalTo: contentHeaderLabel.bottomAnchor,
                constant: spacing
            ),
            contentLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: padding
            ),
            contentLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -padding
            ),
            contentLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -padding
            )
        ])
    }
    
    private func setupBookmarkButton() {
        bookmarkButton.translatesAutoresizingMaskIntoConstraints = false
        bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        bookmarkButton.tintColor = .systemBlue
        bookmarkButton.addTarget(self, action: #selector(toggleBookmark), for: .touchUpInside)
        NSLayoutConstraint.activate([
            bookmarkButton.widthAnchor.constraint(equalToConstant: 40),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureMetaStackView() {
        contentView.addSubview(metaStackView)
        metaStackView.translatesAutoresizingMaskIntoConstraints = false
        metaStackView.axis = .horizontal
        metaStackView.alignment = .center
        metaStackView.spacing = spacing
        metaStackView.distribution = .fill
        NSLayoutConstraint.activate([
            metaStackView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: spacing
            ),
            metaStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: padding
            ),
            metaStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -padding
            ),
            metaStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 40)
        ])
    }
    
    private func addArrangedSubviews() {
        metaStackView.addArrangedSubview(nameLabel)
        metaStackView.addArrangedSubview(authorLabel)
        
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        metaStackView.addArrangedSubview(spacer)
        
        metaStackView.addArrangedSubview(bookmarkButton)
    }
    
    @objc private func toggleBookmark() {
        bookmarkButton.isSelected = !bookmarkButton.isSelected
    }

    private func populateTitleAndMeta() {
        titleLabel.text = "Breaking News: Major Technology Breakthrough"
        nameLabel.text = "TechNews Daily"
        authorLabel.text = "By John Developer"
        publishedLabel.text = "Published: May 2, 2026"
    }
    
    private func populateDescriptionAndContent() {
        descriptionLabel.text = "A groundbreaking development in artificial intelligence has been unveiled today, marking a significant milestone."
        contentLabel.text = "Scientists have created a new framework improving existing models by 40% in speed and accuracy."
    }
}
