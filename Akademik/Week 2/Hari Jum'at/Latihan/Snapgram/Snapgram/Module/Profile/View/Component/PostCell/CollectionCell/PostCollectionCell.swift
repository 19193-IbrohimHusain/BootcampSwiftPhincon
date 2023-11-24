import UIKit

class PostCollectionCell: UICollectionViewCell {

    @IBOutlet weak var postImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCollection(_ postEntity: PostCollectionEntity) {
        postImage.image = UIImage(named: postEntity.image)
    }

}
