import UIKit
import CoreLocation
import GoogleMaps

extension MapViewController: CLLocationManagerDelegate {

    func locationManager(
    _ manager: CLLocationManager,
    didChangeAuthorization status: CLAuthorizationStatus
  ) {
      GoogleMapsHelper.handle(manager, didChangeAuthorization: status, mapView: mapView)
  }

  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]) {
        GoogleMapsHelper.didUpdateLocations(locations, locationManager: manager, mapView: mapView)
  }

  // 8
  func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error
  ) {
      locationManager.stopUpdatingLocation()
      print("Error \(error)")
  }
}
