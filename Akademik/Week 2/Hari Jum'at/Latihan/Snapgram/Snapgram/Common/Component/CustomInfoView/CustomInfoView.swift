import UIKit
import Kingfisher

class CustomInfoView: UIView {
    
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    // MARK: - Functions
    private func configureView() {
        let view = self.loadNib()
        view.frame = self.bounds
        view.backgroundColor = .white
//        view.addGestureRecognizer()
        self.addSubview(view)
    }
    
    func setup(name: String, location: String, captions: String, created: String) {
        profileView.image = UIImage(named: "Blank")
        username.text = name
        locationLabel.text = location
        locationIcon.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        caption.text = captions
        createdAt.text = created
    }
}
