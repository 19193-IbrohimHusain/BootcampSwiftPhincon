import UIKit
import Security

extension LoginViewController {
    func setupLogin() {
        configureLoginAnimation()
        configureShowImage()
        configureTextField()
        configureButton()
        navigate()
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
    
    func navigate() {
        signInBtn.customButton.addTarget(self, action: #selector(onSignInBtnTap(_:)), for: .touchUpInside)
        signInWithAppleBtn.customButton.addTarget(self, action: #selector(onSignInWithAppleBtnTap(_:)), for: .touchUpInside)
    }
    
    @objc func onSignInBtnTap(_ sender: Any) {
        validate()
    }
    
    @objc func onSignInWithAppleBtnTap(_ sender: Any) {
        
    }
    
    func validate() {
        signInBtn.customButton.isEnabled = false
        signInBtn.customButton.isUserInteractionEnabled = false
        signInBtn.customButton.layer.backgroundColor = UIColor.systemGray5.cgColor
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        activityIndicator.center = CGPoint(x: signInBtn.bounds.width / 2 , y: signInBtn.bounds.height / 2)
        signInBtn.customButton.addSubview(activityIndicator)
        signInBtn.customButton.setTitle("", for: .disabled)
        
        Task {
            try await Task.sleep(nanoseconds: 7 * 1_000_000_000)
            guard let enteredEmail = emailInputField.textField.text, !enteredEmail.isEmpty else {
                displayAlert(title: "Sign In Failed", message: "Please Enter Your Email") {
                    self.afterDismiss()
                }
                activityIndicator.stopAnimating()
                signInBtn.customButton.isUserInteractionEnabled = true
                signInBtn.customButton.layer.backgroundColor = UIColor.systemBlue.cgColor
                return
            }
            guard validateEmail(candidate: emailInputField.textField.text!) == true else {
                displayAlert(title: "Sign Up Failed", message: "Please Enter Valid Email") {
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
                signInBtn.customButton.layer.backgroundColor = UIColor.systemBlue.cgColor
                return
            }
            //            guard validatePassword(candidate: passwordInputField.textField.text!) == true else {
            //                displayAlert(title: "Sign Up Failed", message: "Password must contain at least 8 characters, 1 Alphabet and 1 Number") {
            //                    self.afterDismiss()
            //                }
            //                activityIndicator.stopAnimating()
            //                signInBtn.customButton.isUserInteractionEnabled = true
            //                return
            //            }
            activityIndicator.stopAnimating()
            signInBtn.customButton.layer.backgroundColor = UIColor.systemBlue.cgColor
            afterDismiss()
            signIn()
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
    
    func signIn() {
        let enteredEmail = emailInputField.textField.text!
        let enteredPassword = passwordInputField.textField.text!
        
        APIManager.shared.fetchRequest(endpoint: .login(param: LoginParam(email: enteredEmail, password: enteredPassword)), expecting: LoginResponse.self) { result in
            switch result {
            case .success(let response):
                self.storeToken(with: response.loginResult!.token)
                DispatchQueue.main.async {
                    self.navigationController?.setViewControllers([TabBarViewController()], animated: true)
                    print("Result login: \(String(describing: response.loginResult))")
                }
            case .failure(let error):
                self.displayAlert(title: "Sign In Failed", message: "\(String(describing: error)), Please try again")
            }
        }
    }
    
    func storeToken(with token: String) {
        // Prepare the data to be stored (your authentication token)
        let tokenData = token.data(using: .utf8)
        
        // Create a dictionary to specify the keychain item attributes
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "AuthToken",
            kSecValueData: tokenData!,
        ]
        
        // Add the item to the keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("Token saved to Keychain")
        } else {
            print("Failed to save token to Keychain")
        }
    }
    
    func navigateToTabBarView() {
        let tbvc = TabBarViewController()
        self.navigationController?.setViewControllers([tbvc], animated: true)
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
