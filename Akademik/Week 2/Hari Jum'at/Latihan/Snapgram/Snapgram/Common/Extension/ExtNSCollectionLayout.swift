//
//  ExtNSCollectionLayoutItem.swift
//  Snapgram
//
//  Created by Phincon on 07/12/23.
//

import UIKit

extension NSCollectionLayoutItem {
    static func withEntireSize() -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        return NSCollectionLayoutItem(layoutSize: itemSize)
    }
    
    static func entireWidth(withHeight height: NSCollectionLayoutDimension) -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: height)
        return NSCollectionLayoutItem(layoutSize: itemSize)
    }
}

extension NSCollectionLayoutSection {
    
    static func listSection(withEstimatedHeight estimatedHeight: CGFloat = 100) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 15, bottom: 10, trailing: 15)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(estimatedHeight))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])
        layoutGroup.interItemSpacing = .fixed(10)
        
        return NSCollectionLayoutSection(group: layoutGroup)
    }
    
    static func searchSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem.entireWidth(withHeight: .fractionalHeight(1.0))
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(70))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: layoutGroup)
        section.contentInsets = .uniform(size: 16)
        
        return section
    }
    
    static func carouselSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem.entireWidth(withHeight: .fractionalHeight(1.0))
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .uniform(size: 16)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        return section
    }
    
    static func popularListSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem.entireWidth(withHeight: .fractionalHeight(1/3))
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(450))
        
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [item])
        layoutGroup.interItemSpacing = .fixed(10)
        let section = NSCollectionLayoutSection(group: layoutGroup)
        section.contentInsets = .uniform(size: 16)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        return section
    }
    
    static func forYouPageSection(env: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem.entireWidth(withHeight: .fractionalHeight(1/3))
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(env.container.contentSize.height))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [item])
        layoutGroup.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: layoutGroup)
        section.contentInsets = .uniform(size: 16)
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    static func largeGridSection(itemInsets: NSDirectionalEdgeInsets = .uniform(size: 5)) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = itemInsets
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        return NSCollectionLayoutSection(group: group)
    }
}
