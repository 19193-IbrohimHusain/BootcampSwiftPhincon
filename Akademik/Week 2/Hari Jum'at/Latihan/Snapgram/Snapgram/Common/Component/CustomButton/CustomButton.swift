import UIKit

@IBDesignable
class CustomButton: UIView {
    
    @IBOutlet weak var customButton: UIButton!
    
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
        self.addSubview(view)
    }
    
    @IBAction func onTap() {
        customButton.becomeFirstResponder()
        customButton.isEnabled = false
        customButton.isUserInteractionEnabled = false
//        customButton.layer.backgroundColor = UIColor.systemGray5.cgColor
//        let activityIndicator = UIActivityIndicatorView(style: .medium)
//        activityIndicator.startAnimating()
//        activityIndicator.center = CGPoint(x: customButton.bounds.width / 2 , y: customButton.bounds.height / 2)
//        customButton.addSubview(activityIndicator)
        customButton.setTitle("", for: .disabled)
        customButton.setImage(UIImage(systemName: ""), for: .disabled)
    }
    
    func setup(title: String, image: String?) {
        customButton.setTitle(title, for: .normal)
        customButton.setImage(UIImage(systemName: image ?? ""), for: .normal)
        customButton.layer.cornerRadius = 8.0
        customButton.layer.borderColor = UIColor.systemBlue.cgColor
        customButton.layer.backgroundColor = UIColor.systemBlue.cgColor
        customButton.setTitleColor(UIColor.white, for: .normal)
        customButton.configuration?.imagePadding = 8.0
    }
}