import UIKit
import GoogleMaps

struct GoogleMapsHelper {
    static let NewYork = CLLocation(latitude: 40.730610, longitude: -73.935242)
    
    static var preciseLocationZoomLevel: Float = 15.0
    static var approximateLocationZoomLevel: Float = 10.0
    
    static func initLocationManager(_ locationManager: CLLocationManager, delegate: UIViewController) {
        var locationManager = locationManager
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = delegate as? CLLocationManagerDelegate
    }
    
    static func createMap(on view: UIView, locationManager: CLLocationManager, mapView: GMSMapView) {
        let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
        let camera = GMSCameraPosition.camera(withLatitude: NewYork.coordinate.latitude, longitude: NewYork.coordinate.longitude, zoom: zoomLevel)
        var mapView = mapView
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        view.addSubview(mapView)
    }
    
    static func didUpdateLocations(_ locations:[CLLocation], locationManager: CLLocationManager, mapView: GMSMapView) {
        let location: CLLocation = locations.last!
        let zoomLevel = locationManager.accuracyAuthorization == .fullAccuracy ? preciseLocationZoomLevel : approximateLocationZoomLevel
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)
        mapView.camera = camera
    }
    
    static func handle(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus, mapView: GMSMapView) {
        let accuracy = manager.accuracyAuthorization
        switch accuracy {
        case .fullAccuracy:
            preciseLocationZoomLevel
            print("Location Accuracy is precise.")
        case .reducedAccuracy:
            approximateLocationZoomLevel
            print("Location Accuracy is not precise.")
        @unknown default:
            fatalError()
        }
        
        switch status {
        case .restricted:
            manager.requestWhenInUseAuthorization()
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            print("Location status not determined.")
        case .authorizedAlways:
            CLLocationManager.locationServicesEnabled()
            manager.requestLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
            print("Location status is OK.")
        case .authorizedWhenInUse:
            CLLocationManager.locationServicesEnabled()
            manager.requestLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
            print("Location status is OK.")
        @unknown default:
            fatalError()
            
        }
        
    }
    
}
