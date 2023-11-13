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
        location.text = "Karawang, Indonesia"
        username.text = storyEntity.name
        let url = URL(string: storyEntity.photoURL)
        uploadedImage.kf.setImage(with: url)
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
            print(timeAgo)
        } else {
            print("Failed to parse date.")
        }
    }
    
    func getLocationNameFromCoordinates(with storyEntity: ListStory, latitude: Double, longitude: Double) {
        //        if storyEntity.lat && storyEntity.lon != null {
        //            let coordinate = CLLocationCoordinate2D(latitude: storyEntity.lat, longitude: storyEntity.lon)
        //        }
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            
            if let result = response?.firstResult() {
                // You can access various address components to get the location name
                let lines = result.lines
                let name = lines?.joined(separator: " ")
                
                print("Location Name: \(name ?? "N/A")")
            } else {
                print("Location not found")
            }
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
}
