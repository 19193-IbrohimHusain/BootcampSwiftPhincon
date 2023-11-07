import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var zoom: Float = 15
    let marker = GMSMarker()
    let locationManager = CLLocationManager()
    var data: ListStory!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let camera = GMSCameraPosition.camera(withLatitude: 37.36, longitude: -122.0, zoom: 6.0)
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        mapView.camera = camera
        mapView.settings.myLocationButton = true
        mapView.animate(toZoom: zoom)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        mapView.addGestureRecognizer(pinchGesture)
//        showMarker(position: camera.target)
    }
    
    func showMarker(){
//        for data in data {
//            let position = CLLocationCoordinate2D(latitude: data.lat, longitude: data.lon)
//                let marker = GMSMarker(position: position)
//                marker.title = data.name
//                marker.snippet = data.description
//                marker.map = mapView
//        }
    }
    
    @objc func handlePinchGesture(_ sender: UIPinchGestureRecognizer) {
        // Handle the pinch gesture here
        // You can access the scale property of the sender to get the pinch scale.
        // For example, you can change the zoom level of the map.
        let newZoom = mapView.camera.zoom / Float(sender.scale)
        let newCamera = GMSCameraUpdate.zoom(to: newZoom)
        mapView.animate(with: newCamera)
        
        // Reset the gesture recognizer's scale to 1 to prevent cumulative scaling
        sender.scale = 1.0
    }
    
    func fetchStoriesWithLocation() {
        APIManager.shared.fetchRequest(endpoint: .fetchStory, expecting: StoryResponse.self) {
            [weak self] result in
            switch result {
            case .success(let data):
                self?.data = data.listStory![<#Int#>]
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

extension MapViewController: GMSMapViewDelegate{
    /* handles Info Window tap */
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("didTapInfoWindowOf")
    }
    
    /* handles Info Window long press */
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("didLongPressInfoWindowOf")
    }
    
    /* set a custom Info Window */
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        //        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 70))
        //        view.backgroundColor = UIColor.white
        //        view.layer.cornerRadius = 6
        //
        //        let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
        //        lbl1.text = "Hi there!"
        //        view.addSubview(lbl1)
        //
        //        let lbl2 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y + lbl1.frame.size.height + 3, width: view.frame.size.width - 16, height: 15))
        //        lbl2.text = "I am a custom info window."
        //        lbl2.font = UIFont.systemFont(ofSize: 14, weight: .light)
        //        view.addSubview(lbl2)
        if let infoWindowView = Bundle.main.loadNibNamed("CustomInfoView", owner: self, options: nil)?.first as? CustomInfoView {
            // Configure the content of the custom info window based on the marker's data
            infoWindowView.setup(name: data.name, location: data.name, captions: data.description, created: data.createdAt)
            infoWindowView.uploadedImage.kf.setImage(with: URL(string: data.photoURL))
            
            return infoWindowView
        }
        
        return nil
    }
    //MARK - GMSMarker Dragging
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        print("didBeginDragging")
    }
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("didDrag")
    }
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("didEndDragging")
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        marker.position = coordinate
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        zoom = mapView.camera.zoom
    }
}
