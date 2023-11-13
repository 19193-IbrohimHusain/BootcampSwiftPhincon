import UIKit
import GoogleMaps
import RxSwift
import RxCocoa

class MapViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var zoom: Float = 15
    let marker = GMSMarker()
    var bounds = GMSCoordinateBounds()
    let locationManager = CLLocationManager()
    let vm = MapViewModel()
    let bag = DisposeBag()
    var dataMarker: [ListStory] = []
    var listMarker: [GMSMarker] = []
    let infoView = CustomViewMarker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView?.delegate = self
        locationManager.delegate = self
        checkLocationAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.delegate = self
        vm.fetchLocationStory(param: StoryTableParam(location: 1))
        vm.mapData.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self else {return}
            self.dataMarker.append(contentsOf: data?.listStory ?? [])
            DispatchQueue.main.async {
                self.dataMarker.forEach { item in
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: item.lat!, longitude: item.lon!)
                    marker.title = item.name
                    marker.snippet = item.description
                    marker.userData = item as ListStory
                    marker.map = self.mapView
                    marker.tracksInfoWindowChanges = true
                    self.listMarker.append(marker)
                }
                
                for marker in self.listMarker {
                    self.bounds = self.bounds.includingCoordinate(marker.position)
                }
                let update = GMSCameraUpdate.fit(self.bounds, with: UIEdgeInsets(top: 50.0, left: 50.0, bottom: 50.0, right: 50.0))
                self.mapView.animate(with: update)
            }
        }).disposed(by: bag)
    }
//    @objc func navigateToDetail(_ sender: UITapGestureRecognizer) {
//        let vc = DetailStoryViewController()
//        let markerID = marker.userData as? ListStory
//        vc.storyID = markerID?.id
//        self.navigationController?.pushViewController(vc, animated: true)
//        infoView.removeFromSuperview()
//    }
}

extension MapViewController: GMSMapViewDelegate{
//    /* handles Info Window tap */
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let vc = DetailStoryViewController()
        let markerID = marker.userData as? ListStory
        vc.storyID = markerID?.id
        self.navigationController?.pushViewController(vc, animated: true)
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
            let width = 200.0
            let height = 300.0
            let offset: CGFloat = 40 // Adjust this as needed
            
            let offsetX = point.x - (width * 0.5)
            let offsetY = point.y - height - offset
            
            infoView.frame = CGRect(x: offsetX, y: offsetY, width: width, height: height)
            infoView.layer.backgroundColor = UIColor.white.cgColor
            infoView.layer.cornerRadius = 20.0
            infoView.clipsToBounds = true
//            infoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigateToDetail(_:))))
            if let infoData = marker.userData as? ListStory {
                infoView.configure(name: infoData.name, location: "Karawang, Indonesia", image: infoData.photoURL, caption: infoData.description, createdAt: infoData.createdAt)
            }
            mapView.addSubview(infoView)
        }
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        infoView.removeFromSuperview()
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        infoView.center = mapView.projection.point(for: marker.position)
        infoView.center.y = infoView.center.y - 120
        mapView.selectedMarker = nil
    }
}
