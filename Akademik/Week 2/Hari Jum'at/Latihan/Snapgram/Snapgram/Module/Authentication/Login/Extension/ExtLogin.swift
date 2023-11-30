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
            if let validData = data?.loginResult {
                self.storeToken(with: validData.token)
                let user = User(email: self.emailInputField.textField.text!, username: validData.name, userid: validData.userId)
                do {
                    let userData = try JSONEncoder().encode(user)
                    BaseConstant.userDef.set(userData, forKey: "userData")
                } catch {
                    print("Error encoding user data: \(error)")
                }
            }
        }).disposed(by: bag)
        
        vm.loadingState.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch state {
                case .notLoad:
                    self.afterDissmissed(self.signInBtn.customButton, title: "Sign In")
                case .loading:
                    self.addLoading(self.signInBtn.customButton)
                case .failed:
                    self.afterDissmissed(self.signInBtn.customButton, title: "Sign In")
                    if let error = self.loginResponse?.message {
                        self.displayAlert(title: "Sign In Failed", message: "\(String(describing: error)), Please try again")
                    }
                case .finished:
                    self.afterDissmissed(self.signInBtn.customButton, title: "Sign In")
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
        signUpBtn.setAnimateBounce()
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
        addLoading(self.signInBtn.customButton)

        guard validateInputField(emailInputField, message: "Please Enter Your Email", completion: {
            self.afterDissmissed(self.signInBtn.customButton, title: "Sign In")
        }) else { return }
        
        guard validateInputField(passwordInputField, message: "Please Enter Your Password", completion: {
            self.afterDissmissed(self.signInBtn.customButton, title: "Sign In")
        }) else { return }
        
        guard validateEmail(candidate: emailInputField.textField.text!) else {
            displayAlert(title: "Sign In Failed", message: "Please Enter Valid Email") { self.afterDissmissed(self.signInBtn.customButton, title: "Sign In") }
            return
        }
        
        guard validatePassword(candidate: passwordInputField.textField.text!) else {
            displayAlert(title: "Sign In Failed", message: "Please Enter Valid Password") { self.afterDissmissed(self.signInBtn.customButton, title: "Sign In") }
            return
        }
        
        signIn()
    }
    
    func signIn() {
        let enteredEmail = emailInputField.textField.text!
        let enteredPassword = passwordInputField.textField.text!
        vm.signIn(param: LoginParam(email: enteredEmail, password: enteredPassword))
    }
    
    func navigateToTabBarView() {
        let tbvc = TabBarViewController()
        tbvc.hidesBottomBarWhenPushed = true
        self.navigationController?.setViewControllers([tbvc], animated: true)
    }
    
    func navigateToRegisterView() {
        let rvc = RegisterViewController()
        self.navigationController?.pushViewController(rvc, animated: true)
    }
}
