import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import RxGesture


class DetailStoryViewController: BaseBottomSheetController {
    // MARK: - Variables
    @IBOutlet private weak var bgView: UIView!
    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet internal weak var username: UILabel!
    @IBOutlet internal weak var uploadedImage: UIImageView!
    @IBOutlet private weak var likePopUp: UIImageView!
    @IBOutlet internal weak var likeBtn: UIButton!
    @IBOutlet private weak var commentBtn: UIButton!
    @IBOutlet private weak var shareBtn: UIButton!
    @IBOutlet internal weak var caption: UILabel!
    @IBOutlet internal weak var likesCount: UILabel!
    @IBOutlet internal weak var commentsCount: UILabel!
    @IBOutlet internal weak var createdAt: UILabel!
    
    private let vm = DetailStoryViewModel()
    internal var storyID: String?
    
    internal var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }
    
    internal var detailStory: Story? {
        didSet {
            DispatchQueue.main.async {
                self.configureUI()
            }
        }
    }
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let storyID = storyID {
            vm.fetchDetailStory(param: storyID)
        }
    }
    
    // MARK: - Functions
    private func setupUI() {
        profileImage.layer.cornerRadius = 18
        [likeBtn, commentBtn, shareBtn].forEach { $0?.setAnimateBounce() }
        setupBottomSheet(contentVC: cvc, floatingPanelDelegate: self)
        btnEvent()
        bindData()
    }
    
    private func btnEvent() {
        likeBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.addLike()
        }).disposed(by: bag)
        
        commentBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.present(self.floatingPanel, animated: true)
        }).disposed(by: bag)
        
        uploadedImage.rx.tapGesture(configuration: { (gesture, _) in
            gesture.numberOfTapsRequired = 2
        }).when(.recognized).subscribe(onNext: { [weak self] _ in
            guard let self = self, self.likePopUp.isHidden == true else { return }
            self.likePopUp.addShadow()
            self.displayPopUp()
        }).disposed(by: bag)
        
        commentsCount.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.present(self.floatingPanel, animated: true)
        }).disposed(by: bag)
    }
    
    private func bindData() {
        vm.detailStoryData.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self else { return }
            self.detailStory = data?.story
        }).disposed(by: bag)
        
        vm.loadingState.asObservable().subscribe(onNext: { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .notLoad, .loading:
                self.bgView.showAnimatedGradientSkeleton()
            case .failed, .finished:
                DispatchQueue.main.async {
                    self.bgView.hideSkeleton()
                }
            }
        }).disposed(by: bag)
    }
    
    private func displayPopUp() {
        self.likePopUp.isHidden = false
        if detailStory?.isLiked == false {
            self.addLike()
        }
        UIView.animate(withDuration: 0.8, delay: 0.0 , usingSpringWithDamping: 0.4, initialSpringVelocity: 0.4, options: [.curveEaseInOut], animations: {
            self.likePopUp.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, delay: 0.2, options: [.curveEaseInOut], animations: {
                self.likePopUp.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            }, completion: { _ in
                self.likePopUp.isHidden = true
            })
        })
    }
    
    private func addLike() {
        var post = detailStory
        if post!.isLiked {
            post?.isLiked = false
            post?.likesCount -= 1
            self.detailStory? = post!
        } else {
            post?.isLiked = true
            post?.likesCount += 1
            self.detailStory? = post!
        }
    }
}
