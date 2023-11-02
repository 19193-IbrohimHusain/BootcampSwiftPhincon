import UIKit

class PopularCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterPopular: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterPopular.layer.cornerRadius = 16
    }
}
