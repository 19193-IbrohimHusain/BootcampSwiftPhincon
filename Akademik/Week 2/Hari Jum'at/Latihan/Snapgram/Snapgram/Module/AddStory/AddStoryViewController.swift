import UIKit
import RxSwift
import RxRelay

class AddStoryViewController: UIViewController {

    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var openCamera: UIButton!
    @IBOutlet weak var openGallery: UIButton!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var clearBtn: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var postStoryBtn: UIButton!
    
    let pickerImage = UIImagePickerController()
    let vm = AddStoryViewModel()
    let bag = DisposeBag()
    var uploadResponse: AddStoryResponse?
    private var initialTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction))
        view.addGestureRecognizer(gesture)
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
            
            switch state {
            case .notLoad, .loading:
                return
            case .failed, .finished:
                self.dismiss(animated: true)
            }
        }).disposed(by: bag)
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
        self.present(self.pickerImage, animated: true, completion: nil)
    }
    
    @IBAction func openGallery(_ sender: UIButton) {
        self.pickerImage.allowsEditing = true
        self.pickerImage.delegate = self
        self.pickerImage.sourceType = .photoLibrary
        self.present(self.pickerImage, animated: true, completion: nil)
    }
    
    @IBAction func uploadStory() {
        guard let enteredCaption = captionTextField.text, !enteredCaption.isEmpty else {
            return
        }
        guard let uploadedImage = uploadedImage.image else {
            return
        }
        vm.postStory(param: AddStoryParam(description: enteredCaption, photo: uploadedImage, lat: 0.0, long: 0.0))
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
