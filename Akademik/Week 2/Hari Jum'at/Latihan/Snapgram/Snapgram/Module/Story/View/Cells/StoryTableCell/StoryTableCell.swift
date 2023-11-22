import UIKit
import Kingfisher
import GoogleMaps

protocol StoryTableCellDelegate {
    func getLocationName(lat: Double?, lon: Double?, completion: ((String) -> Void)?)
    func addLike(index: Int, isLike: Bool, completion: @escaping () -> Void)
    func openComment(index: Int)
}

class StoryTableCell: UITableViewCell {
    
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
        self.likePopUp.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)

    }
    
    func configure(with storyEntity: ListStory) {
        profileImage.image = UIImage(named: "Blank")
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
            DispatchQueue.main.async {
                self.delegate?.getLocationName(lat: storyEntity.lat, lon: storyEntity.lon) { locationName in
                    let attributedString = NSAttributedString(string: "\(storyEntity.name)\n\(locationName)")
                    let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)]
                    let range = NSRange(location: storyEntity.name.count + 1, length: locationName.count)
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
        self.likeButton.tag = self.indexSelected
        self.likeButton.isSelected = true
        self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        self.likeButton.tintColor = .systemRed
        self.displayPopUp()
    }
    
    func displayPopUp() {
        self.likePopUp.isHidden = false
        UIView.animate(withDuration: 0.8, delay: 0.0 , usingSpringWithDamping: 0.4, initialSpringVelocity: 0.4, options: [.curveEaseInOut], animations: {
            self.likePopUp.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { _ in
            self.delegate?.addLike(index: self.indexSelected, isLike: true) {
                print("menambahkan like index ke \(self.indexSelected)")
            }
            UIView.animate(withDuration: 0.1, delay: 0.2, options: [.curveEaseInOut], animations: {
                self.likePopUp.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            }, completion: { _ in
                self.likePopUp.isHidden = true
            })
        })
    }
    
    @IBAction func onLikeBtnTap(_ sender: UIButton) {
        self.likeButton.isSelected.toggle()
        self.likeButton.isSelected ? self.delegate?.addLike(index: self.indexSelected, isLike: true) {
            self.likeButton.tag = self.indexSelected
            self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
            self.likeButton.tintColor = UIColor.systemRed
        } : self.delegate?.addLike(index: self.indexSelected, isLike: false) {
            self.likeButton.tag = self.indexSelected
            self.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            self.likeButton.tintColor = UIColor.label
        }
        
    }
    
    @IBAction func onCommentBtnTap(_ sender: UIButton) {
        self.delegate?.openComment(index: indexSelected)
    }
    
    @objc func onCommentLabelTap(_ sender: UITapGestureRecognizer) {
        self.delegate?.openComment(index: indexSelected)
    }
}
