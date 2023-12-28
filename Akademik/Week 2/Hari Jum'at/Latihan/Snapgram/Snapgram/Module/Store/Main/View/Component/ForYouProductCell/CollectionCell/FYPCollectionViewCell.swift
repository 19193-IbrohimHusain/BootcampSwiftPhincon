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
    // MARK: - Variables
    @IBOutlet weak var fypCollection: UICollectionView!
    
    internal var delegate: FYPCollectionViewCellDelegate?
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
    
    // MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        clearSnapshot()
    }
    
    // MARK: - SetupUI
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
            guard let self = self, let section = SectionFYPCollection(rawValue: sectionIndex) else { fatalError("Invalid section index") }
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
}

// MARK: - Extension for Data Handling
extension FYPCollectionViewCell {
    internal func bindData(data: [ProductModel]) {
        allShoes = data
        loadSnapshot()
    }
    
    private func loadSnapshot() {
        guard let allShoes = allShoes else { return }
        if snapshot.sectionIdentifiers.isEmpty {
            snapshot.appendSections(sections)
        }
        appendDataToSnapshot(allShoes: allShoes)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func appendDataToSnapshot(allShoes: [ProductModel]) {
        let dataAll = allShoes.prefix(loadedIndex).map { var modifiedItem = $0; modifiedItem.fypSection = .allShoes; return modifiedItem }
        snapshot.appendItems(dataAll, toSection: .allShoes)

        let categories: [(String, SectionFYPCollection)] = [
            ("Running", .running),
            ("Training", .training),
            ("Basketball", .basketball),
            ("Hiking", .hiking)
        ]
        
        for (categoryName, section) in categories {
            let filteredShoes = mapShoes(allShoes, category: categoryName, section: section)
            snapshot.appendItems(filteredShoes, toSection: section)
        }

        if var sportShoes = allShoes.last {
            sportShoes.fypSection = .sport
            snapshot.appendItems([sportShoes], toSection: .sport)
        }
    }
    
    private func mapShoes(_ shoes: [ProductModel], category: String, section: SectionFYPCollection) -> [ProductModel] {
        return shoes.filter { $0.category.name == category }.map {
            var modifiedItem = $0
            modifiedItem.fypSection = section
            return modifiedItem
        }
    }
    
    private func loadMoreData() {
        guard let allShoes = allShoes, loadedIndex < allShoes.count - 1 else { return }
        
        let moreItems = allShoes[loadedIndex..<min(loadedIndex + 5, allShoes.count - 1)]
        let modifiedItem = moreItems.map { var item = $0; item.fypSection = .allShoes; return item }
        loadedIndex += 5
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.snapshot.appendItems(modifiedItem, toSection: .allShoes)
            self.dataSource.apply(self.snapshot, animatingDifferences: true)
            self.loadingIndicator.stopAnimating()
        }
        loadingIndicator.startAnimating()
    }
    
    private func clearSnapshot() {
        loadedIndex = 5
        allShoes?.removeAll()
        snapshot.deleteAllItems()
        dataSource.apply(snapshot)
    }
}

// MARK: - Extension for UICollectionViewDelegate
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
