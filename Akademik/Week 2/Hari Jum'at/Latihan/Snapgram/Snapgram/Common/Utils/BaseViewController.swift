import UIKit
import GoogleMaps

class BaseViewController: UIViewController {
    let geocoder = GMSGeocoder()
    
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
}
