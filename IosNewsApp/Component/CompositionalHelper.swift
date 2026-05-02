//
//  CompositionalHelper.swift
//  IosNewsApp
//
//  Created by Mahmoud Mosalam on 02/05/2026.
//

import UIKit
struct CompositionalHelper{
    
    static func createItem(
        width : NSCollectionLayoutDimension,
        height : NSCollectionLayoutDimension,
        topSpacing : CGFloat = 8,
        bottomSpacing : CGFloat = 8,
        leadingSpacing : CGFloat = 8,
        trailingSpacing : CGFloat = 8,
    ) -> NSCollectionLayoutItem {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: width,heightDimension: height))
        item.contentInsets = NSDirectionalEdgeInsets(top: topSpacing, leading: leadingSpacing, bottom: bottomSpacing, trailing: trailingSpacing)
        return item
    }
    
    static func createGroup(
        alignment: GroupAlignment,
        width: NSCollectionLayoutDimension,
        height: NSCollectionLayoutDimension,
        item: NSCollectionLayoutItem,
        count: Int,
        interItemSpacing: CGFloat = 0
    ) -> NSCollectionLayoutGroup {
        let groupSize = NSCollectionLayoutSize(
            widthDimension: width,
            heightDimension: height
        )
        let group: NSCollectionLayoutGroup
        switch alignment {
        case .vertical:
            group = .vertical(layoutSize: groupSize, repeatingSubitem: item, count: count)
        case .horizontal:
            group = .horizontal(layoutSize: groupSize, repeatingSubitem: item, count: count)
        }
        
        group.interItemSpacing = .fixed(interItemSpacing)
        
        return group
        
    }
    
    static func createGroup(
        alignment: GroupAlignment,
        width: NSCollectionLayoutDimension,
        height: NSCollectionLayoutDimension,
        items: [NSCollectionLayoutItem],
        interItemSpacing: CGFloat = 0
    ) -> NSCollectionLayoutGroup {
        let groupSize = NSCollectionLayoutSize(
            widthDimension: width,
            heightDimension: height
        )
        let group: NSCollectionLayoutGroup
        switch alignment {
        case .vertical:
            group = .vertical(layoutSize: groupSize, subitems: items)
        case .horizontal:
            group = .horizontal(layoutSize: groupSize, subitems: items)
        }
        group.interItemSpacing = .fixed(interItemSpacing)
        return group
    }
}

