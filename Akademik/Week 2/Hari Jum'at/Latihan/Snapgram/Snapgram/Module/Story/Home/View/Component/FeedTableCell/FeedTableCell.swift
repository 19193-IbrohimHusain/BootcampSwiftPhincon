import UIKit
import Kingfisher
import RxSwift
import RxGesture
import GoogleMaps

protocol FeedTableCellDelegate: AnyObject {
    func getLocationName(lat: Double?, lon: Double?, completion: @escaping ((String) -> Void))
    func addLike(cell: FeedTableCell)
    func openComment(index: Int)
    func navigateToDetailUser(user: ListStory)
}

class FeedTableCell: UITableViewCell {
    // MARK: - Variables
    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet private weak var username: UILabel!
    @IBOutlet private weak var uploadedImage: UIImageView!
    @IBOutlet private weak var likePopUp: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var commentBtn: UIButton!
    @IBOutlet private weak var shareBtn: UIButton!
    @IBOutlet private weak var likeCount: UILabel!
    @IBOutlet private weak var caption: UILabel!
    @IBOutlet private weak var commentCount: UILabel!
    @IBOutlet private weak var createdAt: UILabel!
    
    internal weak var delegate: FeedTableCellDelegate?
    internal var indexSelected = 0
    private var bag = DisposeBag()
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }
    internal var post: ListStory? {
        didSet {
            configure()
        }
    }
    
    // MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    // MARK: - Functions
    private func setup() {
        selectionStyle = .none
        profileImage.layer.cornerRadius = 15
        likeButton.isSelected = false
        [likeButton, commentBtn, shareBtn].forEach { $0?.setAnimateBounce() }
        btnEvent()
    }
    
    private func btnEvent() {
        likeButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.addLike(cell: self)
        }).disposed(by: bag)
        
        commentBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.openComment(index: self.indexSelected)
        }).disposed(by: bag)
        
        uploadedImage.rx.tapGesture(configuration: { (gesture, _) in
            gesture.numberOfTapsRequired = 2
        }).when(.recognized).subscribe(onNext: { [weak self] _ in
            guard let self = self, self.likePopUp.isHidden == true else { return }
            self.likePopUp.addShadow()
            self.displayPopUp()
        }).disposed(by: bag)
        
        profileImage.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            guard let self = self, let post = self.post else { return }
            self.delegate?.navigateToDetailUser(user: post)
        }).disposed(by: bag)
        
        username.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            guard let self = self, let post = self.post else { return }
            self.delegate?.navigateToDetailUser(user: post)
        }).disposed(by: bag)
        
        commentCount.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.openComment(index: self.indexSelected)
        }).disposed(by: bag)
    }
    
    private func configure() {
        guard let post = post else { return }
        profileImage.image = UIImage(named: "Blank")
        username.text = post.name
        setupUploadedImage(post)
        setupLikeButton(post)
        setupCaption(post)
        commentCount.text = "\(post.commentsCount) comments"
        setupCreatedAt(post)
        setupLocation(post)
    }
    
    private func setupUploadedImage(_ post: ListStory) {
        let url = URL(string: post.photoURL)
        let size = uploadedImage.intrinsicContentSize
        let processor = DownsamplingImageProcessor(size: size)
        uploadedImage.kf.setImage(with: url, options: [
            .processor(processor),
            .loadDiskFileSynchronously,
            .cacheOriginalImage,
            .transition(.none),
        ])
    }
    
    private func setupLikeButton(_ post: ListStory) {
        likeButton.setImage(post.isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = post.isLiked ? .systemRed : .label
        likeCount.text = "\(post.likesCount) Likes"
    }
    
    private func setupCaption(_ post: ListStory) {
        let attributedString = NSAttributedString(string: "\(post.name)  \(post.description)")
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
        let range = NSRange(location: 0, length: post.name.count)
        caption.attributedText = attributedString.applyingAttributes(attributes, toRange: range)
    }
    
    private func setupCreatedAt(_ post: ListStory) {
        if let date = dateFormatter.date(from: post.createdAt) {
            let timeAgo = date.convertDateToTimeAgo()
            createdAt.text = timeAgo
        }
    }
    
    private func setupLocation(_ post: ListStory) {
        guard post.lat != nil, post.lon != nil else {return}
        delegate?.getLocationName(lat: post.lat, lon: post.lon) { locationName in
            let attributedString = NSAttributedString(string: "\(post.name)\n\(locationName)")
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)]
            let range = NSRange(location: post.name.count + 1, length: locationName.count)
            let attributedText = attributedString.applyingAttributes(attributes, toRange: range)
            self.username.attributedText = attributedText
        }
    }
    
    private func displayPopUp() {
        likePopUp.isHidden = false
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
}
