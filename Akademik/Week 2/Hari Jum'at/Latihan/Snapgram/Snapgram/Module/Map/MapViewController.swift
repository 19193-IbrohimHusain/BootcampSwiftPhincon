import UIKit
import GoogleMaps
import RxSwift
import RxCocoa

class MapViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var bounds = GMSCoordinateBounds()
    let marker = GMSMarker()
    
    let locationManager = CLLocationManager()
    let vm = MapViewModel()
    let bag = DisposeBag()
    var dataMarker: [ListStory] = []
    var listMarker: [GMSMarker] = []
    let infoView = CustomViewMarker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        checkLocationAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.delegate = self
        fetchData()
    }
    
    func fetchData() {
        vm.fetchLocationStory(param: StoryTableParam(location: 1))
        vm.mapData.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self, let data = data?.listStory else { return }
            self.dataMarker.append(contentsOf: data)
            self.updateMapMarkers()
        }).disposed(by: bag)
    }
    
    func updateMapMarkers() {
        DispatchQueue.main.async {
            self.dataMarker.forEach { item in
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: item.lat!, longitude: item.lon!)
                marker.title = item.name
                marker.snippet = item.description
                marker.userData = item
                marker.map = self.mapView
                marker.tracksInfoWindowChanges = true
                self.listMarker.append(marker)
                self.bounds = self.bounds.includingCoordinate(marker.position)
            }
            let update = GMSCameraUpdate.fit(self.bounds, with: UIEdgeInsets(top: 50.0, left: 50.0, bottom: 50.0, right: 50.0))
            self.mapView.animate(with: update)
        }
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        infoView.removeFromSuperview()
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return infoView
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let point = mapView.projection.point(for: marker.position)
        let camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: 10.0)
        mapView.animate(to: camera)
        
        if mapView.camera.zoom == 10.0 {
            showInfoView(marker: marker, at: point)
        }
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        infoView.removeFromSuperview()
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        infoView.center = mapView.projection.point(for: marker.position)
        infoView.center.y = infoView.center.y - 120
        mapView.selectedMarker = nil
    }
    
    func showInfoView(marker: GMSMarker, at point: CGPoint) {
        let width = 200.0
        let height = 300.0
        let offset: CGFloat = 40
        
        let offsetX = point.x - (width * 0.5)
        let offsetY = point.y - height - offset
        
        infoView.frame = CGRect(x: offsetX, y: offsetY, width: width, height: height)
        infoView.layer.backgroundColor = UIColor.white.cgColor
        infoView.layer.cornerRadius = 20.0
        infoView.clipsToBounds = true
        
        if let infoData = marker.userData as? ListStory {
            infoView.configure(name: infoData.name, location: "Karawang, Indonesia", image: infoData.photoURL, caption: infoData.description, createdAt: infoData.createdAt)
        }
        
        mapView.addSubview(infoView)
        infoView.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(navigateToDetailStory(_:))))
    }
    
    @objc func navigateToDetailStory(_ gesture: UIGestureRecognizer) {
        if let markerID = marker.userData as? ListStory {
            let vc = DetailStoryViewController()
            vc.storyID = markerID.id
            self.navigationController?.pushViewController(vc, animated: true)
            infoView.removeFromSuperview()
        }
    }
}
