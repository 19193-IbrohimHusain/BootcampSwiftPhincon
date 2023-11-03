import UIKit

extension RegisterViewController {
    func setupRegister() {
        navigationItem.hidesBackButton = true
        configureRegisterAnimation()
        configureImage()
        configureTextField()
        configureButton()
        actionSignUp()
    }
    
    func configureRegisterAnimation() {
        registerAnimation.loopMode = .loop
        registerAnimation.contentMode = .scaleAspectFill
        registerAnimation.play()
    }
    
    func configureImage() {
        // Show Password Configuration
        rightPasswordView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        rightPasswordView.addSubview(showPasswordImage)
        showPasswordImage.center = CGPoint(x: rightPasswordView.bounds.width / 2, y: rightPasswordView.bounds.height / 2)
        showPasswordImage.isUserInteractionEnabled = true
        let showPasswordTG = UITapGestureRecognizer(target: self, action: #selector(showPassword(_:)))
        showPasswordImage.addGestureRecognizer(showPasswordTG)
        
        // Show Confirm Password Configuration
        rightCPasswordView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        rightCPasswordView.addSubview(showCPasswordImage)
        showCPasswordImage.center = CGPoint(x: rightCPasswordView.bounds.width / 2, y: rightCPasswordView.bounds.height / 2)
        showCPasswordImage.isUserInteractionEnabled = true
        let showCPasswordTG = UITapGestureRecognizer(target: self, action: #selector(showConfirmPassword(_:)))
        showCPasswordImage.addGestureRecognizer(showCPasswordTG)
        
    }
    
    func configureTextField() {
        nameInputField.setup(placeholder: "Name", errorText: "")
        emailInputField.setup(placeholder: "Email", errorText: "Your email format is not valid")
        passwordInputField.setup(placeholder: "Password", errorText: "Password must be at least 8 character")
        passwordInputField.textField.isSecureTextEntry = true
        passwordInputField.textField.rightView = rightPasswordView
        passwordInputField.textField.rightViewMode = .always
        confirmPasswordInputField.setup(placeholder: "Confirm Password", errorText: "The password is not the same as the one entered")
        confirmPasswordInputField.textField.isSecureTextEntry = true
        confirmPasswordInputField.textField.rightView = rightCPasswordView
        confirmPasswordInputField.textField.rightViewMode = .always
    }
    
    func configureButton() {
        signUpBtn.setup(title: "Sign Up", image: "")
    }
    
    @objc func showPassword(_ sender: UITapGestureRecognizer) {
        passwordInputField.textField.isSecureTextEntry.toggle()
        if passwordInputField.textField.isSecureTextEntry {
            showPasswordImage.image = UIImage(systemName: "eye.fill")
        } else {
            showPasswordImage.image = UIImage(systemName: "eye.slash.fill")
        }
    }
    
    @objc func showConfirmPassword(_ sender: UITapGestureRecognizer) {
        confirmPasswordInputField.textField.isSecureTextEntry.toggle()
        if confirmPasswordInputField.textField.isSecureTextEntry {
            showCPasswordImage.image = UIImage(systemName: "eye.fill")
        } else {
            showCPasswordImage.image = UIImage(systemName: "eye.slash.fill")
        }
    }
        
    func actionSignUp() {
        signUpBtn.customButton.addTarget(self, action: #selector(onSignUpBtnTap(_:)), for: .touchUpInside)
    }
    
    @objc func onSignUpBtnTap(_ sender: Any) {
        signUpBtn.customButton.isEnabled = false
        signUpBtn.customButton.isUserInteractionEnabled = false
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        activityIndicator.center = CGPoint(x: signUpBtn.customButton.bounds.width / 2 , y: signUpBtn.customButton.bounds.height / 2)
        signUpBtn.customButton.addSubview(activityIndicator)
        signUpBtn.customButton.setTitle("", for: .disabled)
        
        Task {
            try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
            guard let enteredName = nameInputField.textField.text, !enteredName.isEmpty else {
                displayAlert(title: "Sign Up Failed", message: "Please Enter Your Name") {
                    self.afterDissmissed()
                }
                activityIndicator.stopAnimating()
                signUpBtn.customButton.isUserInteractionEnabled = true
                return
            }
            guard let enteredEmail = emailInputField.textField.text, !enteredEmail.isEmpty else {
                displayAlert(title: "Sign Up Failed", message: "Please Enter Your Email") {
                    self.afterDissmissed()
                }
                activityIndicator.stopAnimating()
                signUpBtn.customButton.isUserInteractionEnabled = true
                return
            }
            guard let enteredPassword = passwordInputField.textField.text, !enteredPassword.isEmpty else {
                displayAlert(title: "Sign Up Failed", message: "Please Enter Your Password") {
                    self.afterDissmissed()
                }
                activityIndicator.stopAnimating()
                signUpBtn.customButton.isUserInteractionEnabled = true
                return
            }
            guard let enteredCPassword = confirmPasswordInputField.textField.text, !enteredCPassword.isEmpty else {
                displayAlert(title: "Sign Up Failed", message: "Please Confirm Your Password") {
                    self.afterDissmissed()
                }
                activityIndicator.stopAnimating()
                signUpBtn.customButton.isUserInteractionEnabled = true
                return
            }
            navigateToLoginView()
            signUpBtn.customButton.isEnabled = true
            signUpBtn.customButton.isUserInteractionEnabled = true
            signUpBtn.customButton.setTitle("Sign In", for: .normal)
        }
    }
    
    func navigateToLoginView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func afterDissmissed() {
        signUpBtn.customButton.isEnabled = true
        signUpBtn.customButton.isUserInteractionEnabled = true
        signUpBtn.customButton.setTitle("Sign In", for: .normal)
    }
}
