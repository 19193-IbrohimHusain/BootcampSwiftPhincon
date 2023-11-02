import UIKit

class CustomButton: UIButton {

    @IBOutlet weak var button: UIButton!
    
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


    func setup(title: String, image: String) {
        button.currentTitle = title
        button.imageView = UIImageView(image: UIImage(systemName: image))
       }

}
