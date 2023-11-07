import UIKit
import Kingfisher

class SnapCollectionCell: UICollectionViewCell {

    @IBOutlet weak var snapImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        snapImage.layer.cornerRadius = 25
    }
    
    func configureCollection(with snapEntity: ListStory) {
        let url = URL(string: snapEntity.photoURL)
        snapImage.kf.setImage(with: url)
        username.text = snapEntity.name
    }
}
