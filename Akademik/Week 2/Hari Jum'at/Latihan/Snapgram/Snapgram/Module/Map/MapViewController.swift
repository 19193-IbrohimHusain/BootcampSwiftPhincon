import UIKit
import GoogleMaps
import RxSwift
import RxCocoa

class MapViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var zoom: Float = 15
    let marker = GMSMarker()
    let locationManager = CLLocationManager()
    let vm = MapViewModel()
    let bag = DisposeBag()
    var listMarker: [ListStory] = []
    let infoView = CustomViewMarker(frame: CGRect(x: 0, y: 0, width: 200, height: 340))
    var activeMarker: GMSMarker?
    var listInfoView: [UIView] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.fetchLocationStory(param: StoryTableParam(size: 5, location: 1))
        vm.mapData.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self else {return}
            self.listMarker.append(contentsOf: data?.listStory ?? [])
            DispatchQueue.main.async {
                self.listMarker.forEach { item in
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: item.lat ?? 0.0, longitude: item.lon ?? 0.0)
                    marker.title = item.name
                    marker.snippet = item.description
                    marker.userData = self.listMarker
                    marker.map = self.mapView
                    marker.tracksInfoWindowChanges = true
                    self.infoView.configure(name: item.name, location: "Karawang, Indonesia", image: item.photoURL, caption: item.description, createdAt: item.createdAt)
                    self.listInfoView.append(self.infoView)
//                    if let infoData = marker.userData as? ListStory {
//                        self.infoView.configure(name: infoData.name, location: "Karawang, Indonesia", image: infoData.photoURL, caption: infoData.description, createdAt: infoData.createdAt)
//                    }
                }
                if let lastMarker = self.listMarker.last {
                    let camera = GMSCameraPosition.camera(withLatitude: lastMarker.lat ?? 0.0, longitude: lastMarker.lon ?? 0.0, zoom: 15.0)
                    self.mapView.camera = camera
                }
            }
        }).disposed(by: bag)
    }
    
}

extension MapViewController: GMSMapViewDelegate{
    /* handles Info Window tap */
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("didTapInfoWindowOf")
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        activeMarker = marker
        for customInfo in listInfoView {
            return customInfo
        }
        return nil
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        var point = mapView.projection.point(for: marker.position)
        point.y = point.y - 110
        
        let camera = mapView.projection.coordinate(for: point)
        let position = GMSCameraUpdate.setTarget(camera)
        mapView.animate(with: position)
        
        infoView.layer.backgroundColor = UIColor.white.cgColor
        infoView.layer.cornerRadius = 20.0
        infoView.clipsToBounds = true
        infoView.center = mapView.projection.point(for: marker.position)
        infoView.center.y = infoView.center.y - 110
//        if let infoData = marker.userData as? ListStory {
//            infoView.configure(name: infoData.name, location: "Karawang, Indonesia", image: infoData.photoURL, caption: infoData.description, createdAt: infoData.createdAt)
//        }
        marker.tracksInfoWindowChanges = true
        self.view.addSubview(infoView)
        infoView.bringSubviewToFront(self.view)
        return true
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
        activeMarker?.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
        activeMarker = nil
        mapView.selectedMarker = nil
        infoView.removeFromSuperview()
        marker.position = coordinate
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        zoom = mapView.camera.zoom
    }
}
