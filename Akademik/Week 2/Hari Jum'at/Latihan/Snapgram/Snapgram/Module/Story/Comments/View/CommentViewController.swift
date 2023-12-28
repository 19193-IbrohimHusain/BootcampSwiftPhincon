import UIKit
import FloatingPanel

class CommentViewController: UIViewController {
    // MARK: - Variables
    @IBOutlet weak var commentTable: UITableView!
    @IBOutlet weak var emojiCollection: UICollectionView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var gifBtn: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        commentTable.reloadData()
    }
    
    // MARK: - Functions
    private func setup() {
        commentTable.dataSource = self
        commentTable.registerCellWithNib(CommentTableCell.self)
    }
}

// MARK: - Extension for UITableViewDataSource
extension CommentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CommentTableCell
        
        return cell
    }
    
}
