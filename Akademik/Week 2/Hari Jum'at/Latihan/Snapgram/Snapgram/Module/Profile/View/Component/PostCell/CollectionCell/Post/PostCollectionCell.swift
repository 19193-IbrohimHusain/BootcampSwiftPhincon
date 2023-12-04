import UIKit
import Kingfisher

class PostCollectionCell: UICollectionViewCell {

    @IBOutlet weak var postImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCollection(_ post: ListStory) {
        let url = URL(string: post.photoURL)
        let processor = DownsamplingImageProcessor(size: CGSize(width: 150, height: 150))
        postImage.kf.setImage(with: url, options: [
            .processor(processor),
            .loadDiskFileSynchronously,
            .cacheOriginalImage,
            .transition(.fade(0.25)),
        ])
    }

}
