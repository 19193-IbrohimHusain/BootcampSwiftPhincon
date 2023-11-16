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
    var page = Int()
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
        setup()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        storyTable.refreshControl = refreshControl
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
        
        switch SectionTable(rawValue: indexPath.section) {
        case .story:
            let total = listStory.count
            if indexPath.row == total - 1 {
                DispatchQueue.main.asyncAfter(wallDeadline: .now() + 3 ) {
                    self.loadMoreData()
                }
                self.storyTable.showLoadingFooter()
            }
        default:
            break
            
        }
      
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        SharedDataSource.shared.tableViewOffset = scrollView.contentOffset.y
    }
}
