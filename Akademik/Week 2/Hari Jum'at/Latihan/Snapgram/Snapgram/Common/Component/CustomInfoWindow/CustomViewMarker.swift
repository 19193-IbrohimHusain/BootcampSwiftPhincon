import UIKit
import Kingfisher
import RxSwift
import RxCocoa

protocol CustomViewMarkerDelegate {
    func navigateTo(id: String)
}

class CustomViewMarker: UIView {
    let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    let dateFormatter = DateFormatter()
    var delegate: CustomViewMarkerDelegate?
    private let bag = DisposeBag()
    var storyID = String()
    
    // UI Elements
    let imgView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let username: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont(name: "Helvetica", size: 14)
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont(name: "Helvetica", size: 12)
        label.textColor = UIColor.systemGray
        return label
    }()
    
    let uploadedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 4
        label.textAlignment = .left
        label.font = UIFont(name: "Helvetica", size: 12)
        return label
    }()
    
    let timeCreated: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = UIFont(name: "Helvetica", size: 10)
        label.textColor = UIColor.systemGray
        return label
    }()
    
    let navigationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("", for: .normal)
        return button
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        navigateToDetail()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func navigateToDetail() {
        navigationButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.delegate?.navigateTo(id: self.storyID)
        }).disposed(by:bag)
    }
    
    // Setup view and constraints
    private func setupView() {
        addSubview(imgView)
        addSubview(username)
        addSubview(locationLabel)
        addSubview(uploadedImage)
        addSubview(captionLabel)
        addSubview(timeCreated)
        addSubview(navigationButton)
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
            locationLabel.heightAnchor.constraint(equalToConstant: 12),
            
            uploadedImage.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 4),
            uploadedImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            uploadedImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            uploadedImage.widthAnchor.constraint(equalTo: widthAnchor),
            uploadedImage.heightAnchor.constraint(equalToConstant: 150),
            
            captionLabel.topAnchor.constraint(equalTo: uploadedImage.bottomAnchor, constant: 8),
            captionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            captionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            captionLabel.heightAnchor.constraint(equalToConstant: 30),
            
            navigationButton.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            navigationButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            navigationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            navigationButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            timeCreated.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 8),
            timeCreated.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            timeCreated.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            timeCreated.heightAnchor.constraint(equalToConstant: 14),
        ])
    }
    
    func configure(name: String?, location: String?, image: String?, caption: String?, createdAt: String?) {
        if let name = name, let location = location, let image = image, let caption = caption, let createdAt = createdAt {
            imgView.image = UIImage(named: "Blank")
            username.text = "Story By \(name)"
            locationLabel.text = location
            let url = URL(string: image)
            let processor = DownsamplingImageProcessor(size: CGSize(width: 200, height: 120))
            uploadedImage.kf.setImage(with: url, options: [
                .processor(processor),
                .loadDiskFileSynchronously,
                .cacheOriginalImage,
                .transition(.fade(0.25)),
            ])
            captionLabel.text = caption
            dateFormatter.dateFormat = dateFormat
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            if let date = dateFormatter.date(from: createdAt) {
                let timeAgo = date.convertDateToTimeAgo()
                timeCreated.text = timeAgo
            }
        }
    }
}
