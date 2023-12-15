import UIKit

protocol CategoryTableCellDelegate {
    func setCurrentSection(index: Int)
}

class CategoryTableCell: UITableViewCell {

    @IBOutlet weak var categoryCollection: UICollectionView!
    
    var delegate: CategoryTableCellDelegate?
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollection()
    }
    
    func setupCollection() {
        categoryCollection.delegate = self
        categoryCollection.dataSource = self
        categoryCollection.registerCellWithNib(CategoryCollectionCell.self)
        setupHorizontalBar()
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        categoryCollection.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .bottom)
    }
    
    func setupHorizontalBar() {
        let horizontalBarView = UIView()
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

extension CategoryTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let itemWidth = collectionViewWidth / 2
        return CGSize(width: itemWidth, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as CategoryCollectionCell
        let categoryEntity = categoryItem[indexPath.item]
        cell.configureCollection(categoryEntity)
        cell.delegate = self
        cell.index = indexPath.item
        
        return cell
    }
}

extension CategoryTableCell: CategoryCollectionCellDelegate {
    func onCategorySelected(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        self.categoryCollection.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        self.delegate?.setCurrentSection(index: index)
    }
}

