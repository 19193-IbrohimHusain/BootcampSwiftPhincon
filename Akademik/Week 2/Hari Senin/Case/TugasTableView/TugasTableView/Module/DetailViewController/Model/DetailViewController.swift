import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        posterImage.layer.cornerRadius = 16

    }
}
