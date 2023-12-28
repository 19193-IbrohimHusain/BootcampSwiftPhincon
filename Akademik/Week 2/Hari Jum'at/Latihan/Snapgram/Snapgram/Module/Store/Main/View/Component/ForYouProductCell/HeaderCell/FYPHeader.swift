//
//  FYPHeader.swift
//  Snapgram
//
//  Created by Phincon on 12/12/23.
//

import UIKit

protocol FYPHeaderDelegate {
    func setCurrentSection(index: Int)
}

class FYPHeader: UICollectionReusableView {
    // MARK: - Variables
    @IBOutlet weak var headerCollection: UICollectionView!
    
    private var category: [CategoryModel]?
    internal var delegate: FYPHeaderDelegate?
    
    // MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: - Functions
    private func setup() {
        headerCollection.delegate = self
        headerCollection.dataSource = self
        headerCollection.registerCellWithNib(StoreCategoryCell.self)
    }
    
    internal func configure(data: [CategoryModel]) {
        self.category = data
        headerCollection.reloadData()
        headerCollection.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
    }
}

// MARK: - Extension for UICollectionView
extension FYPHeader: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: StoreCategoryCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        if let category = category?[indexPath.item] {
            cell.configure(data: category)
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        self.headerCollection.selectItem(at: indexPath, animated: true, scrollPosition: .left)
        self.delegate?.setCurrentSection(index: index)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16.0
    }
}
