import UIKit

protocol StoryTableCellDelegate {
    func addLike(index: Int, isLike: Bool)
}

class StoryTableCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    
    var delegate: StoryTableCellDelegate?
    var indexSelected: Int = Int()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        profileImage.layer.cornerRadius = 18
        likeButton.isSelected = false
    }
    
    func configure(with storyEntity: ListStory) {
        profileImage.image = UIImage(named: storyEntity.photoURL)
        username.text = storyEntity.name
        uploadedImage.image = UIImage(named: storyEntity.photoURL)
        likeCount.text = "120 Likes"
        caption.text = storyEntity.description
        commentCount.text = "120 comments"
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
