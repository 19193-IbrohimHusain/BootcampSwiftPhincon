import UIKit
import Lottie

class SplashScreenViewController: UIViewController {
    
    @IBOutlet weak var splashScreen: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.navigationController?.setViewControllers([LoginViewController()], animated: true)
        }
        splashScreen.contentMode = .scaleAspectFill
        splashScreen.loopMode = .loop
        splashScreen.play()
    }
}
