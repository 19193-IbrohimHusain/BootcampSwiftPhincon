import UIKit

class MovieViewController: UIViewController {

    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.layer.cornerRadius = 24
        setupTable()
    }
    
    func setupTable() {
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.registerCellWithNib(NPTableViewCell.self)
        homeTableView.registerCellWithNib(PopularTableViewCell.self)
        homeTableView.registerCellWithNib(TopRatedTableViewCell.self)
    }
}

enum sectionTable: Int, CaseIterable {
    case nowPlaying, popular, topRated
}
extension MovieViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTable.allCases.count
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let table = sectionTable.init(rawValue: section)
        switch table {
        case .nowPlaying:
            return 1
        case .popular:
            return 1
        case .topRated:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = sectionTable.init(rawValue: indexPath.section)
        switch section {
        case .nowPlaying:
            let cell = homeTableView.dequeueReusableCell(forIndexPath: indexPath) as NPTableViewCell
            return cell
        case .popular:
            let cell1 = homeTableView.dequeueReusableCell(forIndexPath: indexPath) as PopularTableViewCell
            return cell1
        case .topRated:
            let cell2 = homeTableView.dequeueReusableCell(forIndexPath: indexPath) as TopRatedTableViewCell
            cell2.delegate = self
            return cell2
        default:
            return UITableViewCell()
        }
    }
}

extension MovieViewController: TopRatedTableViewCellDelegate {
    func didTapCell() {
        let dvc = DetailViewController()
        self.navigationController?.present(dvc, animated: true)
    }
}

