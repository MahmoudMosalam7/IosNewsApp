//
//  ViewController.swift
//  IosNewsApp
//
//  Created by Mahmoud Mosalam on 29/04/2026.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private lazy var viewModel = MainViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private let errorView = ErrorView()
    private var didSelectCountry = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCollectionView()
        setupCollectionViewCell()
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
    }
    
    func setupCollectionViewCell(){
        collectionView.register(HeaderCollectionViewCell.self, forCellWithReuseIdentifier: "HeaderCell")
        collectionView.register(HorizontalCountriesButtonCollectionViewCell.self, forCellWithReuseIdentifier: "HorizontalCell")
        collectionView.register(NewsCardCollectionViewCell.self, forCellWithReuseIdentifier: "ListCell")
        collectionView.register(EmptyCollectionViewCell.self, forCellWithReuseIdentifier: "EmptyCell")
        collectionView.register(EmptyCollectionViewCell.self, forCellWithReuseIdentifier: "EmptyCell")
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
        view.addSubview(errorView)
        errorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        errorView.onRetry = { [weak self] in
            self?.viewModel.getNews()
        }
    }
    
    func setupErrorbinders() {
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self = self else { return }
                if let error = error {
                    self.errorView.show(message: error)
                    self.collectionView.isHidden = true
                } else {
                    self.errorView.hide()
                    self.collectionView.isHidden = false
                }
            }
            .store(in: &cancellables)
    }

}

extension MainViewController :  UICollectionViewDelegate, UICollectionViewDataSource{
    
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
            if didSelectCountry && viewModel.articles.isEmpty {
                return 1
            }
            return viewModel.articles.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            return UICollectionViewCell()
        }
        switch section {
        case .header:
            return makeHeaderCell(collectionView, indexPath: indexPath)
            
        case .horizontal:
            return makeCountryCell(collectionView, indexPath: indexPath)
            
        case .list:
            return makeListCell(collectionView, indexPath: indexPath)
        }
    }
    
    private func makeHeaderCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "HeaderCell",
            for: indexPath
        ) as? HeaderCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setup(title: "Top News")
        return cell
    }
    
    private func makeCountryCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "HorizontalCell",
            for: indexPath
        ) as? HorizontalCountriesButtonCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let country = viewModel.countries[indexPath.row]
        cell.Setup(country: country.uppercased())
        
        return cell
    }
    
    private func makeListCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        
        if shouldShowEmptyState() {
            return makeEmptyCell(collectionView, indexPath: indexPath)
        }
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ListCell",
            for: indexPath
        ) as? NewsCardCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let article = viewModel.articles[indexPath.row]
        return verticalScrolling(cell: cell, article: article, row: indexPath.row)
    }
    
    private func makeEmptyCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "EmptyCell",
            for: indexPath
        ) as! EmptyCollectionViewCell
        
        cell.configure(message: "No articles for this country")
        return cell
    }
    
    private func shouldShowEmptyState() -> Bool {
        return didSelectCountry && viewModel.articles.isEmpty
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = Section(rawValue: indexPath.section)
        if section == .horizontal {
            let selectedCountry = viewModel.countries[indexPath.row]
            didSelectCountry = true
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
