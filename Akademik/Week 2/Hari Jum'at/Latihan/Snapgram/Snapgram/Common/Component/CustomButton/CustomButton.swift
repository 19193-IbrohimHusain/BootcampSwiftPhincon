import UIKit

@IBDesignable
class CustomButton: UIButton {
    
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
    }

    func setup(title: String, image: String?) {
        customButton.setTitle(title, for: .normal)
        customButton.setImage(UIImage(systemName: image ?? ""), for: .normal)
       }
}
