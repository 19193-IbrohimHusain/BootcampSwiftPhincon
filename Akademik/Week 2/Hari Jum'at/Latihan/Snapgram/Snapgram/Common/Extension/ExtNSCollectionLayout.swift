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
    
    static func entireHeight(withWidth width: NSCollectionLayoutDimension) -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(widthDimension: width, heightDimension: .fractionalHeight(1.0))
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
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(70))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: layoutGroup)
        section.contentInsets = .horizontalInsets(size: 16)
        
        return section
    }
    
    static func carouselSection() -> NSCollectionLayoutSection {
        // Supplementary item for page control
        let pageControlItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)),
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )

        let item = NSCollectionLayoutItem.withEntireSize()
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.boundarySupplementaryItems = [pageControlItem]
        section.interGroupSpacing = 8

        return section
    }
    
    static func popularListSection() -> NSCollectionLayoutSection {
        let pageControlItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)),
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        
        let item = NSCollectionLayoutItem.entireWidth(withHeight: .fractionalHeight(1/3))
        item.contentInsets = .verticalInsets(size: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(345))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: layoutGroup)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [pageControlItem]
        section.interGroupSpacing = 16
        section.contentInsets =  NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        return section
    }
    
    static func forYouPageSection() -> NSCollectionLayoutSection {
        let randomHeight = CGFloat.random(in: 250...300)
        let itemLayout = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(randomHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemLayout)
        item.contentInsets = .uniform(size: 5)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .absolute(2600))
        
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, repeatingSubitem: item, count: 7)
        
        let section = NSCollectionLayoutSection(group: layoutGroup)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 32)
        section.interGroupSpacing = 5
        
        return section
    }
    
    static func createFYPLayout(env: NSCollectionLayoutEnvironment, items: [ProductModel]) -> NSCollectionLayoutSection {
        
        let sectionHorizontalSpacing: CGFloat = 20
    
        let layout = FYPLayout.makeLayoutSection(
            config: .init(
                columnCount: 2,
                interItemSpacing: 10,
                sectionHorizontalSpacing: sectionHorizontalSpacing,
                itemCountProvider:  {
                    return items.count
                },
                itemHeightProvider: { index, itemWidth in
                    var randomHeight = CGFloat()
                    items.forEach { _ in
                        randomHeight = CGFloat.random(in: 280...350)
                    }
                    return CGFloat(randomHeight)
                }),
            enviroment: env, sectionIndex: 3
        )
        
        layout.contentInsets = .init(
            top: 20,
            leading: 50,
            bottom: 20,
            trailing: 8
        )
        
        return layout
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
