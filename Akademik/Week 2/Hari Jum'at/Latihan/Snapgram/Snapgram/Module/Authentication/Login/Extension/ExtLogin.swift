import UIKit
import Security
import RxSwift
import RxCocoa

extension LoginViewController {
    internal func bindData() {
        vm.loginResponse.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self else { return }
            if let validData = data?.loginResult {
                self.storeToken(with: validData.token)
                DispatchQueue.main.async {
                    let user = User(email: self.emailInputField.textField.text!, username: validData.name, userid: validData.userId)
                    do {
                        let userData = try JSONEncoder().encode(user)
                        BaseConstant.userDef.set(userData, forKey: "userData")
                    } catch {
                        print("Error encoding user data: \(error)")
                    }
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
    
    internal func validate() {
        addLoading(self.signInBtn.customButton)
        
        guard validateInputField(emailInputField, title: "Sign In Failed", message: "Please Enter Your Email", completion: {
            self.afterDissmissed(self.signInBtn.customButton, title: "Sign In")
        }) else { return }
        
        guard validateInputField(passwordInputField, title: "Sign In Failed", message: "Please Enter Your Password", completion: {
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
    
    private func signIn() {
        let enteredEmail = emailInputField.textField.text!
        let enteredPassword = passwordInputField.textField.text!
        vm.signIn(param: LoginParam(email: enteredEmail, password: enteredPassword))
    }
    
    internal func navigateToTabBarView() {
        let tbvc = TabBarViewController()
        tbvc.hidesBottomBarWhenPushed = true
        self.navigationController?.setViewControllers([tbvc], animated: true)
    }
    
    internal func navigateToRegisterView() {
        let rvc = RegisterViewController()
        self.navigationController?.pushViewController(rvc, animated: true)
    }
}
