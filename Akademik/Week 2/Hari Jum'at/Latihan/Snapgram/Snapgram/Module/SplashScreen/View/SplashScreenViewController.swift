import UIKit
import Lottie

class SplashScreenViewController: BaseViewController {
    
    @IBOutlet weak var splashScreen: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        splashScreen.stop()
        splashScreen = nil
    }
    
    func setup() {
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
