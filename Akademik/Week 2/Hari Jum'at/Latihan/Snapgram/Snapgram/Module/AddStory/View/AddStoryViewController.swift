import UIKit
import RxSwift
import RxRelay

class AddStoryViewController: BaseViewController {

    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var openCamera: UIButton!
    @IBOutlet weak var openGallery: UIButton!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var postStoryBtn: UIButton!
    
    let vm = AddStoryViewModel()
    var uploadResponse: AddStoryResponse?
    private var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postStoryBtn.layer.cornerRadius = 8.0
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction))
        view.addGestureRecognizer(gesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        locationLabel.isUserInteractionEnabled = true
        locationLabel.addGestureRecognizer(tapGesture)
        bindData()
    }
    
    func bindData() {
        vm.addStory.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self else {return}
            if let validData = data {
                self.uploadResponse = validData
            }
        }).disposed(by: bag)
        
        vm.loadingState.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else {return}
            
            DispatchQueue.main.async {
                switch state {
                case .notLoad:
                    self.afterDissmissed(self.postStoryBtn, title: "Post Story")
                case .loading:
                    self.addLoading(self.postStoryBtn)
                case .failed:
                    self.afterDissmissed(self.postStoryBtn, title: "Post Story")
                    if let error = self.uploadResponse?.message {
                        self.displayAlert(title: "Upload Story Failed", message: "\(String(describing: error)), Please try again")
                    }
                case .finished:
                    self.afterDissmissed(self.postStoryBtn, title: "Post Story")
                    if let message = self.uploadResponse?.message {
                        self.displayAlert(title: message, message: "Please continue to home") {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }).disposed(by: bag)
    }
    
    @objc func tapAction(_ tap: UITapGestureRecognizer) {
        checkLocationAuthorization(map)
        getAddressFromCurrentLocation(lat: latitude, lon: longitude) { _ in
            self.getAddressFromCurrentLocation(lat: self.latitude, lon: self.longitude) { name in
                self.locationLabel.text = name
            }
        }
    }
    
    @objc func panGestureAction(_ gesture: UIPanGestureRecognizer) {
            let touchPoint = gesture.translation(in: view.window)
            if gesture.state == .began {
                initialTouchPoint = touchPoint
            } else if gesture.state == .changed {
                let newTouchPoint = touchPoint
                if newTouchPoint.y - initialTouchPoint.y > 0 {
                    view.frame = CGRect(x: 0, y: newTouchPoint.y - initialTouchPoint.y, width: view.frame.size.width, height: view.frame.size.height)
                }
            } else if gesture.state == .ended {
                let velocity = gesture.velocity(in: view)
                if velocity.y >= 1000 || touchPoint.y - initialTouchPoint.y > 200 {
                    dismiss(animated: true, completion: nil)
                } else {
                    UIView.animate(withDuration: 0.3) {
                        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                    }
                }
            }
        }
    
    @IBAction func openCamera(_ sender: UIButton) {
        self.pickerImage.allowsEditing = true
        self.pickerImage.delegate = self
        self.pickerImage.sourceType = .camera
        self.pickerImage.showsCameraControls = true
        self.present(self.pickerImage, animated: true, completion: nil)
    }
    
    @IBAction func openGallery(_ sender: UIButton) {
        self.pickerImage.allowsEditing = true
        self.pickerImage.delegate = self
        self.pickerImage.sourceType = .photoLibrary
        self.present(self.pickerImage, animated: true, completion: nil)
    }
    
    @IBAction func uploadStory() {
        addLoading(postStoryBtn)
        
        guard let enteredCaption = captionTextField.text, !enteredCaption.isEmpty else {
            displayAlert(title: "Upload Story Failed", message: "Please enter your caption") {
                self.afterDissmissed(self.postStoryBtn, title: "Post Story")
            }
            return
        }
        guard let uploadedImage = uploadedImage.image else {
            displayAlert(title: "Upload Story Failed", message: "Please select your image") {
                self.afterDissmissed(self.postStoryBtn, title: "Post Story")
            }
            return
        }
        if latitude == 0.0 && longitude == 0.0 {
            vm.postStory(param: AddStoryParam(description: enteredCaption, photo: uploadedImage, lat: nil, lon: nil))
        } else {
            let lat = Float(latitude)
            let lon = Float(longitude)
            vm.postStory(param: AddStoryParam(description: enteredCaption, photo: uploadedImage, lat: lat, lon: lon))
        }
    }
}

extension AddStoryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        uploadedImage.image = image
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
