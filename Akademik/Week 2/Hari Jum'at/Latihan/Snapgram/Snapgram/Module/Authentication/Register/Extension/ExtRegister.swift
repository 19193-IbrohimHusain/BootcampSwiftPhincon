import UIKit

extension RegisterViewController {
    
    func setupRegister() {
        navigationItem.hidesBackButton = true
        bindData()
        configureRegisterAnimation()
        configureImage()
        configureTextField()
        configureButton()
    }
    
    func bindData() {
        vm.registerResponse.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self else { return }
            self.registerResponse = data
        }).disposed(by: bag)
        
        vm.loadingState.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch state {
                case .notLoad:
                    self.afterDissmissed(self.signUpBtn.customButton, title: "Sign Up")
                case .loading:
                    self.addLoading(self.signUpBtn.customButton)
                case .failed:
                    self.afterDissmissed(self.signUpBtn.customButton, title: "Sign Up")
                    if let error = self.registerResponse?.message {
                        self.displayAlert(title: "Sign Up Failed", message: "\(String(describing: error)), Please try again")
                    }
                case .finished:
                    self.afterDissmissed(self.signUpBtn.customButton, title: "Sign Up")
                    if let message = self.registerResponse?.message {
                        self.displayAlert(title: message, message: "Please Sign In to continue") {
                            self.navigateToLoginView()
                        }
                    }
                }
            }
        }).disposed(by: bag)
    }
    
    func configureRegisterAnimation() {
        registerAnimation.loopMode = .loop
        registerAnimation.contentMode = .scaleAspectFill
        registerAnimation.play()
    }
    
    func configureImage() {
        configureShowPassword(rightPasswordView, image: showPasswordImage, action: #selector(showPassword(_:)))
        configureShowPassword(rightCPasswordView, image: showCPasswordImage, action: #selector(showConfirmPassword(_:)))
    }

    func configureShowPassword(_ containerView: UIView, image: UIImageView, action: Selector) {
        containerView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        containerView.addSubview(image)
        image.center = CGPoint(x: containerView.bounds.width / 2, y: containerView.bounds.height / 2)
        image.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: action)
        image.addGestureRecognizer(tapGesture)
    }

    func configureTextField() {
        configureInputField(nameInputField, placeholder: "Name", errorText: "")
        configureInputField(emailInputField, placeholder: "Email", errorText: "Your email format is not valid")
        configurePasswordInputField(passwordInputField, placeholder: "Password", errorText: "Password must be at least 8 characters")
        configureCPasswordInputField(confirmPasswordInputField, placeholder: "Confirm Password", errorText: "The password is not the same as the one entered")
    }

    func configureInputField(_ inputField: CustomInputField, placeholder: String, errorText: String) {
        inputField.setup(placeholder: placeholder, errorText: errorText)
    }

    func configurePasswordInputField(_ passwordField: CustomInputField, placeholder: String, errorText: String) {
        configureInputField(passwordField, placeholder: placeholder, errorText: errorText)
        passwordField.textField.isSecureTextEntry = true
        passwordField.textField.rightView = rightPasswordView
        passwordField.textField.rightViewMode = .always
    }
    
    func configureCPasswordInputField(_ passwordField: CustomInputField, placeholder: String, errorText: String) {
        configureInputField(passwordField, placeholder: placeholder, errorText: errorText)
        passwordField.textField.isSecureTextEntry = true
        passwordField.textField.rightView = rightCPasswordView
        passwordField.textField.rightViewMode = .always
    }

    func configureButton() {
        signUpBtn.setup(title: "Sign Up", image: "")
        signInBtn.setAnimateBounce()
        actionSignUp()
    }

    @objc func showPassword(_ sender: UITapGestureRecognizer) {
        togglePasswordVisibility(for: passwordInputField, imageView: showPasswordImage)
    }

    @objc func showConfirmPassword(_ sender: UITapGestureRecognizer) {
        togglePasswordVisibility(for: confirmPasswordInputField, imageView: showCPasswordImage)
    }

    func togglePasswordVisibility(for passwordField: CustomInputField, imageView: UIImageView) {
        passwordField.textField.isSecureTextEntry.toggle()
        imageView.image = UIImage(systemName: passwordField.textField.isSecureTextEntry ? "eye.fill" : "eye.slash.fill")
    }

    func actionSignUp() {
        signUpBtn.customButton.addTarget(self, action: #selector(onSignUpBtnTap(_:)), for: .touchUpInside)
    }

    @objc func onSignUpBtnTap(_ sender: Any) {
        addLoading(signUpBtn.customButton)
        
        guard validateInputField(nameInputField, message: "Please Enter Your Name", completion: {
            self.afterDissmissed(self.signUpBtn.customButton, title: "Sign Up")
        }) else { return }
        
        guard validateInputField(emailInputField, message: "Please Enter Your Email", completion: {
            self.afterDissmissed(self.signUpBtn.customButton, title: "Sign Up")
        }) else { return }
        
        guard validateInputField(passwordInputField, message: "Please Enter Your Password", completion: {
            self.afterDissmissed(self.signUpBtn.customButton, title: "Sign Up")
        }) else { return }
        
        guard validateInputField(confirmPasswordInputField, message: "Please Confirm Your Password", completion: {
            self.afterDissmissed(self.signUpBtn.customButton, title: "Sign Up")
        }) else { return }
        
        guard validateEmail(candidate: emailInputField.textField.text!) else {
            displayAlert(title: "Sign Up Failed", message: "Please Enter Valid Email") { self.afterDissmissed(self.signUpBtn.customButton, title: "Sign Up") }
            return
        }
        
        guard validatePassword(candidate: passwordInputField.textField.text!) else {
            displayAlert(title: "Sign Up Failed", message: "Password must contain at least 8 characters, 1 Alphabet and 1 Number") {
                self.afterDissmissed(self.signUpBtn.customButton, title: "Sign Up")
            }
            return
        }
        
        guard confirmPasswordInputField.textField.text == passwordInputField.textField.text else {
            displayAlert(title: "Sign Up Failed", message: "Confirmed Password is not the same as Password you entered") {
                self.afterDissmissed(self.signUpBtn.customButton, title: "Sign Up")
            }
            return
        }
        
        signUp()
    }
    
    func signUp(){
        let enteredName = nameInputField.textField.text!
        let enteredEmail = emailInputField.textField.text!
        let enteredPassword = passwordInputField.textField.text!
        vm.signUp(param: RegisterParam(name: enteredName, email: enteredEmail, password: enteredPassword))
    }
    
    func navigateToLoginView() {
        self.navigationController?.popViewController(animated: true)
    }
}
