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
        signUpBtn.customButton.layer.backgroundColor = UIColor.systemGray5.cgColor
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
            guard validateEmail(candidate: emailInputField.textField.text!) == true else {
                displayAlert(title: "Sign Up Failed", message: "Please Enter Valid Email") {
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
            guard validatePassword(candidate: passwordInputField.textField.text!) == true else {
                displayAlert(title: "Sign Up Failed", message: "Password must contain at least 8 characters, 1 Alphabet and 1 Number") {
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
            guard enteredCPassword == enteredPassword else {
                displayAlert(title: "Sign Up Failed", message: "Confirmed Password is not the same as Password you enter") {
                    self.afterDissmissed()
                }
                activityIndicator.stopAnimating()
                signUpBtn.customButton.isUserInteractionEnabled = true
                return
            }
            signUp()
            afterDissmissed()
        }
    }
    
    func validateEmail(candidate: String) -> Bool {
     let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
     return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    func validatePassword(candidate: String) -> Bool {
     let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d).{8,}$"
     return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: candidate)
    }
    
    func signUp(){
        let enteredName = nameInputField.textField.text!
        let enteredEmail = emailInputField.textField.text!
        let enteredPassword = passwordInputField.textField.text!
        
        APIManager.shared.fetchRequest(endpoint: .register(param: RegisterParam(name: enteredName, email: enteredEmail, password: enteredPassword)), expecting: RegisterResponse.self) { result in
            switch result {
            case .success(let response):
                print(response.message)
                self.displayAlert(title: response.message, message: "Please Sign In to continue") {
                    self.navigateToLoginView()
                }
            case .failure(let error):
                print(String(describing: error))
                self.displayAlert(title: "Sign Up Failed", message: "Please try again") {
                    return
                }
            }
        }
    }
    
    func navigateToLoginView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func afterDissmissed() {
        signUpBtn.customButton.isEnabled = true
        signUpBtn.customButton.isUserInteractionEnabled = true
        signUpBtn.customButton.layer.backgroundColor = UIColor.systemBlue.cgColor
        signUpBtn.customButton.setTitle("Sign Up", for: .normal)
    }
}
