import UIKit
import RxSwift
import RxCocoa
import RxRelay
import SkeletonView

enum SectionTable: Int, CaseIterable {
    case snap, story
}

class StoryViewController: UIViewController {
    
    
    @IBOutlet weak var storyTable: UITableView!
    
    let bag = DisposeBag()
    var vm = StoryViewModel()
    var page = 0
    var storyResponse: StoryResponse?
    let refreshControl = UIRefreshControl()
    
    var listStory: [ListStory] = [] {
        didSet {
            DispatchQueue.main.async {
                self.storyTable.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.fetchStory(param: StoryTableParam())
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        storyTable.refreshControl = refreshControl
    }
    
    func bindData() {
        vm.storyData.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self else {return}
            if let validData = data, let validStory = validData.listStory {
                self.listStory.append(contentsOf: validStory)
                DispatchQueue.main.async {
                    self.storyTable.reloadData()
                }
            }
        }).disposed(by: bag)
        
        vm.loadingState.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else {return}
            
            switch state {
            case .notLoad, .loading:
                self.storyTable.showAnimatedGradientSkeleton()
            case .failed, .finished:
                DispatchQueue.main.async {
                    self.storyTable.hideSkeleton()
                }
            }
        }).disposed(by: bag)
    }
    
    
    func setupTable(){
        storyTable.delegate = self
        storyTable.dataSource = self
        DispatchQueue.main.async {
            self.storyTable.isSkeletonable = true
        }
        storyTable.registerCellWithNib(StoryTableCell.self)
        storyTable.registerCellWithNib(SnapTableCell.self)
    }
    
    @objc func loadMoreData() {
        page += 1
        self.storyTable.hideSkeleton()
        vm.fetchStory(param: StoryTableParam(page: page, location: 0))
        self.storyTable.hideSkeleton()
        self.refreshControl.endRefreshing()
        self.storyTable.hideLoadingFooter()
    }
    
    @objc func refreshData() {
        self.listStory.removeAll()
        vm.fetchStory(param: StoryTableParam())
        self.refreshControl.endRefreshing()
        self.storyTable.hideLoadingFooter()
    }
}

extension StoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1 :
            return listStory.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let table = SectionTable(rawValue: indexPath.section)
        switch table {
        case .snap:
            let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SnapTableCell
            cell.data = listStory
            cell.delegate = self
            return cell
            
        case .story:
            let cell1 = tableView.dequeueReusableCell(forIndexPath: indexPath) as StoryTableCell
            let storyEntity = listStory[indexPath.row]
            cell1.configure(with: storyEntity)
            cell1.indexSelected = indexPath.row
            cell1.delegate = self
            return cell1
            
        default: return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let total = listStory.count
        if indexPath.row == total - 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.loadMoreData()
            }
            storyTable.showLoadingFooter()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        SharedDataSource.shared.tableViewOffset = scrollView.contentOffset.y
    }
}

extension StoryViewController: SkeletonTableViewDataSource {
    func numSections(in collectionSkeletonView: UITableView) -> Int {
        return 2
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default: return 0
        }
    }
    func collectionSkeletonView(_ tableView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        let table = SectionTable(rawValue: indexPath.section)
        switch table {
        case .snap:
            return String(describing: SnapTableCell.self)
        case .story:
            return String(describing: StoryTableCell.self)
        default: return ""
        }
    }
    
}

extension StoryViewController: StoryTableCellDelegate {
    func addLike(index: Int, isLike: Bool) {
        if isLike {
            storyResponse?.listStory![index].likesCount += 1
            print("menambahkan like index ke \(index)")
        } else {
            storyResponse?.listStory![index].likesCount -= 1
            print("mengurangi like index ke \(index)")
        }
        storyTable.reloadData()
    }
}

extension StoryViewController: SnapTableCellDelegate {
    func navigateToDetail(id: String) {
        let vc = DetailStoryViewController()
        vc.storyID = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

class SharedDataSource {
    static let shared = SharedDataSource()
    var tableViewOffset: CGFloat = 0
}
