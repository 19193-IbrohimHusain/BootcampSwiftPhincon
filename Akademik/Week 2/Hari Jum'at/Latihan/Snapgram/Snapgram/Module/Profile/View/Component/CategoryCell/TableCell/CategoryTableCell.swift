import UIKit

protocol CategoryTableCellDelegate {
    func setCurrentSection(index: Int)
}

class CategoryTableCell: UITableViewCell {
    // MARK: - Variables
    @IBOutlet weak var categoryCollection: UICollectionView!
    
    internal var delegate: CategoryTableCellDelegate?
    internal var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    private let horizontalBarView = UIView()
    
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
    private func setupCollection() {
        categoryCollection.delegate = self
        categoryCollection.dataSource = self
        categoryCollection.registerCellWithNib(CategoryCollectionCell.self)
        setupHorizontalBar()
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        categoryCollection.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .centeredHorizontally)
        categoryCollection.collectionViewLayout = UICollectionViewCompositionalLayout(section: categoryLayout())
    }
    
    private func categoryLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem.entireHeight(withWidth: .fractionalWidth(1/2))
        let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }
    
    private func setupHorizontalBar() {
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
extension CategoryTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as CategoryCollectionCell
        let categoryEntity = categoryItem[indexPath.item]
        cell.configureCollection(categoryEntity)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        self.categoryCollection.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        self.delegate?.setCurrentSection(index: index)
    }
}
