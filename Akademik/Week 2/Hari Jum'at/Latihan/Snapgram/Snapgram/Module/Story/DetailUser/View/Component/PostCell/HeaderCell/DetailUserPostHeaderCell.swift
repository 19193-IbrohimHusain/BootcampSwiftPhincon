//
//  DetailUserPostHeaderCell.swift
//  Snapgram
//
//  Created by Phincon on 20/12/23.
//

import UIKit

protocol DetailUserPostHeaderCellDelegate {
    func onCategorySelected(index: Int)
}

class DetailUserPostHeaderCell: UICollectionReusableView {
    // MARK: - Variables
    @IBOutlet weak var headerCollection: UICollectionView!
    
    var delegate: DetailUserPostHeaderCellDelegate?
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    let horizontalBarView = UIView()
    
    // MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollection()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        horizontalBarView.removeFromSuperview()
        setupCollection()
    }
    
    // MARK: - Functions
    func setupCollection() {
        headerCollection.delegate = self
        headerCollection.dataSource = self
        headerCollection.registerCellWithNib(DetailUserCategoryCell.self)
        setupHorizontalBar()
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        headerCollection.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .centeredHorizontally)
        headerCollection.collectionViewLayout = UICollectionViewCompositionalLayout(section: categoryLayout())
    }
    
    private func categoryLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem.entireHeight(withWidth: .fractionalWidth(1/2))
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    func setupHorizontalBar() {
        horizontalBarView.backgroundColor = .label
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
        
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftAnchorConstraint?.isActive = true
        
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
}

// MARK: - Extension for UICollectionView
extension DetailUserPostHeaderCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailUserCategoryItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DetailUserCategoryCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        let item = detailUserCategoryItem[indexPath.item]
        cell.configure(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        self.headerCollection.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        self.delegate?.onCategorySelected(index: index)
    }
}
