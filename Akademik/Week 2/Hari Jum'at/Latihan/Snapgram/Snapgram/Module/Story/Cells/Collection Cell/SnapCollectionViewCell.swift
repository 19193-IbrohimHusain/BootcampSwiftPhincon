import UIKit

class SnapCollectionViewCell: UICollectionViewCell {

    @IBOutlet var snapImage: UIImageView!
    @IBOutlet var username: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        snapImage.layer.cornerRadius = 31
    }
    
    func configureCollection(with snapEntity: SnapCollectionEntity) {
        snapImage.image = UIImage(named: snapEntity.uploadedImage)
        username.text = snapEntity.username
    }
}
