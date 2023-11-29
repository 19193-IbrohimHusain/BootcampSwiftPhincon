import UIKit
import RxSwift
import RxCocoa
import RxRelay
import FloatingPanel
import SkeletonView

enum SectionStoryTable: Int, CaseIterable {
    case story, feed
}

class StoryViewController: BaseBottomSheetController {
    
    @IBOutlet internal weak var storyTable: UITableView!
    
    internal var vm = StoryViewModel()
    internal var page = Int()
    internal var isLoadMoreData = false
    internal var listStory = [ListStory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNavigationBar(title: "Snapgram", image1: "bubble.right", image2: "heart", action1: #selector(navigateToDM), action2: nil)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listStory.removeAll()
        vm.fetchStory(param: StoryTableParam())
    }
    
    @objc private func navigateToDM() {
        
    }
}

extension StoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionStoryTable.allCases.count
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
        default:
            break
            
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        SharedDataSource.shared.tableViewOffset = scrollView.contentOffset.y
    }
}
