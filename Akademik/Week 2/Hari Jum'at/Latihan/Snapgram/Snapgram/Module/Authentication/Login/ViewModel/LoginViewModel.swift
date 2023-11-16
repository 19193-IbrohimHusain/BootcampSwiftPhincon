import Foundation
import RxSwift
import RxCocoa

class LoginViewModel : BaseViewModel {
    var loginResponse = BehaviorRelay<LoginResponse?>(value: nil)
    
    func signIn(param: LoginParam) {
        loadingState.accept(.loading)
        APIManager.shared.fetchRequest(endpoint: .login(param: param), expecting: LoginResponse.self) { result in
            switch result {
            case .success(let response):
                if response.error == true {
                    self.loadingState.accept(.failed)
                    self.loginResponse.accept(response)
                } else {
                    self.loadingState.accept(.finished)
                    self.loginResponse.accept(response)
                }
            case .failure(let error):
                self.loadingState.accept(.failed)
                print(String(describing: error))
            }
        }
    }
}
    
