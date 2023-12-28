import UIKit
import RxSwift
import RxRelay

class AddStoryViewController: BaseViewController {
    // MARK: - Variables
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var openCamera: UIButton!
    @IBOutlet weak var openGallery: UIButton!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var enableLocation: UISwitch!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var postStoryBtn: UIButton!
    @IBOutlet weak var scrollableHeight: NSLayoutConstraint!
    
    let vm = AddStoryViewModel()
    var uploadResponse: AddStoryResponse?
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - Functions
    private func setup() {
        postStoryBtn.layer.cornerRadius = 8.0
        scrollView.delegate = self
        scrollableHeight.constant = view.bounds.height + 50
        bindData()
        btnEvent()
    }
    
    private func bindData() {
        vm.addStory.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self else {return}
            if let validData = data {
                self.uploadResponse = validData
            }
        }).disposed(by: bag)
        
        vm.loadingState.asObservable().subscribe(onNext: { [weak self] state in
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
    
    private func btnEvent() {
        openCamera.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.openPicker(sourceType: .camera)
        }).disposed(by: bag)
        openGallery.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.openPicker(sourceType: .photoLibrary)
        }).disposed(by: bag)
        enableLocation.rx.isOn.subscribe(onNext: { [weak self] state in
            guard let self = self else { return }
            self.handleLocationSwitch(state)
        }).disposed(by: bag)
        locationLabel.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.locationHandler()
        }).disposed(by: bag)
        postStoryBtn.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.uploadStory()
        }).disposed(by: bag)
    }
    
    private func handleLocationSwitch(_ state: Bool) {
        state ? locationHandler() : (locationLabel.text = nil)
        locationLabel.isHidden = !state
    }
    
    private func locationHandler() {
        checkLocationAuthorization(map)
        getAddressFromCurrentLocation(lat: latitude, lon: longitude) { _ in
            self.getAddressFromCurrentLocation(lat: self.latitude, lon: self.longitude) { name in
                self.locationLabel.text = name
            }
        }
    }
    
    private func openPicker(sourceType: UIImagePickerController.SourceType) {
        self.pickerImage.allowsEditing = true
        self.pickerImage.delegate = self
        self.pickerImage.sourceType = sourceType
        if sourceType == .camera { self.pickerImage.showsCameraControls = true }
        self.present(self.pickerImage, animated: true, completion: nil)
    }
    
    private func uploadStory() {
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
        let lat = (latitude == 0.0) ? nil : Float(latitude)
        let lon = (longitude == 0.0) ? nil : Float(longitude)
        vm.postStory(param: AddStoryParam(description: enteredCaption, photo: uploadedImage, lat: lat, lon: lon))
    }
}

// MARK: - Extension for UIImagePickerController and UINavigationControllerDelegate
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

// MARK: - Extension for UIScrollViewDelegate
extension AddStoryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -80 {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
