//
//  ViewController.swift
//  IosNewsApp
//
//  Created by Mahmoud Mosalam on 29/04/2026.
//

import UIKit

class ViewController: UIViewController {
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCollectionView()
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
            return 10
        case .list:
            return 10
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
            cell.Setup(country: "Country \(indexPath.row)")
            return cell
        case .list:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell",for: indexPath) as? NewsCardCollectionViewCell else {
                return UICollectionViewCell()
            }
            return verticalScrolling(cell: cell, row: indexPath.row)
        }
    }
    
    private func verticalScrolling(cell : NewsCardCollectionViewCell,row: Int)->NewsCardCollectionViewCell{
        // Handle image tap
        imageTapped(cell:cell, row : row)
        // Handle save button tap
        saveButtonTapped(cell:cell, row : row)
        cell.setup(
            title: "News \(row)",
            subtitle: "Author \(row)",
            imageURL: "",
            publishedAt: "123"
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
