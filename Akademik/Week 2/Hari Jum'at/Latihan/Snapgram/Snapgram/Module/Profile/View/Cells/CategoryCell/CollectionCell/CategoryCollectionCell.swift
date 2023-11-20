import UIKit

protocol CategoryCollectionCellDelegate {
    func onCategorySelected()
}

class CategoryCollectionCell: UICollectionViewCell {

    @IBOutlet weak var categoryBtn: UIButton!
    
    var delegate: CategoryCollectionCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCollection(_ categoryEntity: CategoryCollectionEntity) {
        categoryBtn.setImage(UIImage(systemName: categoryEntity.image), for: .normal)
    }
    
    @IBAction func onCategoryBtnTap() {
        self.delegate?.onCategorySelected()
    }
}
