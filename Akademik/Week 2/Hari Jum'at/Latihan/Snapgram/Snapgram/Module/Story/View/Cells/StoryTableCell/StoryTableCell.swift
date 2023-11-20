import UIKit
import Kingfisher
import GoogleMaps

protocol StoryTableCellDelegate {
    func getLocationName(lat: Double?, lon: Double?, completion: ((String) -> Void)?)
    func addLike(index: Int, isLike: Bool)
    func openComment(index: Int)
}

class StoryTableCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    
    var delegate: StoryTableCellDelegate?
    var indexSelected: Int = Int()
    let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    let dateFormatter = DateFormatter()
    let geocoder = GMSGeocoder()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        self.selectionStyle = .none
        profileImage.layer.cornerRadius = 18
        commentCount.isUserInteractionEnabled = true
        commentCount.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentLabelTap(_:))))
        likeButton.isSelected = false
        likeButton.setAnimateBounce()
        commentBtn.setAnimateBounce()
        shareBtn.setAnimateBounce()
    }
    
    func configure(with storyEntity: ListStory) {
        profileImage.image = UIImage(named: "Blank")
        location.isHidden = true
        username.text = storyEntity.name
        let url = URL(string: storyEntity.photoURL)
        let processor = DownsamplingImageProcessor(size: CGSize(width: 320, height: 320))
        uploadedImage.kf.setImage(with: url, options: [
            .processor(processor),
            .loadDiskFileSynchronously,
            .cacheOriginalImage,
            .transition(.fade(0.25)),
        ])
        likeCount.text = "\(storyEntity.likesCount) Likes"
        let attributedString = NSAttributedString(string: "\(storyEntity.name)  \(storyEntity.description)")
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
        let range = NSRange(location: 0, length: storyEntity.name.count)
        let attributedText = attributedString.applyingAttributes(attributes, toRange: range)
        caption.attributedText = attributedText
        commentCount.text = "\(storyEntity.commentsCount) comments"
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = dateFormatter.date(from: storyEntity.createdAt) {
            let timeAgo = date.convertDateToTimeAgo()
            createdAt.text = timeAgo
        }
        guard storyEntity.lat == nil && storyEntity.lon == nil else {
            self.delegate?.getLocationName(lat: storyEntity.lat, lon: storyEntity.lon) { locationName in
                    self.location.isHidden = false
                    self.location.text = locationName
            }
            return location.isHidden = true
        }
    }
    
    @IBAction func onLikeBtnTap(_ sender: UIButton) {
        likeButton.isSelected.toggle()
        if likeButton.isSelected {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
            likeButton.tintColor = UIColor.systemRed
            guard sender.tag == indexSelected else {
                return
            }
            self.delegate?.addLike(index: sender.tag , isLike: true)
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tintColor = UIColor.label
            guard sender.tag == indexSelected else {
                return
            }
            self.delegate?.addLike(index: sender.tag, isLike: false)
        }
    }
    
    @IBAction func onCommentBtnTap(_ sender: UIButton) {
        self.delegate?.openComment(index: sender.tag)
    }
    
    @objc func onCommentLabelTap(_ sender: UITapGestureRecognizer) {
        self.delegate?.openComment(index: indexSelected)
    }
}
