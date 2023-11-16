import UIKit
import GoogleMaps
import Security
import RxSwift

class BaseViewController: UIViewController {
    internal let activityIndicator = UIActivityIndicatorView(style: .medium)
    internal let geocoder = GMSGeocoder()
    internal let bag = DisposeBag()
    
    func validateInputField(_ inputField: CustomInputField, message: String, completion: @escaping () -> Void) -> Bool {
        guard let text = inputField.textField.text, !text.isEmpty else {
            displayAlert(title: "Sign Up Failed", message: message) {
                completion()
            }
            return false
        }
        return true
    }
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    func validatePassword(candidate: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: candidate)
    }
    
    func displayAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        completion?()
    }
    
    func getLocationNameFromCoordinates(lat: Double, lon: Double, completion: @escaping (String?) -> Void) {
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard error == nil, let result = response?.results() else {
                print("Geocoding error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            result.forEach { data in
                guard let city = data.locality, let country = data.country else { return }
                let name = "\(city), \(country)"
                completion(name)
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
    
    func deleteToken() {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "AuthToken",
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            print("Token deleted from Keychain")
        } else {
            print("Failed to delete token from Keychain")
        }
    }
}
