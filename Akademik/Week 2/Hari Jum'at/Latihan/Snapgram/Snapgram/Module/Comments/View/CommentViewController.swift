import UIKit
import FloatingPanel

class CommentViewController: UIViewController {
    
    @IBOutlet weak var commentTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        commentTable.delegate = self
        commentTable.dataSource = self
        commentTable.registerCellWithNib(CommentTableCell.self)
    }
}

extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CommentTableCell
        
        return cell
    }
}
