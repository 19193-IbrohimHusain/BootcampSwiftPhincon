import UIKit
import GoogleMaps
import RxSwift
import RxCocoa

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var zoom: Float = 15
    var vm = MapViewModel()
    let bag = DisposeBag()
    let marker = GMSMarker()
    let locationManager = CLLocationManager()
    var data: StoryResponse!
    var listMarker: [ListStory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        bindData()
        GoogleMapsHelper.initLocationManager(locationManager, delegate: self)
        GoogleMapsHelper.createMap(on: mapView, locationManager: locationManager, mapView: mapView)
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        mapView.addGestureRecognizer(pinchGesture)
        //        showMarker(position: camera.target)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        vm.fetchLocationStory(param: StoryTableParam(location: 1))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mapView.clear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        mapView.clear()
    }
    
    func bindData() {
        vm.mapData.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self else {return}
            if let validData = data, let validStory = validData.listStory {
                self.listMarker.append(contentsOf: validStory)
            }
        }).disposed(by: bag)
        
        vm.loadingState.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else {return}
            
            switch state {
            case .notLoad, .loading:
                self.mapView.showAnimatedGradientSkeleton()
            case .failed, .finished:
                DispatchQueue.main.async {
                    self.mapView.hideSkeleton()
                }
            }
        }).disposed(by: bag)
    }
    
    func addMarker(){
        
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
        if let infoWindowView = Bundle.main.loadNibNamed("CustomInfoView", owner: self, options: nil)?.first as? CustomInfoView {
            // Configure the content of the custom info window based on the marker's data
//            infoWindowView.setup(name: data.name, location: data.name, captions: data.description, created: data.createdAt)
//            infoWindowView.uploadedImage.kf.setImage(with: URL(string: data.photoURL))
//
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
