import UIKit

class BaseViewController: UIViewController {
    func displayAlert(title: String, message: String, completion: @escaping () -> Void?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        completion()
    }
}
