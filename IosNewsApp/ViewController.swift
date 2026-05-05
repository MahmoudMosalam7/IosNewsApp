//
//  ViewController.swift
//  IosNewsApp
//
//  Created by Mahmoud Mosalam on 29/04/2026.
//

import UIKit
import Combine

class ViewController: UIViewController {
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private lazy var viewModel = MainViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private let errorLabel = UILabel()
    private let retryButton = UIButton(type: .system)
    private let errorStack = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCollectionView()
        setupErrorView()
        setupBinders()
        setupErrorbinders()
        viewModel.getNews()
    }
    
    func setupBinders(){
        viewModel.$articles
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func setupCollectionView(){
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = createLayout()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        collectionView.register(HeaderCollectionViewCell.self, forCellWithReuseIdentifier: "HeaderCell")
        collectionView.register(HorizontalCountriesButtonCollectionViewCell.self, forCellWithReuseIdentifier: "HorizontalCell")
        collectionView.register(NewsCardCollectionViewCell.self, forCellWithReuseIdentifier: "ListCell")
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = Section(rawValue: sectionIndex) else { return nil }
            switch section {
            case .header:
                return self.createHeaderSection()
            case .horizontal:
                return self.createHorizontalSection()
            case .list:
                return self.createListSection()
            }
        }
    }
    
    func createHeaderSection() -> NSCollectionLayoutSection {
        let item = CompositionalHelper.createItem(width: .fractionalWidth(1), height: .estimated(60))
        let group = CompositionalHelper.createGroup(alignment: .vertical, width: .fractionalWidth(1), height: .estimated(60), item: item,count: 1,interItemSpacing: 8)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    func createHorizontalSection() -> NSCollectionLayoutSection {
        let item = CompositionalHelper.createItem(width: .estimated(100), height: .absolute(45), topSpacing: 0, bottomSpacing: 0, leadingSpacing: 4, trailingSpacing: 4)
        let group = CompositionalHelper.createGroup(alignment: .horizontal, width: .estimated(100), height: .absolute(45), items: [item], interItemSpacing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 12,
            leading: 16,
            bottom: 12,
            trailing: 16
        )
        section.interGroupSpacing = 4
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    
    func createListSection() -> NSCollectionLayoutSection {
        let item = CompositionalHelper.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), topSpacing: 0, bottomSpacing: 0, leadingSpacing: 0, trailingSpacing: 0)
        let group = CompositionalHelper.createGroup(alignment: .vertical, width: .fractionalWidth(1), height: .fractionalHeight(0.5), items: [item], interItemSpacing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16  
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 16,
            leading: 0,
            bottom: 16,
            trailing: 0
        )
        return section
    }
    
    func setupErrorView() {
        errorLabel.textAlignment = .center
        errorLabel.textColor = .systemRed
        errorLabel.numberOfLines = 0
        retryButton.setTitle("Retry", for: .normal)
        retryButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
        errorStack.axis = .vertical
        errorStack.spacing = 12
        errorStack.alignment = .center
        errorStack.isHidden = true
        errorStack.addArrangedSubview(errorLabel)
        errorStack.addArrangedSubview(retryButton)
        view.addSubview(errorStack)
        errorStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func didTapRetry() {
        viewModel.getNews()
    }
    
    func setupErrorbinders(){
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    self.showErrorView(message: error)
                } else {
                    self.hideErrorView()
                }
            }
            .store(in: &cancellables)
    }
    
    func showErrorView(message: String) {
        errorLabel.text = message
        errorStack.isHidden = false
        collectionView.isHidden = true
    }

    func hideErrorView() {
        errorStack.isHidden = true
        collectionView.isHidden = false
    }

}

extension ViewController :  UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let sectionType = Section(rawValue: section)!
        
        switch sectionType {
        case .header:
            return 1
        case .horizontal:
            return viewModel.countries.count
        case .list:
            return viewModel.articles.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        switch section {
        case .header:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCell",for: indexPath) as? HeaderCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.setup(title: "Top News")
            return cell
        case .horizontal:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "HorizontalCell",
                for: indexPath
            ) as? HorizontalCountriesButtonCollectionViewCell else {
                return UICollectionViewCell()
            }
            let country = viewModel.countries[indexPath.row]
            cell.Setup(country: country.uppercased())
            return cell
        case .list:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell",for: indexPath) as? NewsCardCollectionViewCell else {
                return UICollectionViewCell()
            }
            let article = viewModel.articles[indexPath.row]
            return verticalScrolling(cell: cell, article: article, row: indexPath.row)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = Section(rawValue: indexPath.section)
        if section == .horizontal {
            let selectedCountry = viewModel.countries[indexPath.row]
            viewModel.getNews(country: selectedCountry)
        }
        if section == .list {
            let article = viewModel.articles[indexPath.row]
            if let destinationVC = self.mainStoryboard.instantiateViewController(withIdentifier: "NewsDetailsVC") as? NewsDetailsVC {
                destinationVC.article = article
                self.navigationController?.pushViewController(destinationVC, animated: true)
            }
        }
    }
    private func verticalScrolling(cell: NewsCardCollectionViewCell, article: Article, row: Int) -> NewsCardCollectionViewCell {
        cell.setup(
            title: article.title,
            subtitle: article.author ?? "Unknown",
            imageURL: article.urlToImage ?? "",
            publishedAt: article.publishedAt
        )
        return cell
    }
}
