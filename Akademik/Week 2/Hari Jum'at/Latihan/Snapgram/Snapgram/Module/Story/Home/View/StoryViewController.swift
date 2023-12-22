import UIKit
import SkeletonView

class StoryViewController: BaseBottomSheetController {
    
    @IBOutlet internal weak var storyTable: UITableView!
    
    internal let tables = SectionStoryTable.allCases
    private var vm = StoryViewModel()
    private var page = Int()
    private var isLoadMoreData = false
    internal var listStory = [ListStory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.errorView.removeFromSuperview()
    }
    
    private func setup() {
        setupNavigationBar()
        setupErrorView()
        setupTable()
        bindData()
        setupCommentPanel()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: configureNavigationTitle(title: "Snapgram")), animated: false)
        self.navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(navigateToSearch)), animated: true)
    }
    
    private func setupTable() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        storyTable.refreshControl = refreshControl
        storyTable.delegate = self
        storyTable.dataSource = self
        tables.forEach { storyTable.registerCellWithNib($0.cellTypes) }
    }
    
    private func bindData() {
        vm.storyData.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self, let validData = data?.listStory else {return}
            self.listStory.append(contentsOf: validData)
        }).disposed(by: bag)
        
        vm.loadingState.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else {return}
            switch state {
            case .notLoad:
                self.errorView.removeFromSuperview()
            case .loading:
                guard self.isLoadMoreData else {
                    self.storyTable.showAnimatedGradientSkeleton()
                    return
                }
                self.storyTable.showLoadingFooter()
            case .finished:
                DispatchQueue.main.async {
                    UIView.performWithoutAnimation {
                        self.storyTable.reloadData()
                    }
                    self.storyTable.hideSkeleton()
                }
            case .failed:
                DispatchQueue.main.async {
                    self.storyTable.hideLoadingFooter()
                    self.storyTable.hideSkeleton()
                    self.storyTable.backgroundView = self.errorView
                }
            }
        }).disposed(by: bag)
    }
    
    private func setupCommentPanel() {
        setupBottomSheet(contentVC: cvc, floatingPanelDelegate: self)
    }
    
    internal func loadMoreData() {
        page += 1
        isLoadMoreData = true
        vm.fetchStory(param: StoryParam(page: page, location: 0))
        storyTable.hideSkeleton()
        isLoadMoreData = false
    }
    
    @objc private func refreshData() {
        self.listStory.removeAll()
        vm.fetchStory(param: StoryParam())
        self.refreshControl.endRefreshing()
        self.storyTable.hideLoadingFooter()
        self.errorView.removeFromSuperview()
    }
    
    @objc private func navigateToSearch() {
        let vc = SearchUserViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension StoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tables.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableSection = SectionStoryTable(rawValue: section)
        switch tableSection {
        case .story:
            return 1
        case .feed :
            return listStory.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableSection = SectionStoryTable(rawValue: indexPath.section)
        switch tableSection {
        case .story:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as StoryTableCell
            cell.data = listStory
            cell.delegate = self
            
            return cell
        case .feed:
            let cell1 = tableView.dequeueReusableCell(forIndexPath: indexPath) as FeedTableCell
            if !listStory.isEmpty {
                let feedEntity = listStory[indexPath.row]
                cell1.post = feedEntity
            }
            cell1.indexSelected = indexPath.row
            cell1.delegate = self
            
            return cell1
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch SectionStoryTable(rawValue: indexPath.section) {
        case .feed:
            let total = listStory.count
            if indexPath.row == total - 1 {
                loadMoreData()
            }
        default: break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        SharedDataSource.shared.tableViewOffset = scrollView.contentOffset.y
    }
}
