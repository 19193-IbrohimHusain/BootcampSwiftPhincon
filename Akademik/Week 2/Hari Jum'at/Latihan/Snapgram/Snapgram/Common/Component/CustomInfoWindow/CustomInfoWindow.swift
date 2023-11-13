import UIKit
import Kingfisher

@IBDesignable
class CustomInfoWindow: UIView {
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    
    let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    let dateFormatter = DateFormatter()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    
    private func configureView() {
        let view = self.loadNib()
        view.frame = self.bounds
        view.backgroundColor = .white
        self.addSubview(view)
    }
    
    func configure(name: String?, location: String?, image: String?, caption: String?, createdAt: String?) {
        if let name = name, let location = location, let image = image, let caption = caption, let createdAt = createdAt {
            self.username.text = name
            self.location.text = location
            let url = URL(string: image )
            self.uploadedImage.kf.setImage(with: url)
            self.caption.text = caption
            dateFormatter.dateFormat = dateFormat
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            if let date = dateFormatter.date(from: createdAt) {
                let timeAgo = date.convertDateToTimeAgo()
                self.createdAt.text = timeAgo
                print(timeAgo)
            } else {
                print("Failed to parse date.")
            }
        }
    }
}
