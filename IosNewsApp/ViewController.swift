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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCollectionView()
        setupBinders()
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
           let item = CompositionalHelper.createItem(width: .fractionalWidth(1), height: .estimated(380), topSpacing: 8, bottomSpacing: 8, leadingSpacing: 8, trailingSpacing: 8)
           let group = CompositionalHelper.createGroup(alignment: .vertical, width: .fractionalWidth(1), height: .estimated(380), items: [item], interItemSpacing: 8)
           let section = NSCollectionLayoutSection(group: group)
           return section
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
            viewModel.getNews(country: selectedCountry)   // 🔥 CALL API AGAIN
        }
    }
    private func verticalScrolling(cell: NewsCardCollectionViewCell, article: Article, row: Int) -> NewsCardCollectionViewCell {
        
        imageTapped(cell: cell, row: row)
        saveButtonTapped(cell: cell, row: row)
        
        cell.setup(
            title: article.title,
            subtitle: article.author ?? "Unknown",
            imageURL: article.urlToImage ?? "",
            publishedAt: article.publishedAt
        )
        
        return cell
    }
    
    private func imageTapped(cell : NewsCardCollectionViewCell,row: Int){
        cell.onImageTapped = { [weak self] in
            print("Image tapped at index: \(row)")
            let alert = UIAlertController(title: "News Details", message: "You tapped News \(row) image", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
    private func saveButtonTapped(cell : NewsCardCollectionViewCell,row: Int){
        cell.onSaveButtonTapped = { [weak self] in
            print("Save button tapped at index: \(row)")
            let alert = UIAlertController(title: "Saved", message: "News \(row) has been saved!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
}
