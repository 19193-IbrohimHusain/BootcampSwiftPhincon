import UIKit
import Lottie

class LoginViewController: UIViewController {

    @IBOutlet weak var animationView: LottieAnimationView!
    @IBOutlet weak var emailInputField: CustomInputField!
    @IBOutlet weak var passwordInputField: CustomInputField!
    @IBOutlet weak var signInBtn: CustomButton!
    @IBOutlet weak var signInWithAppleBtn: CustomButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    let imageView = UIImageView(image: UIImage(systemName: "eye.fill"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogin()
    }
    
    @IBAction func onSignInBtnTap() {
        validation()
    }
    
}
