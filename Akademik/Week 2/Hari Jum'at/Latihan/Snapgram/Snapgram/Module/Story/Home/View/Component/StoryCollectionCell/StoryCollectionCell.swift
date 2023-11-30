import UIKit
import Kingfisher

class StoryCollectionCell: UICollectionViewCell {

    @IBOutlet private weak var storyImage: UIImageView!
    @IBOutlet private weak var username: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        storyImage.layer.cornerRadius = 25
    }
    
   internal func configureCollection(with storyEntity: ListStory) {
        let url = URL(string: storyEntity.photoURL)
        let processor = DownsamplingImageProcessor(size: CGSize(width: 320, height: 320))
        storyImage.kf.setImage(with: url, options: [
            .processor(processor),
            .loadDiskFileSynchronously,
            .cacheOriginalImage,
            .transition(.fade(0.25)),
        ])
        username.text = storyEntity.name
    }
}