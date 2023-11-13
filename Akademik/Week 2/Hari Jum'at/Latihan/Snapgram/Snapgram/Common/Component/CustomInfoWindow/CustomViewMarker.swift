import UIKit
import Kingfisher

class CustomViewMarker: UIView {
    let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    let dateFormatter = DateFormatter()
    
    // UI Elements
    let imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Blank") // Replace with the actual image name
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let username: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont(name: "Helvetica", size: 14) // Use the actual font and size
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont(name: "Helvetica", size: 12) // Use the actual font and size
        label.textColor = UIColor.systemGray // Use the appropriate color
        return label
    }()
    
    let uploadedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Kyoto") // Replace with the actual image name
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 4
        label.textAlignment = .left
        label.font = UIFont(name: "Helvetica", size: 12) // Use the actual font and size
        return label
    }()
    
    let timeCreated: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont(name: "Helvetica", size: 10) // Use the actual font and size
        label.textColor = UIColor.systemGray // Use the appropriate color
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // Setup view and constraints
    private func setupView() {
        addSubview(imgView)
        addSubview(username)
        addSubview(locationLabel)
        addSubview(uploadedImage)
        addSubview(captionLabel)
        addSubview(timeCreated)
        addShadow()
        addBorderLine()
        
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            imgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            imgView.widthAnchor.constraint(equalToConstant: 24),
            imgView.heightAnchor.constraint(equalToConstant: 24),
            
            username.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            username.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 8),
            username.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            username.heightAnchor.constraint(equalToConstant: 14),
            
            locationLabel.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 6),
            locationLabel.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 8),
            locationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            locationLabel.heightAnchor.constraint(equalToConstant: 28),
            
            uploadedImage.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 4),
            uploadedImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            uploadedImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            uploadedImage.widthAnchor.constraint(equalTo: widthAnchor),
            uploadedImage.heightAnchor.constraint(equalToConstant: 150),
            
            captionLabel.topAnchor.constraint(equalTo: uploadedImage.bottomAnchor, constant: 8),
            captionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            captionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            captionLabel.heightAnchor.constraint(equalToConstant: 40),
            
            timeCreated.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 8),
            timeCreated.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            timeCreated.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8)
        ])
    }
    
    func configure(name: String?, location: String?, image: String?, caption: String?, createdAt: String?) {
        if let name = name, let location = location, let image = image, let caption = caption, let createdAt = createdAt {
            username.text = "Story By \(name)"
            locationLabel.text = location
            let url = URL(string: image)
            uploadedImage.kf.setImage(with: url)
            captionLabel.text = caption
            dateFormatter.dateFormat = dateFormat
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            if let date = dateFormatter.date(from: createdAt) {
                let timeAgo = date.convertDateToTimeAgo()
                timeCreated.text = timeAgo
                print(timeAgo)
            } else {
                print("Failed to parse date.")
            }
        }
    }
}
