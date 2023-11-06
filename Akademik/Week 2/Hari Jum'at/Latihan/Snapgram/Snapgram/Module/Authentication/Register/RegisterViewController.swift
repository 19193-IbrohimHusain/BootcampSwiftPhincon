import UIKit
import Lottie

class RegisterViewController: BaseViewController {

    @IBOutlet weak var registerAnimation: LottieAnimationView!
    @IBOutlet weak var nameInputField: CustomInputField!
    @IBOutlet weak var emailInputField: CustomInputField!
    @IBOutlet weak var passwordInputField: CustomInputField!
    @IBOutlet weak var confirmPasswordInputField: CustomInputField!
    @IBOutlet weak var signUpBtn: CustomButton!
    
    let showPasswordImage = UIImageView(image: UIImage(systemName: "eye.fill"))
    let showCPasswordImage = UIImageView(image: UIImage(systemName: "eye.fill"))
    let rightPasswordView = UIView()
    let rightCPasswordView = UIView()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRegister()
    }
    
    @IBAction func onSignInBtnTap() {
        navigateToLoginView()
    }
}
