//
//  FYPCollectionViewCell.swift
//  Snapgram
//
//  Created by Phincon on 13/12/23.
//

import UIKit

protocol FYPCollectionViewCellDelegate {
    func willEndDragging(index: Int)
    func handleNavigate(index: Int)
}

class FYPCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var fypCollection: UICollectionView!
    
    internal var delegate: FYPCollectionViewCellDelegate?
    private let refreshControl = UIRefreshControl()
    private let sections = SectionFYPCollection.allCases
    private var loadedIndex: Int = 5
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
        clearSnapshot()
    }
    
    private func setup() {
        setupLoadingIndicator()
        setupCollectionView()
        setupDataSource()
        setupCompositionalLayout()
    }
    
    private func setupCollectionView() {
        fypCollection.delegate = self
        fypCollection.registerCellWithNib(FYPCollectionCell.self)
    }
    
    private func setupLoadingIndicator() {
        let layoutGuide = self.fypCollection.safeAreaLayoutGuide
        self.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            layoutGuide.centerXAnchor.constraint(equalTo: loadingIndicator.centerXAnchor),
            layoutGuide.bottomAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: 8)
        ])
        loadingIndicator.hidesWhenStopped = true
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
        
        if let allShoes = allShoes {
            let dataAll = allShoes.prefix(loadedIndex).map {
                var modifiedItem = $0
                modifiedItem.fypSection = .allShoes
                return modifiedItem
            }
            snapshot.appendItems(dataAll, toSection: .allShoes)
            let dataRunning = allShoes.filter {
                $0.category.name == "Running"
            }
            
            let runningShoes = dataRunning.map {
                var modifiedItem = $0
                modifiedItem.fypSection = .running
                return modifiedItem
            }
            snapshot.appendItems(runningShoes, toSection: .running)
            
            let dataTraining = allShoes.filter {
                $0.category.name == "Training"
            }
            
            let trainingShoes = dataTraining.map {
                var modifiedItem = $0
                modifiedItem.fypSection = .training
                return modifiedItem
            }
            snapshot.appendItems(trainingShoes, toSection: .training)
            
            let dataBasket = allShoes.filter {
                $0.category.name == "Basketball"
            }
            
            let basketShoes = dataBasket.map {
                var modifiedItem = $0
                modifiedItem.fypSection = .basketball
                return modifiedItem
            }
            snapshot.appendItems(basketShoes, toSection: .basketball)
            
            let dataHiking = allShoes.filter {
                $0.category.name == "Hiking"
            }
            
            let hikingShoes = dataHiking.map {
                var modifiedItem = $0
                modifiedItem.fypSection = .hiking
                return modifiedItem
            }
            snapshot.appendItems(hikingShoes, toSection: .hiking)
            
            if var sportShoes = allShoes.last {
                sportShoes.fypSection = .sport
                snapshot.appendItems([sportShoes], toSection: .sport)
            }
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    internal func bindData(data: [ProductModel]) {
        self.allShoes = data
        self.loadSnapshot()
    }
    
    private func loadMoreData() {
        // Fetch more items for the For You Product section
        guard let allShoes = self.allShoes, loadedIndex < allShoes.count - 1 else {
            return // No more items to load
        }
                
        let moreItems = allShoes[loadedIndex..<min(loadedIndex + 5, allShoes.count - 1)]
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
            self.loadingIndicator.stopAnimating()
        }
        loadingIndicator.startAnimating()
    }
    
    private func clearSnapshot() {
        loadedIndex = 5
        allShoes?.removeAll()
        snapshot.deleteAllItems()
        snapshot.deleteSections(sections)
        dataSource.apply(snapshot)
    }
}

extension FYPCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        self.delegate?.handleNavigate(index: index)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == sections[0].rawValue &&
            indexPath.item == dataSource.snapshot().itemIdentifiers(inSection: .allShoes).count - 1 {
            loadMoreData()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let indexPath = fypCollection.indexPathForItem(at: targetContentOffset.pointee) {
            self.delegate?.willEndDragging(index: indexPath.section)
        }
    }
}
