import UIKit
import RxSwift
import SkeletonView

class ProfileViewController: BaseBottomSheetController {
    
    @IBOutlet private weak var profileTable: UITableView!
    
    private let vm = ProfileViewModel()
    private let tables = SectionProfileTable.allCases
    private var currentUser: User?
    private var listStory: [ListStory] = [] {
        didSet {
            DispatchQueue.main.async {
                self.profileTable.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        listStory.removeAll()
        vm.fetchStory(param: StoryTableParam(size: 1000))
    }
    
    private func setup() {
        setupNavigationBar(title: "Profile", image1: "line.horizontal.3", image2: "plus.app", action1: #selector(showSettings), action2: #selector(addStory))
        setupTable()
        bindData()
        setupBottomSheet(contentVC: SettingsViewController(), floatingPanelDelegate: self)
    }
    
    private func setupTable() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        profileTable.refreshControl = refreshControl
        profileTable.delegate =  self
        profileTable.dataSource =  self
        tables.forEach { cell in
            profileTable.registerCellWithNib(cell.cellTypes)
        }
    }
    
    private func bindData() {
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
                DispatchQueue.main.async {
                    self.profileTable.hideSkeleton()
                    self.profileTable.addSubview(self.errorView)
                }
            }
        }).disposed(by: bag)
    }
    
    private func scrollToMenuIndex(sectionIndex: Int) {
        let index = IndexPath(row: 0, section: 2)
        if let cell = profileTable.cellForRow(at: index) as? PostTableCell {
            let indexPath = IndexPath(item: 0, section: sectionIndex)
            cell.postCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    @objc private func addStory() {
        let vc = AddStoryViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    @objc private func showSettings() {
        self.present(floatingPanel, animated: true)
    }
    
    @objc private func refreshData() {
        listStory.removeAll()
        vm.fetchStory(param: StoryTableParam(size: 1000))
        refreshControl.endRefreshing()
        profileTable.hideLoadingFooter()
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
            cell1.delegate = self
            
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

extension ProfileViewController: CategoryTableCellDelegate {
    func setCurrentSection(index: Int) {
        self.scrollToMenuIndex(sectionIndex: index)
    }
}

extension ProfileViewController: PostTableCellDelegate {
    func willEndDragging(contentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = IndexPath(row: 0, section: 1)
        if let cell = profileTable.cellForRow(at: index) as? CategoryTableCell {
            let index = Int(contentOffset.pointee.x / view.frame.width)
            let indexPath = IndexPath(item: index, section: 0)
            cell.categoryCollection.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
    }
    
    func didScroll(scrollView: UIScrollView) {
        let index = IndexPath(row: 0, section: 1)
        if let cell = profileTable.cellForRow(at: index) as? CategoryTableCell {
            cell.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 2
        }
    }
    
    func navigateToDetail(id: String) {
        let vc = DetailStoryViewController()
        vc.storyID = id
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
