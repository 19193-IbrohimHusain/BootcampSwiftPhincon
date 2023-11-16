import UIKit
import Lottie

class LoginViewController: BaseViewController {
    
    @IBOutlet weak var loginAnimation: LottieAnimationView!
    @IBOutlet weak var emailInputField: CustomInputField!
    @IBOutlet weak var passwordInputField: CustomInputField!
    @IBOutlet weak var signInBtn: CustomButton!
    @IBOutlet weak var signInWithAppleBtn: CustomButton!
    
    var loginResponse: LoginResponse?
    let vm = LoginViewModel()
    let rightView = UIView()
    let imageView = UIImageView(image: UIImage(systemName: "eye.fill"))

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogin()
    }
    
    @IBAction func onSignUpBtnTap() {
        let rvc = RegisterViewController()
        self.navigationController?.pushViewController(rvc, animated: true)
    }
}
