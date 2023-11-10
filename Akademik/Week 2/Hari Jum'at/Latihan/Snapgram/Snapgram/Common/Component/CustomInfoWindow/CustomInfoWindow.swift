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
    
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//    
//    class func instanceFromNib() -> UIView {
//        return UINib(nibName: "CustomInfoWindow", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
//    }
//    
//    private func configureView() {
//        let view = self.loadNib()
//        view.frame = self.bounds
//        view.backgroundColor = .white
//        self.addSubview(view)
//    }
    
    func setup() {
        
    }
}
