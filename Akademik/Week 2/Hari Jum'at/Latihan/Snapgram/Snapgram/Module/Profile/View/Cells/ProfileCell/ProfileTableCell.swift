import UIKit

protocol ProfileTableCellDelegate {
    func editProfile()
    func shareProfile()
    func discover()
}

class ProfileTableCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var postStack: UIStackView!
    @IBOutlet weak var followersStack: UIStackView!
    @IBOutlet weak var followingStack: UIStackView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var bio: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var shareProfileBtn: UIButton!
    @IBOutlet weak var discoverBtn: UIButton!
    
    var delegate: ProfileTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    func configure() {
        profileImg.layer.cornerRadius = 50.0
        configureBtn(editProfileBtn)
        configureBtn(shareProfileBtn)
        configureBtn(discoverBtn)
    }
    
    func configureBtn(_ button: UIButton) {
        button.setAnimateBounce()
        button.layer.cornerRadius = 8.0
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowRadius = 3.0
        button.layer.shadowOpacity = 0.5
    }
    
    
    @IBAction func onEditProfileBtnTap() {
        self.delegate?.editProfile()
    }
    
    @IBAction func onShareProfileBtnTap() {
        self.delegate?.shareProfile()
    }
    
    @IBAction func onDiscoverBtnTap() {
        self.delegate?.discover()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
