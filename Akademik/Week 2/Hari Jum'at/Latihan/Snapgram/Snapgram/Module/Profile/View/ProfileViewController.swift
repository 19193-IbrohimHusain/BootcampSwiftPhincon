import UIKit
import RxSwift
import SkeletonView
import FloatingPanel

class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var profileTable: UITableView!
    
    private let vm = ProfileViewModel()
    private let tables = SectionProfileTable.allCases
    private var currentUser: User?
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
        listStory.removeAll()
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
        tables.forEach { cell in
            profileTable.registerCellWithNib(cell.cellTypes)
        }
    }
    
    func bindData() {
        vm.storyData.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self else { return }
            if let savedUser = BaseConstant.userDef.data(forKey: "userData") {
                do {
                    self.currentUser = try JSONDecoder().decode(User.self, from: savedUser)
                    if let story = data?.listStory {
                        let filteredStory = story.filter { $0.name == self.currentUser?.username }
                        self.listStory.append(contentsOf: filteredStory)
                    }
                } catch {
                    print("Error decoding user data: \(error)")
                }
            }
        }).disposed(by: bag)
        
        vm.loadingState.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else {return}
            switch state {
            case .notLoad:
                self.errorView.removeFromSuperview()
            case .loading:
                self.profileTable.showAnimatedGradientSkeleton()
            case .finished:
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.profileTable.hideSkeleton()
                }
            case .failed:
                self.profileTable.addSubview(self.errorView)
            }
        }).disposed(by: bag)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tables.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableSection = SectionProfileTable(rawValue: section)
        switch tableSection {
        case .profile, .category, .post:
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
            if let user = currentUser {
                cell.configure(with: user)
            }
            cell.delegate = self
            return cell
        case .category:
            let cell1 = tableView.dequeueReusableCell(forIndexPath: indexPath) as CategoryTableCell
            return cell1
        case .post:
            let cell2 = tableView.dequeueReusableCell(forIndexPath: indexPath) as PostTableCell
            cell2.delegate = self
            cell2.configure(data: listStory)
            
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
        BaseConstant.userDef.removeObject(forKey: "userData")
        let vc = LoginViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.setViewControllers([vc], animated: true)
    }
    
    func discover() {
        let dvc = EditProfileViewController()
        dvc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(dvc, animated: true)
    }
}

extension ProfileViewController: PostTableCellDelegate {
    func navigateToDetail(id: String) {
        let vc = DetailStoryViewController()
        vc.storyID = id
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
