import UIKit

protocol StoryTableCellDelegate {
    func addLike(index: Int, isLike: Bool)
}

class StoryTableCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    
    var delegate: StoryTableCellDelegate?
    var indexSelected: Int = Int()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        profileImage.layer.cornerRadius = 18
        likeBtn.isSelected = false
    }
    
    func configure(with storyEntity: StoryTableEntity) {
        profileImage.image = UIImage(named: storyEntity.profileImage)
        username.text = storyEntity.username
        uploadedImage.image = UIImage(named: storyEntity.uploadedImage)
        likeCount.text = "\(storyEntity.likesCount) Likes"
        caption.text = storyEntity.caption
        commentCount.text = "\(storyEntity.commentsCount) comments"
    }
    
    @IBAction func onLikeBtnTap(_ sender: Any) {
        likeBtn.isSelected.toggle()
        if likeBtn.isSelected {
            self.delegate?.addLike(index: indexSelected , isLike: likeBtn.isSelected)
            likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .selected)
            likeBtn.backgroundColor = UIColor.systemRed
        } else {
            self.delegate?.addLike(index: indexSelected, isLike: false)
            likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            likeBtn.backgroundColor = UIColor.label
        }
    }
}
