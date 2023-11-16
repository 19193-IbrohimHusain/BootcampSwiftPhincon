import UIKit
import Security
import RxSwift
import RxCocoa

extension LoginViewController {
    
    func setupLogin() {
        bindData()
        configureLoginAnimation()
        configureShowImage()
        configureTextField()
        configureButton()
        navigate()
    }
    
    func bindData() {
        vm.loginResponse.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self else { return }
            self.loginResponse = data
            if let token = data?.loginResult?.token {
                self.storeToken(with: token)
            }
        }).disposed(by: bag)
        
        vm.loadingState.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch state {
                case .notLoad:
                    self.afterDismiss()
                case .loading:
                    self.addLoading()
                case .failed:
                    self.afterDismiss()
                    if let error = self.loginResponse?.message {
                        self.displayAlert(title: "Sign In Failed", message: "\(String(describing: error)), Please try again")
                    }
                case .finished:
                    self.afterDismiss()
                    self.navigateToTabBarView()
                }
            }
        }).disposed(by: bag)
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
        passwordInputField.setup(placeholder: "Password", errorText: "Password must be at least 8 characters")
        passwordInputField.textField.isSecureTextEntry = true
        passwordInputField.textField.rightView = rightView
        passwordInputField.textField.rightViewMode = .always
    }
    
    func configureButton() {
        signInBtn.setup(title: "Sign In", image: "")
        signInWithAppleBtn.setup(title: "Sign In With Apple ID", image: "apple.logo")
        signInWithAppleBtn.customButton.backgroundColor = .white
        signInWithAppleBtn.customButton.setTitleColor(.systemBlue, for: .normal)
        signInWithAppleBtn.customButton.layer.borderWidth = 1.0
    }
    
    @objc func showPassword(_ sender: UITapGestureRecognizer) {
        passwordInputField.textField.isSecureTextEntry.toggle()
        imageView.image = UIImage(systemName: passwordInputField.textField.isSecureTextEntry ? "eye.fill" : "eye.slash.fill")
    }
    
    func navigate() {
        signInBtn.customButton.addTarget(self, action: #selector(onSignInBtnTap), for: .touchUpInside)
        signInWithAppleBtn.customButton.addTarget(self, action: #selector(onSignInWithAppleBtnTap), for: .touchUpInside)
    }
    
    @objc func onSignInBtnTap() {
        validate()
    }
    
    @objc func onSignInWithAppleBtnTap() {
        // Handle Apple sign-in
    }
    
    func validate() {
        addLoading()

        guard validateInputField(emailInputField, message: "Please Enter Your Email", completion: {
            self.afterDismiss()
        }) else { return }
        
        guard validateInputField(passwordInputField, message: "Please Enter Your Password", completion: {
            self.afterDismiss()
        }) else { return }
        
        guard validateEmail(candidate: emailInputField.textField.text!) else {
            displayAlert(title: "Sign In Failed", message: "Please Enter Valid Email") { self.afterDismiss() }
            return
        }
        
//        guard validatePassword(candidate: passwordInputField.textField.text!) else {
//            displayAlert(title: "Sign In Failed", message: "Please Enter Valid Password") { self.afterDismiss() }
//            return
//        }
        
        signIn()
    }
    
    func addLoading() {
        signInBtn.customButton.isEnabled = false
        signInBtn.customButton.isUserInteractionEnabled = false
        signInBtn.customButton.layer.backgroundColor = UIColor.systemGray5.cgColor
        activityIndicator.center = CGPoint(x: signInBtn.bounds.width / 2 , y: signInBtn.bounds.height / 2)
        signInBtn.customButton.addSubview(activityIndicator)
        signInBtn.customButton.setTitle("", for: .disabled)
        activityIndicator.startAnimating()
    }
    
    func signIn() {
        let enteredEmail = emailInputField.textField.text!
        let enteredPassword = passwordInputField.textField.text!
        vm.signIn(param: LoginParam(email: enteredEmail, password: enteredPassword))
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
        activityIndicator.stopAnimating()
        signInBtn.customButton.isEnabled = true
        signInBtn.customButton.isUserInteractionEnabled = true
        self.signInBtn.customButton.layer.backgroundColor = UIColor.systemBlue.cgColor
        signInBtn.customButton.setTitle("Sign In", for: .normal)
    }
}
