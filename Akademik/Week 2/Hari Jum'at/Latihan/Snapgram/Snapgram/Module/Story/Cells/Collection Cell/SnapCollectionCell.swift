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
        let processor = DownsamplingImageProcessor(size: CGSize(width: 320, height: 320))
        snapImage.kf.setImage(with: url, options: [
            .processor(processor),
            .loadDiskFileSynchronously,
            .cacheOriginalImage,
            .transition(.fade(0.25)),
        ])
        username.text = snapEntity.name
    }
}
