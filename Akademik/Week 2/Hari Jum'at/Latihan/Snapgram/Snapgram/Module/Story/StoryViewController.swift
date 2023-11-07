import UIKit

enum SectionTable: Int, CaseIterable {
    case snap, story
}

class StoryViewController: UIViewController {
    
    
    @IBOutlet weak var storyTable: UITableView!
    
    var storyResponse: StoryResponse? {
        didSet {
            DispatchQueue.main.async {
                self.storyTable.reloadData()
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        fetchStory()
    }
    

    
    func setupTable(){
        storyTable.delegate = self
        storyTable.dataSource = self
        storyTable.registerCellWithNib(StoryTableCell.self)
        storyTable.registerCellWithNib(SnapTableCell.self)
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
            return storyResponse?.listStory?.count ?? 0
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let table = SectionTable(rawValue: indexPath.section)
        switch table {
        case .snap:
            if let validData = storyResponse, let storyItem = validData.listStory {
                let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as SnapTableCell
                cell.data = storyItem
                return cell
            }
            return UITableViewCell()
        case .story:
            if let validData = storyResponse, let storyItem = validData.listStory {
                let cell1 = tableView.dequeueReusableCell(forIndexPath: indexPath) as StoryTableCell
                let storyEntity = storyItem[indexPath.row]
                cell1.configure(with: storyEntity)
                cell1.indexSelected = indexPath.row
                cell1.delegate = self
                return cell1
            }
            return UITableViewCell()
        default: return UITableViewCell()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        SharedDataSource.shared.tableViewOffset = scrollView.contentOffset.y
    }
    
    func fetchStory() {
        APIManager.shared.fetchRequest(endpoint: .fetchStory, expecting: StoryResponse.self) { [weak self] result in
            switch result {
            case .success(let model):
                print(model)
                self?.storyResponse = model
            case .failure(let error):
                print(String(describing: error))
            }
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

class SharedDataSource {
    static let shared = SharedDataSource()
    var tableViewOffset: CGFloat = 0
}
