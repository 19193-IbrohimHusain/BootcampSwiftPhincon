import UIKit

extension LoginViewController {
    func setupLogin() {
        configureLoginAnimation()
        configureShowImage()
        configureTextField()
        configureButton()
        navigateToHome()
    }
    
    func configureLoginAnimation() {
        loginAnimation.play()
        loginAnimation.contentMode = .scaleAspectFill
        loginAnimation.loopMode = .loop
    }
    
    func configureShowImage() {
        rightView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        rightView.addSubview(imageView)
        imageView.center = CGPoint(x: rightView.bounds.width / 2, y: rightView.bounds.height / 2)
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showPassword))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    func configureTextField() {
        emailInputField.setup(placeholder: "Email", errorText: "Your email format is not valid")
        passwordInputField.setup(placeholder: "Password", errorText: "Password must be at least 8 character")
        passwordInputField.textField.isSecureTextEntry = true
        passwordInputField.textField.rightView = rightView
        passwordInputField.textField.rightViewMode = .always
    }
    
    func configureButton() {
        signInBtn.setup(title: "Sign In", image: "")
        signInWithAppleBtn.setup(title: "Sign In With Apple ID", image: "apple.logo")
        signInWithAppleBtn.customButton.backgroundColor = UIColor.white
        signInWithAppleBtn.customButton.setTitleColor(UIColor.systemBlue, for: .normal)
        signInWithAppleBtn.customButton.layer.borderWidth = 1.0
    }
    
    @objc func showPassword(_ sender: UITapGestureRecognizer) {
        passwordInputField.textField.isSecureTextEntry.toggle()
        if passwordInputField.textField.isSecureTextEntry {
            imageView.image = UIImage(systemName: "eye.fill")
        } else {
            imageView.image = UIImage(systemName: "eye.slash.fill")
        }
    }
    
    func navigateToHome() {
        signInBtn.customButton.addTarget(self, action: #selector(onSignInBtnTap(_:)), for: .touchUpInside)
    }
    
    @objc func onSignInBtnTap(_ sender: Any) {
        validate()
    }
    
    func validate() {
        signInBtn.customButton.isEnabled = false
        signInBtn.customButton.isUserInteractionEnabled = false
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        activityIndicator.center = CGPoint(x: signInBtn.bounds.width / 2 , y: signInBtn.bounds.height / 2)
        signInBtn.customButton.addSubview(activityIndicator)
        signInBtn.customButton.setTitle("", for: .disabled)
        
        Task {
            try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
            guard let enteredEmail = emailInputField.textField.text, !enteredEmail.isEmpty else {
                displayAlert(title: "Sign In Failed", message: "Please Enter Your Email") {
                    self.afterDismiss()
                }
                activityIndicator.stopAnimating()
                signInBtn.customButton.isUserInteractionEnabled = true
                return
            }
            guard let enteredPassword = passwordInputField.textField.text, !enteredPassword.isEmpty else {
                displayAlert(title: "Sign In Failed", message: "Please Enter Your Password") {
                    self.afterDismiss()
                }
                activityIndicator.stopAnimating()
                signInBtn.customButton.isUserInteractionEnabled = true
                
                return
            }
            
            let tbvc = TabBarViewController()
            self.navigationController?.setViewControllers([tbvc], animated: true)
            afterDismiss()
        }
    }
    
    func navigateToRegisterView() {
        let rvc = RegisterViewController()
        self.navigationController?.pushViewController(rvc, animated: true)
    }
    
    func afterDismiss() {
        signInBtn.customButton.isEnabled = true
        signInBtn.customButton.isUserInteractionEnabled = true
        signInBtn.customButton.setTitle("Sign In", for: .normal)
    }
}
