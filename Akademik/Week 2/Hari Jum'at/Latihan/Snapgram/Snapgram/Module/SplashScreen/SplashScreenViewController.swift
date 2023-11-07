import UIKit
import Lottie

class SplashScreenViewController: UIViewController {
    
    @IBOutlet weak var splashScreen: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if self.getTokenFromKeychain() != nil{
                self.navigationController?.setViewControllers([TabBarViewController()], animated: true)
            } else {
                self.navigationController?.setViewControllers([LoginViewController()], animated: true)
            }
        }
        splashScreen.contentMode = .scaleAspectFill
        splashScreen.loopMode = .loop
        splashScreen.play()
    }
    
    func getTokenFromKeychain() -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "AuthToken",
            kSecReturnData: kCFBooleanTrue as Any,
        ]
        
        var tokenData: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &tokenData)
        
        if status == errSecSuccess, let data = tokenData as? Data, let token = String(data: data, encoding: .utf8) {
            return token
        } else {
            return nil
        }
    }
}
