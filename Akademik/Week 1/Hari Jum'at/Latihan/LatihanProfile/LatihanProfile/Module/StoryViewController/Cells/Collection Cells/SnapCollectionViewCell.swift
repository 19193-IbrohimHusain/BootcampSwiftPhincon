import UIKit

class SnapCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var snapImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        snapImage.layer.cornerRadius = 31
    }
    
    func configureCollection(with snapEntity: SnapCollectionEntity) {
        snapImage.image = UIImage(named: snapEntity.uploadedImage)
        username.text = snapEntity.username
    }
}
