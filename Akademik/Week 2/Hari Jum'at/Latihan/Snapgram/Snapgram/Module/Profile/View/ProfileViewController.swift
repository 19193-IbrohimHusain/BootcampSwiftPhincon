import UIKit
import RxSwift
import SkeletonView
import FloatingPanel

class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileTable: UITableView!
    @IBOutlet weak var logoutBtn: UIButton!
    
    private let vm = ProfileViewModel()
    private var fpc = FloatingPanelController()
    private var fpcOption = FloatingPanelController()
    private var listStory: [ListStory] = [] {
        didSet {
            DispatchQueue.main.async {
                self.profileTable.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        setupNavigationBar()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        vm.fetchStory(param: StoryTableParam(size: 1000))
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: configureNavigationTitle(title: "Profile")), animated: false)
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "plus.app"), style: .plain, target: self, action: #selector(addStory))
        ]
    }
    
    @objc func addStory() {
        let vc = AddStoryViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    func setupTable() {
        profileTable.delegate =  self
        profileTable.dataSource =  self
        profileTable.registerCellWithNib(ProfileTableCell.self)
        profileTable.registerCellWithNib(CategoryTableCell.self)
        profileTable.registerCellWithNib(PostTableCell.self)
    }
    
    func bindData() {
        vm.storyData.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self else { return }
            if let story = data?.listStory {
                self.listStory.append(contentsOf: story)
            }
        }).disposed(by: bag)
        
        vm.loadingState.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else {return}
            switch state {
            case .notLoad, .loading:
                self.profileTable.showAnimatedGradientSkeleton()
            case .failed, .finished:
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.profileTable.hideSkeleton()
                }
            }
        }).disposed(by: bag)
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
    
    @IBAction func onLogoutBtnTap() {
        deleteToken()
        let vc = LoginViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.setViewControllers([vc], animated: true)
    }
}

enum SectionProfileTable: Int, CaseIterable {
    case profile, category, post
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let table = SectionProfileTable(rawValue: indexPath.section)
        switch table {
        case .profile:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as ProfileTableCell
            cell.delegate = self
            return cell
        case .category:
            let cell1 = tableView.dequeueReusableCell(forIndexPath: indexPath) as CategoryTableCell
            return cell1
        case .post:
            let cell2 = tableView.dequeueReusableCell(forIndexPath: indexPath) as PostTableCell
            return cell2
        default: return UITableViewCell()
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        SharedDataSource.shared.tableViewOffset = scrollView.contentOffset.y
    }
    
}

extension ProfileViewController: ProfileTableCellDelegate {
    func editProfile() {
        let epvc = EditProfileViewController()
        epvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(epvc, animated: true)
    }
    
    func shareProfile() {
        deleteToken()
        let vc = LoginViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.setViewControllers([vc], animated: true)
    }
    
    func discover() {
        let dvc = EditProfileViewController()
        self.navigationController?.pushViewController(dvc, animated: true)
    }
}

extension ProfileViewController {
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
        self.profileImage.image = UIImage(named: "Blank")
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
