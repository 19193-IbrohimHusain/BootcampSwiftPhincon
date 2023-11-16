import UIKit
import Kingfisher
import GoogleMaps

protocol StoryTableCellDelegate {
    func addLike(index: Int, isLike: Bool)
}

class StoryTableCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
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
        self.selectionStyle = .none
        profileImage.layer.cornerRadius = 18
        likeButton.isSelected = false
    }
    
    func configure(with storyEntity: ListStory) {
        profileImage.image = UIImage(named: "Blank")
        location.isHidden = true
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
            getLocationNameFromCoordinates(latitude: storyEntity.lat, longitude: storyEntity.lon) { name in
                if let locationName = name {
                    self.location.isHidden = false
                    self.location.text = locationName
                }
            }
            return location.isHidden = true
        }
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
    
    func getLocationNameFromCoordinates(latitude: Double?, longitude: Double?, completion: @escaping (String?) -> Void) {
        guard let lat = latitude, let lon = longitude else {
            completion(nil)
            return
        }
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard error == nil, let result = response?.results() else {
                print("Geocoding error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            result.forEach { data in
                guard let city = data.locality, let country = data.country else { return }
                let name = "\(city), \(country)"
                completion(name)
            }
        }
    }
}
