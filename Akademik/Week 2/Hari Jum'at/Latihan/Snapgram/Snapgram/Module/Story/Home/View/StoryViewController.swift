import UIKit
import RxSwift
import RxCocoa
import RxRelay
import FloatingPanel
import SkeletonView

class StoryViewController: BaseBottomSheetController {
    
    @IBOutlet internal weak var storyTable: UITableView!
    
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
        listStory.removeAll()
        vm.fetchStory(param: StoryTableParam())
    }
    
    private func setup() {
        setupNavigationBar(title: "Snapgram", image1: "bubble.right", image2: "heart", action1: #selector(navigateToDM), action2: nil)
        setupTable()
        bindData()
        setupCommentPanel()
    }
    
    private func bindData() {
        vm.storyData.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self, let validData = data?.listStory else {return}
            self.listStory.append(contentsOf: validData)
        }).disposed(by: bag)
        
        vm.loadingState.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else {return}
            switch state {
            case .notLoad, .loading:
                guard self.isLoadMoreData else {
                    self.storyTable.showAnimatedGradientSkeleton()
                    return
                }
                self.storyTable.showLoadingFooter()
            case .failed, .finished:
                DispatchQueue.main.async {
                    UIView.performWithoutAnimation {
                        self.storyTable.reloadData()
                    }
                    self.storyTable.hideSkeleton()
                }
            }
        }).disposed(by: bag)
    }
    
    private func setupTable() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        storyTable.refreshControl = refreshControl
        storyTable.delegate = self
        storyTable.dataSource = self
        storyTable.registerCellWithNib(FeedTableCell.self)
        storyTable.registerCellWithNib(StoryTableCell.self)
    }
    
    private func setupCommentPanel() {
        setupBottomSheet(contentVC: cvc, floatingPanelDelegate: self)
    }
    
    internal func loadMoreData() {
        page += 1
        isLoadMoreData = true
        vm.fetchStory(param: StoryTableParam(page: page, location: 0))
        storyTable.hideSkeleton()
        isLoadMoreData = false
    }
    
    @objc private func refreshData() {
        self.listStory.removeAll()
        vm.fetchStory(param: StoryTableParam())
        self.refreshControl.endRefreshing()
        self.storyTable.hideLoadingFooter()
    }
    
    @objc private func navigateToDM() {
        
    }
}

extension StoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionStoryTable.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let table = SectionStoryTable(rawValue: section)
        switch table {
        case .story:
            return 1
        case .feed :
            return listStory.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let table = SectionStoryTable(rawValue: indexPath.section)
        switch table {
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
