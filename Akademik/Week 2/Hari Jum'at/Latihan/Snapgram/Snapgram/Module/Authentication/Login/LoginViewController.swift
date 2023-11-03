import UIKit
import Lottie

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var loginAnimation: LottieAnimationView!
    @IBOutlet weak var emailInputField: CustomInputField!
    @IBOutlet weak var passwordInputField: CustomInputField!
    @IBOutlet weak var signInBtn: CustomButton!
    @IBOutlet weak var signInWithAppleBtn: CustomButton!
    
    let rightView = UIView()
    let imageView = UIImageView(image: UIImage(systemName: "eye.fill"))

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogin()
    }
    
    @IBAction func onSignUpBtnTap() {
        navigateToRegisterView()
    }
}
