//
//  NewsMarkVC.swift
//  IosNewsApp
//
//  Created by Mahmoud Mosalam on 30/04/2026.
//

import UIKit
import Combine

class NewsMarkVC: UIViewController {
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private lazy var viewModel = NewsMarkViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    private let errorView = ErrorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        viewModel.fetchNews()
        setupBinders()
        setupErrorView()
        setupErrorbinders()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchNews()
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
        collectionView.register(NewsCardCollectionViewCell.self, forCellWithReuseIdentifier: "ListCell")
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = Section(rawValue: sectionIndex) else { return nil }
            switch section {
            case .header:
                return self.createHeaderSection()
            case .horizontal:
                return nil
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

    func setupBinders(){
        viewModel.$articles
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: CoreDataManager.didChangeSavedNews)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.fetchNews()
            }
            .store(in: &cancellables)
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
            self?.viewModel.fetchNews()
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

extension NewsMarkVC :  UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = Section(rawValue: section)!
        switch sectionType {
        case .header:
            return 1
        case .horizontal:
            return 0
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
            cell.setup(title: "News Mark")
            return cell
        case .horizontal:
            return UICollectionViewCell()
        case .list:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell",for: indexPath) as? NewsCardCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            return verticalScrolling(cell: cell, row: indexPath.row)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = Section(rawValue: indexPath.section)
        if section == .list {
            let article = viewModel.articles[indexPath.row]
            if let destinationVC = self.mainStoryboard.instantiateViewController(withIdentifier: "NewsDetailsVC") as? NewsDetailsVC {
                destinationVC.article = article
                self.navigationController?.pushViewController(destinationVC, animated: true)
            }
        }
    }
    
    private func verticalScrolling(cell: NewsCardCollectionViewCell, row: Int) -> NewsCardCollectionViewCell {
        let article = viewModel.articles[row]
        cell.setup(
            title: article.title,
            subtitle: article.author ?? "Unknown",
            imageURL: article.urlToImage ?? "",
            publishedAt: article.publishedAt
        )
        return cell
    }
    
    
    
}
