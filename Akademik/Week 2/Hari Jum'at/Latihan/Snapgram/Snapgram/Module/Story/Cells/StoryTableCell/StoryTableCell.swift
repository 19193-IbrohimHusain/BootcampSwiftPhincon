import UIKit

protocol StoryTableCellDelegate {
    func addLike(index: Int, isLike: Bool)
}

class StoryTableCell: UITableViewCell {
    
    @IBOutlet weak var profileView: UIImageView!
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
        profileView.layer.cornerRadius = 12
        likeButton.isSelected = false
    }
    
    func configure(with storyEntity: StoryTableEntity) {
        profileView.image = UIImage(named: storyEntity.profileImage)
        username.text = storyEntity.username
        uploadedImage.image = UIImage(named: storyEntity.uploadedImage)
        likeCount.text = "\(storyEntity.likesCount) Likes"
        caption.text = storyEntity.caption
        commentCount.text = "\(storyEntity.commentsCount) comments"
        
    }
    
    @IBAction func onLikeBtnTap(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            self.delegate?.addLike(index: indexSelected , isLike: sender.isSelected)
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
            sender.tintColor = UIColor.systemRed
        } else {
            self.delegate?.addLike(index: indexSelected, isLike: false)
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            sender.tintColor = UIColor.label
        }
    }
}
