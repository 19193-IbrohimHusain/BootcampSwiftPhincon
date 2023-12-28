import UIKit
import Lottie

class SplashScreenViewController: BaseViewController {
    // MARK: - Variables
    @IBOutlet weak var splashScreen: LottieAnimationView!
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    // MARK: - Functions
    private func setup() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if self.getTokenFromKeychain() != nil {
                self.navigationController?.setViewControllers([TabBarViewController()], animated: true)
            } else {
                self.navigationController?.setViewControllers([LoginViewController()], animated: true)
            }
        }
        splashScreen.contentMode = .scaleAspectFill
        splashScreen.loopMode = .playOnce
        splashScreen.play()
    }
}
