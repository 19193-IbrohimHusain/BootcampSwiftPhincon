import UIKit

protocol CategoryCollectionCellDelegate {
    func onCategorySelected(index: Int)
}

class CategoryCollectionCell: UICollectionViewCell {

    @IBOutlet weak var categoryBtn: UIButton!
    
    var index: Int = Int()
    var delegate: CategoryCollectionCellDelegate?
    
    override var isHighlighted: Bool {
        didSet {
            categoryBtn.tintColor = isHighlighted ? .systemGray : .label
        }
    }
    
    override var isSelected: Bool {
        didSet {
            categoryBtn.tintColor = isSelected ? .label : .systemGray
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCollection(_ categoryEntity: CategoryCollectionEntity) {
        categoryBtn.setImage(UIImage(systemName: categoryEntity.image), for: .normal)
    }
    
    @IBAction func onCategoryBtnTap() {
        self.delegate?.onCategorySelected(index: index)
    }
}
