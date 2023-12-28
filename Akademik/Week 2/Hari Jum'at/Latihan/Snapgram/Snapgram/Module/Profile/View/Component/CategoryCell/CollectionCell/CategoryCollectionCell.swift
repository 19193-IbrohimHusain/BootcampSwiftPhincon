import UIKit

class CategoryCollectionCell: UICollectionViewCell {
    // MARK: - Variables
    @IBOutlet private weak var categoryBtn: UIButton!
    
    override var isSelected: Bool {
        didSet {
            categoryBtn.tintColor = isSelected ? .label : .separator
        }
    }
    
    // MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: - Functions
    private func setup() {
        categoryBtn.tintColor = .separator
    }
    
    internal func configureCollection(_ categoryEntity: CategoryCollectionEntity) {
        categoryBtn.setImage(UIImage(systemName: categoryEntity.image), for: .normal)
    }
}
