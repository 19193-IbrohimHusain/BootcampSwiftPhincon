import UIKit
import Kingfisher

protocol StoryTableCellDelegate {
    func addLike(index: Int, isLike: Bool)
}

class StoryTableCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    
    var delegate: StoryTableCellDelegate?
    var indexSelected: Int = Int()
    let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    let dateFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        profileImage.layer.cornerRadius = 18
        likeButton.isSelected = false
    }
    
    func configure(with storyEntity: ListStory) {
        profileImage.image = UIImage(named: "Blank")
        location.text = "Karawang, Indonesia"
        username.text = storyEntity.name
        let url = URL(string: storyEntity.photoURL)
        uploadedImage.kf.setImage(with: url)
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
            let timeAgo = date.timeAgoString()
            createdAt.text = timeAgo
            print(timeAgo)
        } else {
            print("Failed to parse date.")
        }
    }
    
    @IBAction func onLikeBtnTap(_ sender: Any) {
        likeButton.isSelected.toggle()
        if likeButton.isSelected {
            self.delegate?.addLike(index: indexSelected , isLike: likeButton.isSelected)
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
            likeButton.tintColor = UIColor.systemRed
        } else {
            self.delegate?.addLike(index: indexSelected, isLike: false)
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButton.tintColor = UIColor.label
        }
    }
}

extension Date {
    func timeAgoString() -> String {
        let now = Date()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.hour, .minute, .second], from: self, to: now)
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 1
        
        if let timeAgoString = formatter.string(from: components) {
            return timeAgoString + " ago"
        } else {
            return "Just now"
        }
    }
}
