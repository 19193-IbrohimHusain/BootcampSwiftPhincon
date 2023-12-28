import UIKit
import Kingfisher

class StoryCollectionCell: UICollectionViewCell {
    // MARK: - Variables
    @IBOutlet private weak var storyImage: UIImageView!
    @IBOutlet private weak var username: UILabel!
    
    // MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: - Functions
    private func setup() {
        storyImage.layer.cornerRadius = storyImage.bounds.width / 2
    }
    
    internal func configureCollection(with storyEntity: ListStory) {
        let url = URL(string: storyEntity.photoURL)
        let size = storyImage.intrinsicContentSize
        let processor = DownsamplingImageProcessor(size: size)
        storyImage.kf.setImage(with: url, options: [
            .processor(processor),
            .loadDiskFileSynchronously,
            .cacheOriginalImage,
            .transition(.fade(0.25)),
        ])
        username.text = storyEntity.name
    }
}
