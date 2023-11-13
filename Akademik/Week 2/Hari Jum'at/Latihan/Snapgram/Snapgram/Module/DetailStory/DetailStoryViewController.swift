import UIKit
import Kingfisher
import RxSwift


class DetailStoryViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    
    var storyID: String?
    var detailStory: DetailStoryResponse?
    let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    let dateFormatter = DateFormatter()
    let vm = DetailStoryViewModel()
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        profileImage.layer.cornerRadius = 18
        if let storyID = storyID {
            vm.fetchDetailStory(param: storyID)
        }
        configure()
        bindData()
        
    }
    
    func configure() {
        if let validDetail = detailStory?.story {
            username.text = validDetail.name
            location.text = "Karawang, Indonesia"
            let url = URL(string: validDetail.photoURL)
            uploadedImage.kf.setImage(with: url)
            likesCount.text = "12930 Likes"
            likeBtn.isSelected = false
            let attributedString = NSAttributedString(string: "\(validDetail.name)  \(validDetail.description)")
            let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
            let range = NSRange(location: 0, length: validDetail.name.count)
            let attributedText = attributedString.applyingAttributes(attributes, toRange: range)
            caption.attributedText = attributedText
            commentsCount.text = "10938 comments"
            dateFormatter.dateFormat = dateFormat
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            if let date = dateFormatter.date(from: validDetail.createdAt) {
                let timeAgo = date.convertDateToTimeAgo()
                createdAt.text = timeAgo
                print(timeAgo)
            } else {
                print("Failed to parse date.")
            }
        }
       
    }
    
    func bindData() {
        vm.detailStoryData.asObservable().subscribe(onNext: {[weak self] data in
            guard let self = self else { return }
            self.detailStory = data
            DispatchQueue.main.async {
                self.configure()
                self.view.setNeedsLayout()
            }
        }).disposed(by: bag)
    }

}
