import UIKit
import Lottie

class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var registerAnimation: LottieAnimationView!
    
    @IBOutlet weak var nameInputField: CustomInputField!
    
    @IBOutlet weak var emailInputField: CustomInputField!
    
    @IBOutlet weak var passwordInputField: CustomInputField!
    
    @IBOutlet weak var confirmPasswordInputField: CustomInputField!
    
    @IBOutlet weak var signUpBtn: CustomButton!
    
    @IBOutlet weak var signInBtn: UIButton!
    let imageView = UIImageView(image: UIImage(systemName: "eye.fill"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogin()
    }
    
    func setupLogin() {
        animationView.play()
        animationView.loopMode = .loop
        imageView.center = CGPoint(x: signInBtn.bounds.width, y: signInBtn.bounds.height / 2)
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showPassword))
        imageView.addGestureRecognizer(tapGesture)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.addSubview(imageView)
    }
    
    @objc func showPassword(_ sender: UITapGestureRecognizer) {
        passwordTextField.isSecureTextEntry.toggle()
        if passwordTextField.isSecureTextEntry {
            imageView.image = UIImage(systemName: "eye.fill")
        } else {
            imageView.image = UIImage(systemName: "eye.slash.fill")
        }
//        !passwordTextField.isSecureTextEntry ?
//        imageView.image = UIImage(systemName: "eye.slash.fill") : imageView.image = UIImage(systemName: "eye.fill")
    }
    
    @IBAction func onSignInBtnTap(_ sender: Any) {
        signInBtn.isEnabled = false
        signInBtn.isUserInteractionEnabled = false
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        activityIndicator.center = CGPoint(x: signInBtn.bounds.width / 2 , y: signInBtn.bounds.height / 2)
        signInBtn.addSubview(activityIndicator)
        signInBtn.setTitle("", for: .disabled)
        
        Task {
            try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
            guard let enteredEmail = emailTextField.text, !enteredEmail.isEmpty else {
                displayAlert(title: "Sign In Failed", message: "Please Enter Your Email")
                activityIndicator.stopAnimating()
                signInBtn.isUserInteractionEnabled = true
                return
            }
            guard let enteredPassword = passwordTextField.text, !enteredPassword.isEmpty else {
                displayAlert(title: "Sign In Failed", message: "Please Enter Your Password")
                activityIndicator.stopAnimating()
                signInBtn.isUserInteractionEnabled = true
                return
            }
            
            let lpvc = TabBarViewController()
            self.navigationController?.setViewControllers([lpvc], animated: true)
            
            signInBtn.isEnabled = true
            signInBtn.isUserInteractionEnabled = true
            signInBtn.setTitle("Sign In", for: .normal)
        }
    }

    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        signInBtn.isEnabled = true
        signInBtn.setTitle("Sign In", for: .normal)
    }
}
