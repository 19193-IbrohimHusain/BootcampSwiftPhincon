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

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
                if CLLocationManager.locationServicesEnabled() {
                    locationManager.requestLocation()
                    mapView.isMyLocationEnabled = true
                    mapView.settings.myLocationButton = true
                } else {
                    locationManager.requestWhenInUseAuthorization()
                }
        

    

        // Do any additional setup after loading the view.
        let camera = GMSCameraPosition.camera(withLatitude: 37.36, longitude: -122.0, zoom: 6.0)
        mapView.camera = camera
        mapView.settings.myLocationButton = true
        mapView.animate(toZoom: zoom)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.fetchLocationStory(param: StoryTableParam(size: 100, location: 1))
        vm.mapData.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self else {return}
            self.listMarker.append(contentsOf: data?.listStory ?? [])
            DispatchQueue.main.async {
                self.listMarker.forEach { item in
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: item.lat ?? 0.0, longitude: item.lon ?? 0.0)
                    marker.title = item.name
                    marker.snippet = item.description
                    marker.map = self.mapView
                    
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

    /* handles Info Window long press */
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("didLongPressInfoWindowOf")
    }

    
    // MARK: - Navigation
    /* set a custom Info Window */
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let infoWindow = CustomInfoView()
        listMarker.forEach { item in
            infoWindow.setup(name: item.name, location: item.id, captions: item.description, created: item.createdAt)
        }
        
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 70))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6
        
        let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
        lbl1.text = "Hi there!"
        view.addSubview(lbl1)
        
        let lbl2 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y + lbl1.frame.size.height + 3, width: view.frame.size.width - 16, height: 15))
        lbl2.text = "I am a custom info window."
        lbl2.font = UIFont.systemFont(ofSize: 14, weight: .light)
        view.addSubview(lbl2)
        

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
}
