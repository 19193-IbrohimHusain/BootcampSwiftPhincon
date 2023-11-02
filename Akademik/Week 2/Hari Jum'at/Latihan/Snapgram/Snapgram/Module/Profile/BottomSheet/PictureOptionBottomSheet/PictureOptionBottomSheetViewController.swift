import UIKit

protocol PictureOptionBottomSheetViewControllerDelegate {
    func addNewProfile(image: [UIImagePickerController.InfoKey : Any])
}
class PictureOptionBottomSheetViewController: UIViewController {
    
    @IBOutlet weak var tapCamera: UIStackView!
    @IBOutlet weak var tapGallery: UIStackView!
    
    let pickerImage = UIImagePickerController()
    var delegate: PictureOptionBottomSheetViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        // Camera Tap Gesture
        let cameraTapGesture = UITapGestureRecognizer(target: self, action: #selector(onCameraTap))
        tapCamera.isUserInteractionEnabled = true
        tapCamera.addGestureRecognizer(cameraTapGesture)
        
        // Gallery Tap Gesture
        let galleryTapGesture = UITapGestureRecognizer(target: self, action: #selector(onGalleryTap))
        tapGallery.isUserInteractionEnabled = true
        tapGallery.addGestureRecognizer(galleryTapGesture)
    }
    
    @objc func onCameraTap(_ sender: UITapGestureRecognizer) {
        self.pickerImage.allowsEditing = true
        self.pickerImage.delegate = self
        self.pickerImage.sourceType = .camera
        self.present(self.pickerImage, animated: true, completion: nil)
    }
    
    @objc func onGalleryTap(_ sender: UITapGestureRecognizer) {
        self.pickerImage.allowsEditing = true
        self.pickerImage.delegate = self
        self.pickerImage.sourceType = .photoLibrary
        self.present(self.pickerImage, animated: true, completion: nil)
    }
}

extension PictureOptionBottomSheetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let _ = info[.editedImage] as? UIImage else { return }
        self.delegate?.addNewProfile(image: info)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
