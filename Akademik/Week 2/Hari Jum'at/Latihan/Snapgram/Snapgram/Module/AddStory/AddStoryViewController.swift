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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindData() {
        vm.addStory.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self else {return}
            if let validData = data {
                self.uploadResponse = validData
            }
        }).disposed(by: bag)
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
