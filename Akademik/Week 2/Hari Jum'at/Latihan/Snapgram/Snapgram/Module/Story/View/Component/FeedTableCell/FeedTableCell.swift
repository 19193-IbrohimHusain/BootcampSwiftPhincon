import UIKit
import Kingfisher
import GoogleMaps

protocol FeedTableCellDelegate {
    func getLocationName(lat: Double?, lon: Double?, completion: ((String) -> Void)?)
    func addLike(cell: FeedTableCell)
    func openComment(index: Int)
}

class FeedTableCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var likePopUp: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    
    var delegate: FeedTableCellDelegate?
    let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    let dateFormatter = DateFormatter()
    var indexSelected = Int()
    var post: ListStory? {
        didSet {
            configure()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() {
        self.selectionStyle = .none
        profileImage.layer.cornerRadius = 15
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onImageDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        uploadedImage.isUserInteractionEnabled = true
        uploadedImage.addGestureRecognizer(doubleTapGesture)
        commentCount.isUserInteractionEnabled = true
        commentCount.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentLabelTap(_:))))
        likeButton.isSelected = false
        likeButton.setAnimateBounce()
        commentBtn.setAnimateBounce()
        shareBtn.setAnimateBounce()
    }
    
    func configure() {
        guard let post = post else { return }
        profileImage.image = UIImage(named: "Blank")
        username.text = post.name
        let url = URL(string: post.photoURL)
        let processor = DownsamplingImageProcessor(size: CGSize(width: 320, height: 320))
        uploadedImage.kf.setImage(with: url, options: [
            .processor(processor),
            .loadDiskFileSynchronously,
            .cacheOriginalImage,
            .transition(.fade(0.25)),
        ])
        likeButton.setImage(post.isLiked == true ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = post.isLiked == true ? .systemRed : .label
        likeCount.text = "\(post.likesCount) Likes"
        let attributedString = NSAttributedString(string: "\(post.name)  \(post.description)")
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
        let range = NSRange(location: 0, length: post.name.count)
        let attributedText = attributedString.applyingAttributes(attributes, toRange: range)
        caption.attributedText = attributedText
        commentCount.text = "\(post.commentsCount) comments"
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = dateFormatter.date(from: post.createdAt) {
            let timeAgo = date.convertDateToTimeAgo()
            createdAt.text = timeAgo
        }
        guard post.lat == nil && post.lon == nil else {
            DispatchQueue.main.async {
                self.delegate?.getLocationName(lat: post.lat, lon: post.lon) { locationName in
                    let attributedString = NSAttributedString(string: "\(post.name)\n\(locationName)")
                    let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)]
                    let range = NSRange(location: post.name.count + 1, length: locationName.count)
                    let attributedText = attributedString.applyingAttributes(attributes, toRange: range)
                    self.username.attributedText = attributedText
                }
            }
            return
        }
    }
    
    @objc func onImageDoubleTap(_ sender: UITapGestureRecognizer) {
        guard self.likePopUp.isHidden == true else { return }
        self.likePopUp.addShadow()
        self.displayPopUp()
    }
    
    func displayPopUp() {
        self.likePopUp.isHidden = false
        UIView.animate(withDuration: 0.8, delay: 0.0 , usingSpringWithDamping: 0.4, initialSpringVelocity: 0.4, options: [.curveEaseInOut], animations: {
            self.likePopUp.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { _ in
            if self.post?.isLiked == false {
                self.delegate?.addLike(cell: self)
            }
            UIView.animate(withDuration: 0.1, delay: 0.2, options: [.curveEaseInOut], animations: {
                self.likePopUp.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            }, completion: { _ in
                self.likePopUp.isHidden = true
            })
        })
    }
    
    @IBAction func onLikeBtnTap(_ sender: UIButton) {
        self.delegate?.addLike(cell: self)
    }
    
    @IBAction func onCommentBtnTap(_ sender: UIButton) {
        self.delegate?.openComment(index: indexSelected)
    }
    
    @objc func onCommentLabelTap(_ sender: UITapGestureRecognizer) {
        self.delegate?.openComment(index: indexSelected)
    }
}
