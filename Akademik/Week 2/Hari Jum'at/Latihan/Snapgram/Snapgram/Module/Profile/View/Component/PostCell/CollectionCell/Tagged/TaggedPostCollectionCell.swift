//
//  TaggedPostCollectionCell.swift
//  Snapgram
//
//  Created by Phincon on 04/12/23.
//

import UIKit

protocol TaggedPostCollectionCellDelegate {
    func navigateToDetail(id: String)
    func sendTagHeight(height: CGFloat)
}

class TaggedPostCollectionCell: UICollectionViewCell {
    // MARK: - Variable
    @IBOutlet weak var tagCollection: UICollectionView!
    
    @IBOutlet weak var heightCollection: NSLayoutConstraint!
    
    internal var delegate: TaggedPostCollectionCellDelegate?
    private var tagged: [ListStory]?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollection()
    }
    
    // MARK: - Functions
    private func setupCollection() {
        tagCollection.delegate = self
        tagCollection.dataSource = self
        tagCollection.registerCellWithNib(TagPhotoCell.self)
    }
    
    internal func configure(data: [ListStory]) {
        self.tagged = data
        tagCollection.reloadData()
    }
}

// MARK: - Extension for UICollectionView
extension TaggedPostCollectionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagged?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TagPhotoCell
        if let tagData = tagged?[indexPath.item] {
            cell.configureCollection(tagData)
        }
        self.delegate?.sendTagHeight(height: collectionView.contentSize.height)
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let storyID = tagged?[indexPath.item].id {
            self.delegate?.navigateToDetail(id: storyID)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width / 3
        return CGSize(width: itemWidth, height: 150)
    }
}
