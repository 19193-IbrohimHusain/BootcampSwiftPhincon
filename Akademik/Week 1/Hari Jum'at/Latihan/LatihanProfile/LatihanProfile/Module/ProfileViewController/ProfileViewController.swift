import UIKit
import FloatingPanel

class ProfileViewController: UIViewController {
    
    private var fpc = FloatingPanelController()
    private var fpcOption = FloatingPanelController()

    
    @IBOutlet weak var bgImage: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var imageCollection: UICollectionView!
    
    override func viewDidLoad() {
        bgImage.layer.cornerRadius = 75
        profileImage.layer.cornerRadius = 75
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(editProfile))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGesture)
        super.viewDidLoad()
        setupCollection()
    }
    
    func setupCollection() {
        imageCollection.delegate =  self
        imageCollection.dataSource =  self
        imageCollection.registerCellWithNib(ProfileCollectionViewCell.self)
    }
    
    @objc func editProfile(_ sender: UITapGestureRecognizer) {
        fpc.delegate = self
        fpc.layout = MyFloatingPanelLayout()
        fpc.surfaceView.appearance.cornerRadius = 16
        fpc.contentMode = .fitToBounds
        let vc = ProfileBottomSheetViewController()
        vc.delegate = self
        fpc.set(contentViewController: vc)
        self.present(fpc, animated: true)
    }
    
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as ProfileCollectionViewCell
        let profileEntity = collectionItem[indexPath.row]
        cell.configureCollection(with: profileEntity)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let itemWidth = collectionViewWidth / 3.0
        return CGSize(width: itemWidth, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension ProfileViewController: FloatingPanelControllerDelegate {
    
    func floatingPanelWillEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetState: UnsafeMutablePointer<FloatingPanelState>) {
        if targetState.pointee != .full {
            vc.dismiss(animated: true)
        }
    }
}

extension ProfileViewController: ProfileBottomSheetViewControllerDelegate {
    func showChoice() {
        fpc.dismiss(animated: true)
        fpcOption.delegate = self
        fpcOption.layout = MyFloatingPanelLayout()
        fpcOption.surfaceView.appearance.cornerRadius = 16
        fpcOption.contentMode = .fitToBounds
        let vc = PictureOptionBottomSheetViewController()
        vc.delegate = self
        fpcOption.set(contentViewController: vc)
        self.present(fpcOption, animated: true)
    }
    
    func removeProfilePic() {
        self.profileImage.image = UIImage(systemName: "person.circle")
        fpc.dismiss(animated: true)
    }
}

extension ProfileViewController: PictureOptionBottomSheetViewControllerDelegate {
    func addNewProfile(image: [UIImagePickerController.InfoKey : Any]) {
        fpcOption.dismiss(animated: true)
        guard let image = image[.editedImage] as? UIImage else { return }
        self.profileImage.image = image
        fpcOption.dismiss(animated: true)
    }

}


class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .half
    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
        .half: FloatingPanelLayoutAnchor(fractionalInset: 0.2, edge: .bottom, referenceGuide: .safeArea),
    ]
}
