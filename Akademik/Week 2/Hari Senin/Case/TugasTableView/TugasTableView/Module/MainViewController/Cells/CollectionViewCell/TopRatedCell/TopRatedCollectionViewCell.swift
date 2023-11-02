import UIKit

class TopRatedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterTopRated: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterTopRated.layer.cornerRadius = 16
    }
}
