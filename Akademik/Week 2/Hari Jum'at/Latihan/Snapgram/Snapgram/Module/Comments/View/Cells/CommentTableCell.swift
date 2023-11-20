import UIKit

protocol CommentTableCellDelegate {
    func addLike(index: Int, isLike: Bool)
    func reply()
}
class CommentTableCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var replyBtn: UIButton!
    @IBOutlet weak var translateBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var likeStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    func setup() {
        profileImg.layer.cornerRadius = 12
    }
    
    func configure() {
        username.text = ""
        comment.text = ""
        likeCount.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
