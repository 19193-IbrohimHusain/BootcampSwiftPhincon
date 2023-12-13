//
//  FYPCollectionViewCell.swift
//  Snapgram
//
//  Created by Phincon on 13/12/23.
//

import UIKit

protocol FYPCollectionViewCellDelegate {
    func sendHeight(height: CGFloat)
    func didScroll(scrollView: UIScrollView)
}

class FYPCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var fypCollection: UICollectionView!
    
    internal var delegate: FYPCollectionViewCellDelegate?
    private let refreshControl = UIRefreshControl()
    private let sections = SectionFYPCollection.allCases
    private var loadedIndex: Int = 5
    private var isLoadMoreData = false
    private var allShoes: [ProductModel]?
    private var snapshot = NSDiffableDataSourceSnapshot<SectionFYPCollection, ProductModel>()
    private var dataSource: UICollectionViewDiffableDataSource<SectionFYPCollection, ProductModel>!
    private var layout: UICollectionViewCompositionalLayout!
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        loadedIndex = 5
        allShoes?.removeAll()
        snapshot.deleteAllItems()
        snapshot.deleteSections(sections)
        dataSource.apply(snapshot)
    }
    
    private func setup() {
        let layoutGuide = self.fypCollection.safeAreaLayoutGuide
        self.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            layoutGuide.centerXAnchor.constraint(equalTo: loadingIndicator.centerXAnchor),
            layoutGuide.bottomAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: 8)
        ])
        loadingIndicator.hidesWhenStopped = true
        fypCollection.delegate = self
        fypCollection.registerCellWithNib(FYPCollectionCell.self)
        setupDataSource()
        setupCompositionalLayout()
    }
    
    private func setupDataSource() {
        dataSource = .init(collectionView: fypCollection) { (collectionView, indexPath, product) in
            let cell: FYPCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.configure(with: product)
            return cell
        }
    }
    
    private func setupCompositionalLayout() {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        layout = .init(sectionProvider: { [weak self] (sectionIndex, env) in
            guard let self = self, let section = SectionFYPCollection(rawValue: sectionIndex) else {
                fatalError("Invalid section index")
            }
            
            switch section {
            case .allShoes, .running, .training, .basketball, .hiking, .sport:
                return self.createFYPLayout(for: section, env: env)
            }
        }, configuration: config)
        
        fypCollection.collectionViewLayout = layout
    }
    
    private func createFYPLayout(for section: SectionFYPCollection, env: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let items = self.snapshot.itemIdentifiers(inSection: section)
        return NSCollectionLayoutSection.createFYPLayout(env: env, items: items, section: section.rawValue)
    }
    
    private func loadSnapshot() {
        snapshot.appendSections(sections)
        
        if let allShoes = allShoes, allShoes.count >= 29 {
            snapshot.appendItems(Array(allShoes.prefix(loadedIndex)), toSection: .allShoes)
            snapshot.appendItems(Array(allShoes[14...17]), toSection: .running)
            snapshot.appendItems(Array(allShoes[18...21]), toSection: .training)
            snapshot.appendItems(Array(allShoes[22...25]), toSection: .basketball)
            snapshot.appendItems(Array(allShoes[26...27]), toSection: .hiking)
            snapshot.appendItems(Array(arrayLiteral: allShoes[28]), toSection: .sport)
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    internal func bindData(data: [ProductModel]) {
        self.allShoes = data
        self.loadSnapshot()
    }
    
    private func loadMoreData() {
        // Fetch more items for the For You Product section
        guard let allShoes = self.allShoes?.prefix(14), loadedIndex < allShoes.count else {
            return // No more items to load
        }
        
        isLoadMoreData = true
        
        let moreItems = allShoes[loadedIndex..<min(loadedIndex + 5, allShoes.count)]
        let modifiedItems = moreItems.map {
            var modifiedItem = $0
            modifiedItem.cellTypes = .forYouProduct
            return modifiedItem
        }
        
        loadedIndex += 5 // Update the loaded index
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Update the snapshot with the newly loaded items
            self.snapshot.appendItems(modifiedItems, toSection: .allShoes)
            self.dataSource.apply(self.snapshot, animatingDifferences: true)
            self.isLoadMoreData = false
            self.loadingIndicator.stopAnimating()
        }
        loadingIndicator.startAnimating()
    }
}

extension FYPCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == sections[0].rawValue &&
            indexPath.item == dataSource.snapshot().itemIdentifiers(inSection: .allShoes).count - 1 {
            loadMoreData()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.didScroll(scrollView: scrollView)
    }
}
