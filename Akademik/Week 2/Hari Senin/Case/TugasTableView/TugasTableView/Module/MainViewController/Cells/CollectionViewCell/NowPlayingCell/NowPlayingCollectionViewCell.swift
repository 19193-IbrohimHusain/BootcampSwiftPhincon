import UIKit

class NowPlayingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var posterNowPlaying: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterNowPlaying.layer.cornerRadius = 16
    }
}
